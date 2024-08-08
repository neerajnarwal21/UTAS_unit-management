//
//  FirebaseManager.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 08/05/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FireBaseManager:NSObject {
    static let sharedInstance = FireBaseManager()
    private override init(){}
    let db = Firestore.firestore()
    var tutorialArray: [TutorialsModel]?
    var studentsAray = [StudentModel]()
    
    func getDataFromFirebase(tableName:String,completion:@escaping (_ result: [QueryDocumentSnapshot]?,_ error: String?) -> Void)  {
        
        let refrence = FireBaseManager.sharedInstance.db.collection(tableName)
        refrence.getDocuments { (result, err) in
            //check for server error
            if let err = err {
                completion(nil,err.localizedDescription)
                print("Error getting documents: \(err)")
            }
            else{
                print(result!.documents)
                completion(result!.documents,nil)
                //loop through the results
//                for document in result!.documents{
////                    //attempt to convert to object
//                    
//                    let conversionResult = Result{
//                        try document.data(as: StudentModel.self)
//
//                    }
////                    //check if conversionResult is success or failure (i.e. was an exception/error thrown?
//                    switch conversionResult{
//                    //no problems (but could still be nil)
//                    case .success(let convertedDoc):
//                        if let customObject = convertedDoc{
//                            // A `custom object` value was successfully initialized from the DocumentSnapshot.
//                            print("customObject: \(customObject)")
//                        }
//                        else{
//                            // A nil value was successfully initialized from the DocumentSnapshot,
//                            // or the DocumentSnapshot was nil.
//                            print("Document does not exist")
//                        }
//                    case .failure(let error):
//                        // A `custom 0object` value could not be initialized from the DocumentSnapshot.
//                        print("Error decoding movie: \(error)")
//                    }
//                }
            }
        }
    }
    
    func create(tableName:String,data: [String:Any],completion: @escaping (_ sucess: Bool,_ message: String,_ error: String?) -> Void)  {
        let refrence = FireBaseManager.sharedInstance.db.collection(tableName)
        refrence.addDocument(data: data) { (error) in
            if error == nil{
                completion(true,"Data added sucessfully.",nil)
            }
            else{
                completion(false,"Data is not added sucessfully.",nil)
            }
        }
    }
    
    func update(tableName:String,tableRefID:String,withData:[String:Any],completion: @escaping (_ sucess: Bool,_ message: String,_ error: String?) -> Void) {
        var ref: DocumentReference? = nil
        print(tableRefID)
        let washingtonRef = db.collection(tableName).document(tableRefID).updateData(withData) { (error) in
            if error == nil{
                completion(true,"Data updated sucessfully.",nil)
            }
            else{
                completion(false,"Data is not added sucessfully.",nil)
            }
        }
        
    }
    
    func delete(tableName:String,tableRefID:String,completion: @escaping (_ sucess: Bool,_ message: String,_ error: String?) -> Void)  {
        let refrence = FireBaseManager.sharedInstance.db.collection(tableName)
        print(refrence.collectionID)
        refrence.document(tableRefID).delete { (error) in
            if error == nil{
                completion(true,"Data deleted sucessfully.",nil)
            }
            else{
                completion(false,"Data is not deleted sucessfully.",nil)
            }
        }
    }
    
    
}

extension Int{
    func getTuteTypeString()-> String?  {
        switch self{
        case 1:
            return "Checkpoints"
        case 2:
            return "Score"
        case 3:
            return "Grades"
        case 4:
             return "Grades(A-F)"
        default:
            return "Attendance"
        }
    }
    
    func getTuteTypeEnum() -> Weeklytype {
        switch self{
        case 1:
            return .checkPoint
        case 2:
            return .score
        case 3:
            return .grades
        case 4:
            return .gradesAtoF
        default:
            return .attendance
        }
    }
    
    func getGradesfromInt()-> String {
        switch self {
        case 1:
            return "HD"
        case 2:
            return "DN"
        case 3:
            return "CR"
        case 4:
             return "PP"
        case 5:
            return "NN"
        default:
            return "HD+"
        }
    }
    
    func getGradesAtoFfromInt()-> String {
        switch self {
        case 1:
            return "B"
        case 2:
            return "C"
        case 3:
            return "D"
        case 4:
             return "F"
        default:
            return "A"
        }
    }
    
    func grades2TotalMarks()-> Int {
        switch self {
        case 0:
            return 100
        case 1:
            return 80
        case 2:
            return 70
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func gradeTotalMarks() -> Int {
        switch self {
        case 0:
            return 100
        case 1:
            return 80
        case 2:
            return 60
        case 3:
            return 50
        default:
            return 0
        }
    }
}

extension Weeklytype{
    func getTuteTypeIntValueFromEnum()->Int  {
        switch self{
        case .checkPoint:
            return 1
        case .score:
            return 2
        case .grades:
            return 3
        case .gradesAtoF:
            return 4
        default:
            return 0
        }
    }
}
