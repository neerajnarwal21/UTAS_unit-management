//
//  Utility.swift
//  Ombreak
//

//


import Foundation
import SwiftMessages
let debubPrintLog:Int = 1

class Utility: NSObject {
    
    
    class func shared()-> Utility{
        let nsutility = Utility()
        return nsutility
    }
    
   
    
    //MARK: - Check For Empty String
    
    class func checkIfStringContainsText(_ string:String?) -> Bool
    {
        if let stringEmpty = string {
            let newString = stringEmpty.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if(newString.isEmpty){
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    
    
    
    // MARK: - Show DebubLogs Methods
    /*
     1.    set value 1 to debubPrintLog to Enable the debuging logs
     2.    set value 0 to debubPrintLog to Disable the debuging logs
     3.    debubPrintLog is a Global variable
     */
    
    
    
    class  func dateAtBeginningOfDayForDate(inputDate:Date) -> Date {
        
        var calendar = NSCalendar.current
        let timeZone = NSTimeZone.system
        calendar.timeZone = timeZone
        var dateComps = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: inputDate)
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        let  beginningOfDay = calendar.date(from: dateComps)
        return beginningOfDay!
    }
    
    
   
    class  func timeStampFormatForServer(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from:date)
    }
    
    
    class  func getTimeOffestValue() -> String {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutes = abs(seconds/60)
        return "\(minutes)"
        
    }
    
    
    
    // Create Image from uicolor
    
    
    class func GetImageWithColor(color:UIColor)->UIImage{
        
        let rect = CGRect(x:0.0, y:0.0, width:1.0, height:1.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    //Check Internet connection
    
    class func isConnectedToNetwork() -> Bool {
        
        return true
    }
    
    
     func isAlphabetsString(stringName:String)-> Bool
    {
        var returnValue = true
        let trimmedString = stringName.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" || trimmedString.count == 0{
            return false
            
        }
        let nameEx = "^[a-zA-Z0-9._@ -]+$"
        do {
            let regex = try NSRegularExpression(pattern: nameEx)
            let nsString = trimmedString as NSString
            let results = regex.matches(in: trimmedString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch _ as NSError {
            //  print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    
     func isAlphabetsStringForName(stringName:String)-> Bool
    {
        var returnValue = true
        let trimmedString = stringName.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" || trimmedString.count == 0{
            return false
            
        }
        let nameEx = "^[a-zA-Z]+$"
        do {
            let regex = try NSRegularExpression(pattern: nameEx)
            let nsString = trimmedString as NSString
            let results = regex.matches(in: trimmedString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch _ as NSError {
            //  print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    
    class  func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
   
    
    func showMessage(title:String,body:String,themetype:Theme){
        
        
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .top
        
        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        config.presentationContext = .window(windowLevel: .statusBar)
        
        // Disable the default auto-hiding behavior.
        config.duration = .automatic
        
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .gray(interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }
        
        
        let alert = MessageView.viewFromNib(layout: .messageView)
        alert.configureTheme(themetype)
        alert.configureContent(title: title, body: body)
        alert.button?.isHidden = true
        // error.button?.setTitle("Stop", for: .normal)
        SwiftMessages.show(config: config, view: alert)

    }
    
    
    class  func BirthdayDateFormat(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return   formatter.string(from:date)
   
    }
    
  
    class  func BirthdayDateFormatForServer(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
      //  formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from:date)
    }
    
    
    class  func BirthdayDateFormatForServerToString(strDate:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let newDate = formatter.date(from: strDate)
         formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from:newDate ?? Date())
    }
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch  {
            //  print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    
    func isValidPassword(passwordString: String) -> Bool {
        if passwordString.count < 8{
            return false
        }else{
            return true
        }
        
//        var returnValue = true
//        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[0-9A-Za-z\\d$@$!%*?&#]{8,}$"
//
//        do {
//            let regex = try NSRegularExpression(pattern: passwordRegEx)
//            let nsString = passwordString as NSString
//            let results = regex.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))
//            if results.count == 0
//            {
//                returnValue = false
//            }
//        } catch _ as NSError {
//            //   print("invalid regex: \(error.localizedDescription)")
//            returnValue = false
//        }
//        return  returnValue
    }
    
    
    
    
    /**
     - showAlert: This function is used to show alert on viewController's view
     */
    static func showAlertWithTitle(title: String?,
                                   message: String,
                                   controller: UIViewController) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil)
        alertController.addAction(defaultAction)
        controller.present(alertController,
                           animated: true,
                           completion: nil)
    }
}

func DBlog(_ message:AnyObject) {
    if debubPrintLog == 0{
        
        NSLog(String(describing:message), "")
    }
    
}

//var documentsUrl: URL {
//    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//}

