//
//  StudentDetailViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 11/05/21.
//

import UIKit

class StudentDetailViewController: UIViewController {

    @IBOutlet weak var studentDetailTable: UITableView!
    var studentObj: StudentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
       // self.studentDetailTable.tableHeaderView = StudentDetailHeaderTableViewCell()

        // Do any additional setup after loading the view.
    }
    
    func registerCell()  {
        self.studentDetailTable.register(UINib(nibName: Constant.cellIdentifier.studentdetailheardertableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.studentdetailheardertableviewcell)
        
        self.studentDetailTable.register(UINib(nibName: Constant.cellIdentifier.studentdetailcelltableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.studentdetailcelltableviewcell)
    }
}

extension StudentDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.studentdetailheardertableviewcell) as! StudentDetailHeaderTableViewCell
        cell.studentobj = self.studentObj
        cell.didTapButton = { buttonTag in
            if buttonTag == 1 {
                //  edit
                self.moveToStudentProfile()
            }
            else if buttonTag == 2{
                // delete
                self.deleteUser()
            }
            else{
                //share
//                let totalMarks =
                var string = ""
                var weekandMarks = ""
                for item in FireBaseManager.sharedInstance.tutorialArray ?? [] {
                    if let matchedweeks = item.list?.filter({$0.studentId == self.studentObj?.id}) {
                        for matcheditems in matchedweeks {
                            weekandMarks += " Week \(item.weekNo ?? 0)=\(matcheditems.totalMarks ?? 0),"
                        }
                    }
                    
                }
                
                string += "Name: \(self.studentObj?.name ?? ""), Student ID: \(self.studentObj?.id ?? ""), Avg: \(self.studentObj?.average ?? 0) Marks: \(weekandMarks)"
                
                 let textShare = [ string.deletingPostfix(",") ]
                 let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                 activityViewController.popoverPresentationController?.sourceView = self.view
                 self.present(activityViewController, animated: true, completion: nil)
                
            }
            
        }
        cell.backgroundColor = .white
        return cell
        //cell.studentObj = self.studentsAray?[indexPath.row]
    }
    
    func moveToStudentProfile() {
        print("document Id=> \(self.studentObj?.documentId ?? "")")
        _ = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: Constant.storyboard.main, bundle: nil))
        let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.createstudentviewcontroller) as! CreateStudentViewController
        vc.title = Constant.Statictext.title
        vc.comingFor = .none
        vc.student = self.studentObj
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func deleteUser() {
        let alert = UIAlertController(title: Constant.Statictext.alertTitle, message: "", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: Constant.Statictext.yesIwill, style: .default) { (alertAction) in
            self.updateRecordToFirebase()
        }
        let cancel = UIAlertAction(title: Constant.Statictext.cancel, style: .destructive) { (action) in
            
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func updateRecordToFirebase()  {
        let newDict = ["active":0,"id":studentObj?.id ?? "","name":studentObj?.name ?? "","photoURL":studentObj?.photoURL ?? ""] as [String:Any]
        
        FireBaseManager.sharedInstance.update(tableName: Constant.firebaseTableName.student, tableRefID: self.studentObj?.documentId ?? "", withData: newDict) { (isSucess, message, errorMessage) in
            if isSucess == true{
                print("Got Sucess update")
                let alert = UIAlertController(title:Constant.Statictext.deletedTitle, message: "", preferredStyle: .alert)
                let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(ok)
                //.actions[ok,cancel]
                self.navigationController?.present(alert, animated: true, completion:nil)
            }
            else{
                print("Got failure update")
                let alert = UIAlertController(title:Constant.Statictext.somethingWentWrong, message: "", preferredStyle: .alert)
                let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                    
                }
                alert.addAction(ok)
                self.navigationController?.present(alert, animated: true, completion:nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FireBaseManager.sharedInstance.tutorialArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.studentdetailcelltableviewcell) as! StudentDetailCellTableViewCell
        cell.studentObj = self.studentObj
        cell.tutorialObj = FireBaseManager.sharedInstance.tutorialArray?[indexPath.row]
        return cell
    }
    
    
}
