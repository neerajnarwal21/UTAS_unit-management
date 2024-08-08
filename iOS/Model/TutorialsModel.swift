//
//  TutorialsModel.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 08/05/21.
//

import Foundation
protocol Identifiable{
    var documentId : String?{get set}
}

struct TutorialsModel:Codable,Identifiable {
    var documentId: String?
    var list: [ListModel]?
    var tuteType: Int?
    var weekNo: Int?
    var average: Int?
}

struct ListModel:Codable {
    var attendance: Bool?
    var checks: Int?
    var checksList: [String:Bool]?
    var grades: Int?
    var grades2: Int?
    var maxScore: Int?
    var score: Int?
    var studentId: String?
    var studentName: String?
    var studentPic: String?
    var totalMarks: Int?
}


enum Weeklytype:Int {
    case  attendance
    case  checkPoint
    case  score
    case  grades
    case  gradesAtoF
    case  newAdded
    
}



