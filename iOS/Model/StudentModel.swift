//
//  StudentModel.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 08/05/21.
//

import Foundation

struct StudentModel:Codable,Identifiable {
    var documentId: String?
    
    var active:Int?
    var id: String?
    var name: String?
    var photoURL: String?
    var average: Int?
    var type: Int?
    // for attendance
    var isPresent: Bool?
    // for checkpoint
    var checkList: [Bool]?
    // score
    var score: Int? // this is used for grades, gradeA-F
    var maxScore: Int?
}
