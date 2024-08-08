//
//  SecondChildViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 07/05/21.
//

import UIKit
import XLPagerTabStrip

class SecondChildViewController: UIViewController,IndicatorInfoProvider{
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var backgroundView: UIView!
    var studentsAray: [StudentModel]?
    var orignalArray: [StudentModel]?
    
    @IBOutlet weak var studentTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constant.Statictext.student)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = self.addButton.frame.width/2
        self.addRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTutorials()
        self.getStudents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    func addRefreshControl() {
        if #available(iOS 10.0, *) {
            self.studentTableView.refreshControl = refreshControl
        } else {
            self.studentTableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor.init(hex: Constant.appcolor.primaryColor)
        refreshControl.attributedTitle = NSAttributedString(string:Constant.Statictext.pullToRefresh, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: Constant.appcolor.primaryColor) ?? .black])
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.getTutorials()
        self.getStudents()
    }
    
    func getStudents() {
        FireBaseManager.sharedInstance.getDataFromFirebase(tableName: Constant.firebaseTableName.student) { (resultArray, error) in
            if error == nil{
                self.studentsAray = [StudentModel]()
                self.orignalArray = [StudentModel]()
                //loop through the results
                for document in resultArray!{
                    //                    //attempt to convert to object
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
                                print(average)
                                print(newObject.name)
                                
                                let replaceObj = StudentModel(documentId:document.documentID,active: newObject.active, id: newObject.id, name: newObject.name, photoURL: newObject.photoURL, average: average)
                                self.studentsAray?.append(replaceObj)
                            }
                            else{
                                let replaceObj = StudentModel(documentId:document.documentID,active: newObject.active, id: newObject.id, name: newObject.name, photoURL: newObject.photoURL, average: 0)
                                self.studentsAray?.append(replaceObj)
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
                        print("Error decoding customObject: \(error)")
                        Utility.showAlertWithTitle(title:error.localizedDescription , message: "", controller: self)
                    }
                }
                // after loop ends
                print(self.studentsAray?.count ?? 0)
                let newArr = self.studentsAray?.sorted(by: { $0.id ?? "" < $1.id ?? "" })
                let activeStudents = newArr?.filter({$0.active == 1})
                self.studentsAray = activeStudents
                self.orignalArray = activeStudents
                self.studentsAray = activeStudents
                print(self.studentsAray?.count ?? 0)
                self.studentTableView.reloadData()
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                self.setBackgroundView()
            }
            else{
                // error case
                Utility.showAlertWithTitle(title: Constant.Statictext.somethingWentWrong, message: "", controller: self)
                self.setBackgroundView()
            }
        }
    }
    
    func setBackgroundView()  {
        if(studentsAray?.count ?? 0 > 0){
            self.studentTableView.backgroundView = nil
        }
        else{
            self.studentTableView.backgroundView = backgroundView
        }
    }
    
    func getTutorials() {
        FireBaseManager.sharedInstance.getDataFromFirebase(tableName: Constant.firebaseTableName.tutorial) { (resultArray, error) in
            if error == nil{
                var tutorialArray = [TutorialsModel]()
                //loop through the results
                for document in resultArray!{
                    //                    //attempt to convert to object
                    let conversionResult = Result{
                        try document.data(as: TutorialsModel.self)
                        
                    }
                    print(document.documentID)
                    //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                    switch conversionResult{
                    //no problems (but could still be nil)
                    case .success(let convertedDoc):
                        if let newObject = convertedDoc{
                            // A `custom object` value was successfully initialized from the DocumentSnapshot.
                            print("newObject: \(newObject)")
                            var scorevalue = 0
                            let  newTotalscorevalue = newObject.list?.map{ $0.totalMarks ?? 0}
                            scorevalue = (newTotalscorevalue?.reduce(0, +) ?? 0)/newObject.list!.count ?? 0
                            
                            let replceObj = TutorialsModel(documentId:document.documentID,list: newObject.list, tuteType: newObject.tuteType, weekNo: newObject.weekNo, average:scorevalue)
                            print("Score \(scorevalue)")
                            print("after change \(replceObj)")
                            // perform action and change the values
                            //                            newObject.average = scorevalue
                            tutorialArray.append(replceObj)
                        }
                        else{
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                            Utility.showAlertWithTitle(title:Constant.Statictext.documentnotExist, message: "", controller: self)
                        }
                    case .failure(let error):
                        // A `custom 0object` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding customObject: \(error)")
                        Utility.showAlertWithTitle(title: Constant.Statictext.somethingWentWrong, message: "", controller: self)
                    }
                }
                // after loop ends
                let newArr = tutorialArray.sorted(by: { $0.weekNo ?? 0 < $1.weekNo ?? 0 })
                tutorialArray = newArr
                FireBaseManager.sharedInstance.tutorialArray = tutorialArray
                
            }
            else{
                // error case
                Utility.showAlertWithTitle(title: Constant.Statictext.somethingWentWrong, message: "", controller: self)
            }
        }
    }
    //
    @IBAction func didTapNewButton(_ sender: UIButton) {
        _ = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: Constant.storyboard.main, bundle: nil))
        let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.createstudentviewcontroller) as! CreateStudentViewController
        vc.title = Constant.Statictext.title
        vc.comingFor = .newAdded
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

extension SecondChildViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentsAray?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        cell.studentObj = self.studentsAray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.moveTostudentDetail(studentObj: self.studentsAray?[indexPath.row])
    }
    
    func moveTostudentDetail(studentObj:StudentModel?) {
        _ = UIStoryboard.instantiateInitialViewController(UIStoryboard(name: Constant.storyboard.main, bundle: nil))
        let vc = storyboard?.instantiateViewController(identifier: "StudentDetailViewController") as! StudentDetailViewController
        //StudentDetailViewController
        vc.title = Constant.Statictext.title
        vc.studentObj = studentObj
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

extension SecondChildViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let newvalue = self.orignalArray?.filter({ (item) -> Bool in
                let countryText: NSString = (item.name?.lowercased() ?? "") as NSString
                return (countryText.range(of: searchText.lowercased(), options: .caseInsensitive).location) != NSNotFound
            })
            self.studentsAray = newvalue
        }
        else{
            self.studentsAray = self.orignalArray
        }
        self.studentTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.resignFirstResponder()
        self.studentsAray = self.orignalArray
        
        self.studentTableView.reloadData()
        //searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
    }

    
    
    
}
