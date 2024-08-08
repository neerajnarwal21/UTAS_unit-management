//
//  ChildViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 07/05/21.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseFirestoreSwift

class ChildViewController: UIViewController,IndicatorInfoProvider{
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var backgroundView: UIView!
    var childNumber: String = ""
    var tutorialArray: [TutorialsModel]?
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tutorialTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTutorials { (array, error) in
            // wait for tutorial array
                self.getStudents()
        }
        self.addRefreshControl()
        self.setNavigationBarColor(color:UIColor(red: 31.0/255.0, green: 0.0/255.0, blue: 169.0/255.0, alpha: 1))
        self.addNewButton.layer.cornerRadius = self.addNewButton.frame.width/2
    }
    
    func addRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tutorialTableView.refreshControl = refreshControl
        } else {
            self.tutorialTableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor.init(hex: Constant.appcolor.primaryColor)
        refreshControl.attributedTitle = NSAttributedString(string:Constant.Statictext.pullToRefresh, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: Constant.appcolor.primaryColor) ?? .black])
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        self.getTutorials { (array, error) in
            // wait for tutorial array
//            if FireBaseManager.sharedInstance.studentsAray.count  == 0 {
                self.getStudents()
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTutorials { (array, error) in
            // wait for tutorial array
                self.getStudents()
        }
    }
    
    func getTutorials(completion:@escaping (_ result: [TutorialsModel]?,_ error: String?) -> Void) {
        FireBaseManager.sharedInstance.getDataFromFirebase(tableName: Constant.firebaseTableName.tutorial) { (resultArray, error) in
            if error == nil{
                self.tutorialArray = [TutorialsModel]()
                //loop through the results
                for document in resultArray!{
                    print("\(document.documentID)")
                    //                    //attempt to convert to object
                    print(document.documentID)
                    let conversionResult = Result{
                        try document.data(as: TutorialsModel.self)
                        
                        
                    }
                    //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                    switch conversionResult{
                    //no problems (but could still be nil)
                    case .success(let convertedDoc):
                        if let newObject = convertedDoc{
                            // A `custom object` value was successfully initialized from the DocumentSnapshot.
                            print("newObject: \(newObject)")
                            
                            /*
                             var totalScore = 0
                             week.list.forEach { tutorial ->
                             totalScore += tutorial.totalMarks
                             }
                             holder.ui.classAvgTV.text =
                             "Class avg: ${(totalScore.toFloat() / week.list.size).roundToInt()}%"
                             */
                            var scorevalue = 0
                          let  newTotalscorevalue = newObject.list?.map{ $0.totalMarks ?? 0}
                            if let checkListCount = newObject.list?.count {
                                scorevalue = (newTotalscorevalue?.reduce(0, +) ?? 0)/checkListCount
                            }
                            print(document.documentID)
                            let replceObj = TutorialsModel(documentId:document.documentID, list: newObject.list, tuteType: newObject.tuteType, weekNo: newObject.weekNo, average:scorevalue)
                            print("Score \(scorevalue)")
                            print("after change \(replceObj)")
                            // perform action and change the values
//                            newObject.average = scorevalue
                            self.tutorialArray?.append(replceObj)
                        }
                        else{
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            Utility.showAlertWithTitle(title:Constant.Statictext.documentnotExist , message: "", controller: self)
                        }
                    case .failure(let error):
                        // A `custom 0object` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding customObject: \(error)")
                        Utility.showAlertWithTitle(title:error.localizedDescription , message: "", controller: self)
                    }
                }
                // after loop ends
                print(self.tutorialArray?.count ?? 0)
                
                /*
                 var totalScore = 0
                 week.list.forEach { tutorial ->
                 totalScore += tutorial.totalMarks
                 }
                 holder.ui.classAvgTV.text =
                 "Class avg: ${(totalScore.toFloat() / week.list.size).roundToInt()}%"
                 */
                
                let newArr = self.tutorialArray?.sorted(by: { $0.weekNo ?? 0 < $1.weekNo ?? 0 })
                self.tutorialArray = newArr
                FireBaseManager.sharedInstance.tutorialArray = self.tutorialArray
                print(self.tutorialArray?.count ?? 0)
                self.setBackgroundView()
                self.tutorialTableView.reloadData()
                completion(self.tutorialArray,"")
                
            }
            else{
                // error case
                Utility.showAlertWithTitle(title: Constant.Statictext.somethingWentWrong, message: "", controller: self)
                self.setBackgroundView()
            }
        }
    }
    
    func setBackgroundView()  {
        if(tutorialArray?.count ?? 0 > 0){
            self.tutorialTableView.backgroundView = nil
        }
        else{
            self.tutorialTableView.backgroundView = backgroundView
        }
    }
    
    func getStudents() {
        FireBaseManager.sharedInstance.getDataFromFirebase(tableName: Constant.firebaseTableName.student) { (resultArray, error) in
            if error == nil{
                var studentsAray = [StudentModel]()
               
                //loop through the results
                for document in resultArray!{
                    //                    //attempt to convert to object
                    print(document.documentID)
                    let conversionResult = Result{
                        try document.data(as: StudentModel.self)
                        
                    }
                    //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                    switch conversionResult{
                    //no problems (but could still be nil)
                    case .success(let convertedDoc):
                        if let newObject = convertedDoc{
                            // A `custom object` value was successfully initialized from the DocumentSnapshot.
                            print("newObject: \(newObject)")
                            
                            if FireBaseManager.sharedInstance.tutorialArray?.count ?? 0 > 0 {
                                var totalScore = 0
                                for item in FireBaseManager.sharedInstance.tutorialArray ?? [] {
                                    for newItem in item.list ?? [] {
                                        if(newItem.studentId == newObject.id){
                                            totalScore += newItem.totalMarks ?? 0
                                            print(totalScore)
                                        }
                                    }
                                }
                                
                                let average = totalScore / (FireBaseManager.sharedInstance.tutorialArray?.count ?? 0)
                                let replaceObj = StudentModel(documentId:document.documentID, active: newObject.active, id: newObject.id, name: newObject.name, photoURL: newObject.photoURL, average: average)
                                studentsAray.append(replaceObj)
                            }
                            else{
                                let replaceObj = StudentModel(documentId:document.documentID, active: newObject.active, id: newObject.id, name: newObject.name, photoURL: newObject.photoURL, average: 0)
                                studentsAray.append(replaceObj)
                                // no tutorial foyund
                            }
                        }
                        else{
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            Utility.showAlertWithTitle(title:Constant.Statictext.documentnotExist , message: "", controller: self)
                        }
                    case .failure(let error):
                        // A `custom 0object` value could not be initialized from the DocumentSnapshot.
                        Utility.showAlertWithTitle(title:error.localizedDescription , message: "", controller: self)
                        print("Error decoding customObject: \(error)")
                    }
                }
                // after loop ends
                let newArr = studentsAray.sorted(by: { $0.id ?? "" < $1.id ?? "" })
                print(newArr.count)
                let activeStudents = newArr.filter({$0.active == 1})
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                // save to shareds obhject
                FireBaseManager.sharedInstance.studentsAray = activeStudents
                print(FireBaseManager.sharedInstance.studentsAray.count)
               
                
            }
            else{
                // error case
                Utility.showAlertWithTitle(title: Constant.Statictext.somethingWentWrong, message: "", controller: self)
            }
        }
    }

    @IBAction func didTapNewButton(_ sender: UIButton) {
        _ = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: Constant.storyboard.main, bundle: nil))
        let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.ceateNewTutorial) as! CreateNewTutorialViewController
        vc.title = Constant.Statictext.title
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constant.Statictext.tutorial)
    }

}

extension ChildViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tutorialArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialTableViewCell") as! TutorialTableViewCell
        cell.selectionStyle = .none
        cell.tutorialObj = self.tutorialArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: Constant.storyboard.main, bundle: nil))
        let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.weeklyList) as! WeeklyListViewController
        vc.title = Constant.Statictext.title
        vc.weeklyListFor = self.tutorialArray?[indexPath.row].tuteType?.getTuteTypeEnum()
        vc.selectedTutorial = self.tutorialArray?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
