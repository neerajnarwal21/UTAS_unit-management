//
//  Constant.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 07/05/21.
//

import Foundation

struct Constant{
    
    struct appcolor {
        static let primaryColor        = "#FF6200EE"
        static let secondaryColor      = "#FF03DAC5"
        static let primaryVariant      = "#FF3700B3"
        static let secondaryVariant    = "#FF018786"
    }
    
    struct ViewControllerIdentifier {
        static let tutorialViewController = "ChildViewController"
        static let studentViewvontroller = "SecondChildViewController"
        static let weeklyList     = "WeeklyListViewController"
        static let ceateNewTutorial = "CreateNewTutorialViewController"
        static let createstudentviewcontroller   = "CreateStudentViewController"
    }
    
    struct Statictext {
        static let title = "UTAS Tutorial marking"
        static let tutorial = "TUTORIALS"
        static let student  = "STUDENTS"
        static let pullToRefresh = "Pull to refresh"
        static let documentnotExist = "Document does not exist"
        static let somethingWentWrong = "Something went wrong"
        static let alertTitle = "Are you sure delete this profile ?"
        static let yesIwill = "Yes ,I want delete this profile"
        static let cancel = "Cancel"
        static let deletedTitle  = "Student deleted sucessfully"
        static let ok = "Ok"
        static let classavg = "Class avg:"
        static let tutorialaddedSucess = "Tutorial added sucessfully"
        static let tutorialupdatedSucess = "Tutorial updated sucessfully"
        static let studentaddedSucess = "Student Added Sucessfully"
        static let studentupdatedSucess = "Student updated Sucessfully"
        static let alreadyExist = "This week already exist"
        static let enterMaxScore = "Enter max score for the week"
        static let addstudent = "Add Student"
        static let addStudentUpper = "ADD STUDENT"
        static let updateStudent = "Update Student"
        static let updateStudentupper = "UPDATE STUDENT"
        static let enterStudentId = "Please enter student Id"
        static let enterStudentname = "Please enter student name"
        static let studentAlready = "Please change your student ID.This student ID is already taken by another student"
        
    }
    
    struct cellIdentifier {
        static let studentdetailheardertableviewcell = "StudentDetailHeaderTableViewCell"
        static let studentdetailcelltableviewcell = "StudentDetailCellTableViewCell"
        static let checkpointstableviewcell = "CheckPointsTableViewCell"
        static let attendancetableviewcell = "AttendanceTableViewCell"
        static let scoretableviewcell = "ScoreTableViewCell"
        static let gradetableviewcell = "GradeTableViewCell"
    }
    
    struct storyboard {
        static let main = "Main"
    }
    
    struct firebaseTableName {
        static let student  = "students"
        static let tutorial = "tutorial"
    }
}



