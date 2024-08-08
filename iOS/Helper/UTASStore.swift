//
//  UTASStore.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import Foundation
class UTASStore:NSObject {
    static let sharedInstance = UTASStore()
    private override init(){}
    static var tutorialWeek = ["Week 1","Week 2", "Week 3","Week 4","Week 5","Week 6","Week 7","Week 8","Week 9","Week 10","Week 11","Week 12","Week 13"]
    static let tutorialType = ["Attendance","Checkpoints","Score","Grades","Grades(A-F)"]
    static let checkPointOption = ["1","2","3","4"]
    static let gradesAtoF = ["A","B","C","D","F"]
    static let grades = ["HD+","HD","DN","CR","PP","NN"]
}
