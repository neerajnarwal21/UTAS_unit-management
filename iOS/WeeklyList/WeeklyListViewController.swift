//
//  WeeklyListViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit

class WeeklyListViewController: UIViewController {
    
    
    @IBOutlet weak var weeklyTutorialTable: UITableView!
    @IBOutlet weak var classPercentageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var weeklyListFor: Weeklytype?
    var selectedTutorial: TutorialsModel?
    var studentArray: [StudentModel]?
    // if user try to add new tutorial at that case we are using filloeing object for what type of tutorial
    var tutorialIntValueForAdded: Int?
    var selectedCheckPoints: Int?
    var weekNoIdForAdded: Int?
    // for max score when create tutoroial
    var maxScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.updateData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentArray = [StudentModel]()
        // custom array at our end
        if(weeklyListFor == .newAdded){
            for item in FireBaseManager.sharedInstance.studentsAray {
                switch tutorialIntValueForAdded?.getTuteTypeEnum() {
                case .attendance:
                    let newObj = StudentModel(documentId:item.documentId,active: item.active, id: item.id, name: item.name, photoURL: item.photoURL, average: item.average, type: nil, isPresent: false, checkList: nil, score: nil, maxScore: nil)
                    self.studentArray?.append(newObj)
                    
                case .checkPoint:
                    var checkPointArray: [Bool]?
                    guard let newselectedPoint = selectedCheckPoints else { return }
                    checkPointArray
                        = [Bool]()
                    for _ in 0..<newselectedPoint  {
                        checkPointArray?.append(false)
                    }
                    self.studentArray?.append(StudentModel(documentId:item.documentId,active: item.active, id: item.id, name: item.name, photoURL: item.photoURL, average: item.average, type: tutorialIntValueForAdded, isPresent:false, checkList: checkPointArray))
                case .score:
                    self.studentArray?.append(StudentModel(documentId:item.documentId,active: item.active, id: item.id, name: item.name, photoURL: item.photoURL, average: item.average, type: tutorialIntValueForAdded, isPresent: false, checkList: nil,score:0,maxScore:self.maxScore))
                    
                case .grades:
                    self.studentArray?.append(StudentModel(documentId:item.documentId,active: item.active, id: item.id, name: item.name, photoURL: item.photoURL, average: item.average, type: tutorialIntValueForAdded, isPresent: false, checkList: nil,score:0,maxScore:nil))
                    
                default:
                    self.studentArray?.append(StudentModel(documentId:item.documentId,active: item.active, id: item.id, name: item.name, photoURL: item.photoURL, average: item.average, type: tutorialIntValueForAdded, isPresent: false, checkList: nil,score:0,maxScore:nil))
                }
                
            }
        }
        else{
            for student in FireBaseManager.sharedInstance.studentsAray {
                //            if ((self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) != nil) {
                if weeklyListFor == .checkPoint {
                    // create checkList
                    if let value = (self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) {
                        
                        var checkList = [Bool]()
                        
                        // if matched
                        if value.first?.checksList?.count == 1 {
                            checkList.append(value.first?.checksList?["1"] ?? false)
                        }
                        else if value.first?.checksList?.count == 2 {
                            checkList.append(value.first?.checksList?["1"] ?? false)
                            checkList.append(value.first?.checksList?["2"] ?? false)
                        }
                        else if value.first?.checksList?.count == 3 {
                            checkList.append(value.first?.checksList?["1"] ?? false)
                            checkList.append(value.first?.checksList?["2"] ?? false)
                            checkList.append(value.first?.checksList?["3"] ?? false)
                        }
                        else if value.first?.checksList?.count == 4 {
                            checkList.append(value.first?.checksList?["1"] ?? false)
                            checkList.append(value.first?.checksList?["2"] ?? false)
                            checkList.append(value.first?.checksList?["3"] ?? false)
                            checkList.append(value.first?.checksList?["4"] ?? false)
                        }
                        else{
                            //  if matched value is not having any checklIst
                            for _ in 0..<(self.selectedTutorial?.list?.first?.checksList!.count)! {
                                checkList.append(false)
                            }
                            
                        }
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent:true, checkList: checkList))
                        
                    }else{
                        // not matched or not found in array
                        var checkList = [Bool]()
                        for _ in 0..<(self.selectedTutorial?.list?.first?.checksList!.count)! {
                            checkList.append(false)
                        }
                        
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent:false, checkList: checkList))
                    }
                }
                else if weeklyListFor == .attendance {
                    // create checkList
                    if let value = (self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) {
                        if value.count > 0 {
                            // if matched
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent:value.first?.attendance, checkList: nil))
                        }
                        else{
                            // not present
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active:  student.active, id:  student.id, name:  student.name, photoURL:  student.photoURL, average:  student.average, type:weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false))
                        }
                        
                    }
                    else{
                        // not present
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active:  student.active, id:  student.id, name:  student.name, photoURL:  student.photoURL, average:  student.average, type:weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false))
                    }
                }
                else if weeklyListFor == .score{
                    if let value = (self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) {
                        if value.count > 0 {
                            // if matched
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: true, checkList: nil,score:value.first?.score,maxScore:  self.selectedTutorial?.list?.first?.maxScore))
                        }
                        else{
                            // not present
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:  self.selectedTutorial?.list?.first?.maxScore))
                        }
                        
                    }
                    else{
                        // not present
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:  self.selectedTutorial?.list?.first?.maxScore))
                    }
                }
                
                else if weeklyListFor == .grades {
                    if let value = (self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) {
                        if value.count > 0{
                            // if matched
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: true, checkList: nil,score:value.first?.grades,maxScore: nil))
                        }
                        else{
                            // not present
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:nil))
                        }
                    }
                    else{
                        // not present
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:nil))
                    }
                }
                else{
                    if let value = (self.selectedTutorial?.list?.filter({$0.studentId ?? "" == student.id})) {
                        if value.count > 0 {
                            // if matched
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: true, checkList: nil,score:value.first?.grades2,maxScore: nil))
                        }
                        else{
                            // not present
                            self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:nil))
                        }
                        
                    }
                    else{
                        // not present
                        self.studentArray?.append(StudentModel(documentId:student.documentId,active: student.active, id: student.id, name: student.name, photoURL: student.photoURL, average: student.average, type: weeklyListFor?.getTuteTypeIntValueFromEnum(), isPresent: false, checkList: nil,score:0,maxScore:nil))
                    }
                } 
            }
        }
        self.getpercentage()
    }
    
    func getpercentage() {
        if weeklyListFor == .newAdded{
            switch tutorialIntValueForAdded?.getTuteTypeEnum() {
            case .attendance:
                if let newvalue = self.studentArray?.filter({$0.isPresent == true}){
                    let avg = ((newvalue.count * 100) / self.studentArray!.count )
                    print(avg)
                    self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg)%"
                }
            case .checkPoint:
                var totalTrueScored = 0
                for item in self.studentArray ?? [] {
                    totalTrueScored += item.checkList?.filter({$0 == true}).count ?? 0
                }
                guard let checkPoints = self.selectedCheckPoints else { return }
                let avg = ((totalTrueScored * 100) / (self.studentArray!.count * checkPoints))
                print(avg)
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg) %"
                
            case .score:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score ?? 0
                    maxScore = item.maxScore ?? 0
                    
                }
                
                if let arrayCount = self.studentArray?.count {
                    let totalMaxScore = maxScore * arrayCount
                    let avg = ((totalScored * 100) / totalMaxScore)
                    print(avg)
                    self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg)%"
                }
                
            case .grades:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score?.gradeTotalMarks() ?? 0
                    maxScore += 100
                    
                }
                let average = (totalScored * 100) / maxScore
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(average)%"
                
            default:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score?.grades2TotalMarks() ?? 0
                    maxScore += 100
                    
                }
                let average = (totalScored * 100) / maxScore
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(average)%"
            // if user come for create new tutorial
            }
        }
        else{
            // if user comes from list of tutorials
            switch weeklyListFor {
            case .attendance:
                if let newvalue = self.studentArray?.filter({$0.isPresent == true}){
                    let avg = ((newvalue.count * 100) / self.studentArray!.count )
                    print(avg)
                    self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg)%"
                }
                
            case .checkPoint:
                var totalTrueScored = 0
                for item in self.studentArray ?? [] {
                    totalTrueScored += item.checkList?.filter({$0 == true}).count ?? 0
                }
                let avg = ((totalTrueScored * 100) / (self.studentArray!.count * (self.selectedTutorial?.list?.first?.checksList!.count)!))
                print(avg)
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg)%"
                
            case.score:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score ?? 0
                    maxScore = item.maxScore ?? 0
                    
                }
                
                if let arrayCount = self.studentArray?.count {
                    let totalMaxScore = maxScore * arrayCount
                    let avg = ((totalScored * 100) / totalMaxScore)
                    print(avg)
                    self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(avg)%"
                }
            case.grades:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score?.gradeTotalMarks() ?? 0
                    maxScore += 100
                    
                }
                let average = (totalScored * 100) / maxScore
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(average)%"
                
            default:
                var totalScored = 0
                var maxScore = 0
                for item in self.studentArray ?? [] {
                    totalScored += item.score?.grades2TotalMarks() ?? 0
                    maxScore += 100
                    
                }
                let average = (totalScored * 100) / maxScore
                self.classPercentageLabel.text = "\(Constant.Statictext.classavg) \(average)%"
            }
        }
    }
    
    func updateData() {
        if weeklyListFor == .newAdded{
            self.titleLabel.text = "Mark \(self.tutorialIntValueForAdded?.getTuteTypeString() ?? "") for Week \(self.weekNoIdForAdded ?? 0)"
        }
        else{
            self.titleLabel.text = "Mark \(self.selectedTutorial?.tuteType?.getTuteTypeString() ?? "") for Week \(self.selectedTutorial?.weekNo ?? 0)"
        }
        
    }
    
    func registerCell()  {
        self.weeklyTutorialTable.register(UINib(nibName: Constant.cellIdentifier.checkpointstableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.checkpointstableviewcell)
        //AttendanceTableViewCell
        self.weeklyTutorialTable.register(UINib(nibName: Constant.cellIdentifier.attendancetableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.attendancetableviewcell)
        self.weeklyTutorialTable.register(UINib(nibName: Constant.cellIdentifier.scoretableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.scoretableviewcell)
        self.weeklyTutorialTable.register(UINib(nibName: Constant.cellIdentifier.gradetableviewcell, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier.gradetableviewcell)
    }
    
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        var listArray = [[String:Any]]()
        for student in self.studentArray ?? [] {
            switch weeklyListFor {
            case .newAdded:
                
                switch tutorialIntValueForAdded?.getTuteTypeEnum() {
                case .attendance:
                    listArray.append(["attendance":student.isPresent ?? false ,"checks":0,"checksList":[:],"grades":0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.isPresent == true ? 100 : 0])
                case .checkPoint:
                    var checkListJson = [String:Any]()
                    if let checkListCount = student.checkList?.count {
                        for itemindex in 0..<checkListCount {
                            checkListJson["\(itemindex+1)"] = student.checkList?[itemindex]
                        }
                    }
                    
                    // check no of true in check point
                    let trueCheckArray = student.checkList?.filter({$0 == true})
                   
                    
                    let totalscore = (trueCheckArray?.count ?? 0  ) * 100
                    let avg = (totalscore / student.checkList!.count)
                                                // student.checkList!.count)
                    print("totalscore \(avg)")
                    
                    listArray.append(["attendance":student.isPresent ?? false ,"checks":student.checkList?.count ?? 0,"checksList":checkListJson,"grades":0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":avg])
                    
                case .grades:
                    let checkListJson = [String:Any]()
                    listArray.append(["attendance": false ,"checks": 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.score?.gradeTotalMarks() ?? 0])
                    
                case .gradesAtoF:
                    let checkListJson = [String:Any]()
                    listArray.append(["attendance": false ,"checks": 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":student.maxScore ?? 0,"score":student.score ?? 0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.score?.grades2TotalMarks() ?? 0])
                    
                    
                default:
                    // score type
                    let checkListJson = [String:Any]()
                    let average = ((student.score ?? 0) / (student.maxScore ?? 0))*100
                    listArray.append(["attendance": false ,"checks":student.checkList?.count ?? 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":student.maxScore ?? 0,"score":student.score ?? 0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":average])
                    
                }
                
            default:
                switch self.selectedTutorial?.tuteType?.getTuteTypeEnum() {
                case .attendance:
                    listArray.append(["attendance":student.isPresent ?? false ,"checks":0,"checksList":[:],"grades":0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.isPresent == true ? 100 : 0])
                case .checkPoint:
                    var checkListJson = [String:Any]()
                    if let checkListCount = student.checkList?.count {
                        for itemindex in 0..<checkListCount {
                            checkListJson["\(itemindex+1)"] = student.checkList?[itemindex]
                        }
                    }
                    
                    let trueCheckArray = student.checkList?.filter({$0 == true})
                    print(trueCheckArray)
                    print("truevalue \(trueCheckArray?.count ?? 0)")
                    let totalscore = (trueCheckArray?.count ?? 0  ) * 100
                    let avg = (totalscore / student.checkList!.count)
                                                // student.checkList!.count)
                    print("totalscore \(avg)")
                    print(totalscore)
                    
                    
                    

                   
                    listArray.append(["attendance":student.isPresent ?? false ,"checks":student.checkList?.count ?? 0,"checksList":checkListJson,"grades":0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":avg])
                    
                case .grades:
                    let checkListJson = [String:Any]()
                    listArray.append(["attendance": false ,"checks": 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":0,"score":0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.score?.gradeTotalMarks() ?? 0])
                    
                case .gradesAtoF:
                    let checkListJson = [String:Any]()
                    listArray.append(["attendance": false ,"checks": 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":student.maxScore ?? 0,"score":student.score ?? 0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":student.score?.grades2TotalMarks() ?? 0])
                    
                    
                default:
                    // score type
                    let checkListJson = [String:Any]()
                    let average = ((student.score ?? 0) / (student.maxScore ?? 0))*100
                    listArray.append(["attendance": false ,"checks":student.checkList?.count ?? 0,"checksList":checkListJson,"grades":student.score ?? 0,"grades2":0,"maxScore":student.maxScore ?? 0,"score":student.score ?? 0,"studentId":student.id ?? 0,"studentName":student.name ?? "","studentPic":student.photoURL ?? "","totalMarks":average ])
                    
                }
                
            }
            
        }
        
        
        let newDict = ["list":listArray,"tuteType" : weeklyListFor == .newAdded ? self.tutorialIntValueForAdded ?? 0 : self.selectedTutorial?.tuteType ?? 0  ,"weekNo": weeklyListFor == .newAdded ? self.weekNoIdForAdded ?? 0 : self.selectedTutorial?.weekNo ?? 0] as [String : Any]
        
        print(newDict)
        
        switch weeklyListFor {
        case .newAdded:
            FireBaseManager.sharedInstance.create(tableName: Constant.firebaseTableName.tutorial, data: newDict) { (isSucess, message, errorMessage) in
                if isSucess == true{
                    print("Got Sucess added")
                    let alert = UIAlertController(title:Constant.Statictext.tutorialaddedSucess, message: "", preferredStyle: .alert)
                    let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                        self.navigationController?.popViewControllers(viewsToPop: 2)
                    }
                    alert.addAction(ok)
                    //.actions[ok,cancel]
                    self.navigationController?.present(alert, animated: true, completion:nil)
                    
                }
                else{
                    print("Got failure added")
                    let alert = UIAlertController(title:Constant.Statictext.somethingWentWrong, message: "", preferredStyle: .alert)
                    let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                    }
                    alert.addAction(ok)
                    self.navigationController?.present(alert, animated: true, completion:nil)
                }
            }
            
        default:
            FireBaseManager.sharedInstance.update(tableName: Constant.firebaseTableName.tutorial, tableRefID: self.selectedTutorial?.documentId ?? "", withData: newDict) { (isSucess, message, errorMessage) in
                if isSucess == true{
                    print("Got Sucess update")
                    let alert = UIAlertController(title:Constant.Statictext.tutorialupdatedSucess, message: "", preferredStyle: .alert)
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
    }
    
}

extension WeeklyListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // check user come from which type of tutorial
        if weeklyListFor == .newAdded{
            switch tutorialIntValueForAdded?.getTuteTypeEnum() {
            case .checkPoint:
                if self.selectedCheckPoints ?? 0 > 2 {
                    return 170.0
                }
                else{
                    // add check in check list count if greater then 2 then need to show else not shoewing
                    //        return 170.0 // 40
                    return 130.0
                }
                
            case .attendance:
                return 78.0
            case .score:
                return 78.0
            case .grades:
                return 78.0
            default:
                return 78.0
            }
        }
        else{
            switch weeklyListFor {
            case .checkPoint:
                if self.selectedTutorial?.list?.first?.checksList?.count ?? 0 > 2 {
                    return 170.0
                }
                else{
                    // add check in check list count if greater then 2 then need to show else not shoewing
                    //        return 170.0 // 40
                    return 130.0
                }
                
            case .attendance:
                return 78.0
            case .score:
                return 78.0
            case .grades:
                return 78.0
            default:
                return 78.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if weeklyListFor == .newAdded {
            switch tutorialIntValueForAdded?.getTuteTypeEnum() {
            case .attendance:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.attendancetableviewcell) as! AttendanceTableViewCell
                cell.studentObj =  self.studentArray?[indexPath.row]
                cell.buttonTapped = { value in
                    let objc = self.studentArray?[indexPath.row]
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: objc?.isPresent == true ? false : true, checkList: nil, score: objc?.score, maxScore: objc?.maxScore)
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                        
                    }
                    self.getpercentage()
                }
                return cell
            case .checkPoint:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.checkpointstableviewcell) as! CheckPointsTableViewCell
                if  self.selectedCheckPoints ?? 0 > 2{
                    cell.bottomViewButtonHeightConstraint.constant = 44
                }
                else{
                    cell.bottomViewButtonHeightConstraint.constant = 0
                }
                cell.buttonTapped = { (tagValue,student) in
                    let objc = self.studentArray?[indexPath.row]
                    var newFilterList = objc?.checkList
                    let newValue = newFilterList?[tagValue-1] == true ? false : true
                    newFilterList?[tagValue-1] = newValue
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: newFilterList, score: objc?.score, maxScore: objc?.maxScore)
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    self.getpercentage()
                }
                cell.checkPoints = self.selectedCheckPoints
                cell.studentObj = self.studentArray?[indexPath.row]
                
                return cell
                
            case .score:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.scoretableviewcell) as! ScoreTableViewCell
                cell.studentObj =  self.studentArray?[indexPath.row]
                cell.changeTextField = { textfield in
                    //                    print(indexPath.row)
                    //                    print(textfield.text)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: Int(textfield.text ?? "0"), maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    
                    self.getpercentage()
                    
                }
                return cell
                
            case .grades:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.gradetableviewcell) as! GradeTableViewCell
                cell.cellFor = .grades
                cell.studentObj =  self.studentArray?[indexPath.row]
                
                cell.selectedDropDownValue = { (value,withIndex)  in
                    print(withIndex)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: withIndex, maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    
                    
                    self.getpercentage()
                    print(indexPath.row)
                    print(value)
                }
                return cell
                
            case .gradesAtoF:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.gradetableviewcell) as! GradeTableViewCell
                cell.cellFor = .grades
                cell.studentObj =  self.studentArray?[indexPath.row]
                
                cell.selectedDropDownValue = { (value,withIndex)  in
                    print(withIndex)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: withIndex, maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    self.getpercentage()
                    print(indexPath.row)
                    print(value)
                }
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.attendancetableviewcell) as! AttendanceTableViewCell
                cell.studentObj =  self.studentArray?[indexPath.row]
                cell.buttonTapped = { value in
                    print(indexPath.row)
                    let objc = self.studentArray?[indexPath.row]
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: objc?.score, maxScore: objc?.maxScore)
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                        self.getpercentage()
                    }
                }
                return cell
            }
        }
        else{
            switch weeklyListFor {
            case .checkPoint:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.checkpointstableviewcell) as! CheckPointsTableViewCell
                if  self.selectedTutorial?.list?.first?.checksList?.count ?? 0 > 2{
                    cell.bottomViewButtonHeightConstraint.constant = 44
                }
                else{
                    cell.bottomViewButtonHeightConstraint.constant = 0
                }
                cell.buttonTapped = { (tagValue,student) in
                    let objc = self.studentArray?[indexPath.row]
                    var newFilterList = objc?.checkList
                    let newValue = newFilterList?[tagValue-1] == true ? false : true
                    newFilterList?[tagValue-1] = newValue
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: newFilterList, score: objc?.score, maxScore: objc?.maxScore)
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    self.getpercentage()
                }
                cell.checkPoints = self.selectedTutorial?.list?.first?.checksList?.count
                // cell.selectedTutorialsObj = self.selectedTutorial
                cell.studentObj = self.studentArray?[indexPath.row]
                
                return cell
            case .attendance:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.attendancetableviewcell) as! AttendanceTableViewCell
                cell.studentObj =  self.studentArray?[indexPath.row]
                cell.buttonTapped = { value in
                    
                    let objc = self.studentArray?[indexPath.row]
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: objc?.isPresent == true ? false : true, checkList: nil, score: objc?.score, maxScore: objc?.maxScore)
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    self.getpercentage()
                }
                return cell
            case .score:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.scoretableviewcell) as! ScoreTableViewCell
                cell.studentObj =  self.studentArray?[indexPath.row]
                cell.changeTextField = { textfield in
                    print(indexPath.row)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: Int(textfield.text ?? "0"), maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    
                    self.getpercentage()
                    
                }
                return cell
            case .grades:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.gradetableviewcell) as! GradeTableViewCell
                cell.cellFor = .grades
                cell.studentObj =  self.studentArray?[indexPath.row]
                
                cell.selectedDropDownValue = { (value,withIndex)  in
                    print(withIndex)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: withIndex, maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    
                    
                    self.getpercentage()
                    print(indexPath.row)
                    print(value)
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.gradetableviewcell) as! GradeTableViewCell
                cell.cellFor = .grades
                cell.studentObj =  self.studentArray?[indexPath.row]
                
                cell.selectedDropDownValue = { (value,withIndex)  in
                    print(withIndex)
                    let objc = self.studentArray?[indexPath.row]
                    
                    let newObj = StudentModel(documentId:objc?.documentId,active: objc?.active, id: objc?.id, name: objc?.name, photoURL: objc?.photoURL, average: objc?.average, type: objc?.type, isPresent: true, checkList: nil, score: withIndex, maxScore: objc?.maxScore)
                    
                    if let row = self.studentArray?.firstIndex(where: {$0.id ==  objc?.id}) {
                        self.studentArray?[row] = newObj
                    }
                    
                    print(self.studentArray?[indexPath.row].score ?? 0)
                    
                    
                    self.getpercentage()
                    print(indexPath.row)
                    print(value)
                }
                return cell
            }
        }
    }
}
