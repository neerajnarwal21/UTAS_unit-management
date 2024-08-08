

//
//  String.swift

//

import CommonCrypto
import UIKit
import CoreLocation

extension String {
    
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    
    var isValidEmailAddress: Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            if results.isEmpty {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    var isValidName: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9_. ]", options: .regularExpression) == nil
    }
    
    var isValidMobileNumber: Bool {
        return self.count > 6 && isDigits
    }
    
    var isValidPostCode: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
    
    var isValidAddress: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9+-_#/ ]", options: .regularExpression) == nil
    }
    
    var isValidPassword: Bool {
        return !isEmpty && self.count >= 8 && self.count <= 40
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits,
                            options: String.CompareOptions.literal,
                            range: nil) == nil {
            return true
        }
        return false
    }
    
    
    
    func containsOnlyDigits() -> Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits,
                            options: String.CompareOptions.literal,
                            range: nil) == nil {
            return true
        }
        return false
    }
    
    func isAlphabetsString() -> Bool {
        var returnValue = true
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" || trimmedString.isEmpty {
            return false
        }
        
        let nameEx = "^[a-zA-Z0-9._@ -]+$"
        do {
            let regex = try NSRegularExpression(pattern: nameEx)
            let results = regex.matches(in: trimmedString, range: NSRange(location: 0, length: trimmedString.count - 1))
            if results.isEmpty {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map { $0.offset % groupSize == 0 ? [separator, $0.element]: [$0.element] }.joined().dropFirst())
    }
    
    
    func nullCheck(_ string: String?) -> String? {
        let str     =    string?.trimBeginAndEnd()
        if (str != nil && str != "<null>") {
            return string
        }
//        else if (str is NSNumber) {
//            //        if ([string isKindOfClass:]) {
//            //            <#statements#>
//            //        }
//            return String(format: "%.0f", Float(string ?? "") ?? 0.0)
//        } \
        else {
            return ""
        }
    }
    
    func stringToNumberFormatting(withValue value: String?) -> String? {
        var numberAsString = String()
        var trimValue =  value?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if(trimValue == "" || trimValue == "<null>" || trimValue == nil || trimValue == "0" || trimValue == "0.0" || trimValue == nil){
            numberAsString  =   "0.00"
        }
        else{
            print(trimValue ?? "")
            //            trimValue = "2,20,000.00"
            // if in string getting value with Commas at that time remove comma from string e.g 1,666.66.Following code is for remove comma from string 1666.66 value
            if(trimValue?.contains(","))!{
                trimValue = trimValue?.replacingOccurrences(of: ",", with: "")
            }
            print("After remove Comma \(trimValue ?? "")")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberAsString = numberFormatter.string(from: (Double(trimValue ?? "") as NSNumber?)! )!
            if (numberAsString.count  ) > 0 {
                numberAsString = ((numberAsString as NSString?)?.substring(from: 1))!
            }
        }
        return numberAsString.replacingOccurrences(of: ",", with: "")
    }
    
    func returnConvertedDate(asStringFormat format: String?) -> String? {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone = anAbbreviation as TimeZone
        }
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        dateFormatter.dateFormat = format
        //    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        var timestamp: String? = nil
        if let aDate = date {
            timestamp = dateFormatter.string(from: aDate)
        }
        return timestamp
    }
    
    
    func convertToLocalDateFromUTCDateWithoutSetLocale(format: String) -> String {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        // self.convertToLocalDateFromUTCDate(dateStr: self)
        let dateFormatter = DateFormatter()
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        
        if(date == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        let formatter2 = DateFormatter()
        formatter2.dateFormat = format
        let localTime = formatter2.string(from: date!)
        return localTime
    }
    
    func convertToLocalDateFromUTCDate(format: String, withLocale: String?) -> String {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        // self.convertToLocalDateFromUTCDate(dateStr: self)
        let dateFormatter = DateFormatter()
        
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        //        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
        //            dateFormatter.timeZone = anAbbreviation as TimeZone
        //        }
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        let formatter2 = DateFormatter()
        
        if(withLocale != nil){
            formatter2.locale = NSLocale(localeIdentifier: withLocale ?? "en") as Locale
        }
        
        formatter2.dateFormat = format
        let localTime = formatter2.string(from: date!)
        return localTime
    }
    
    
    func returnConvertedDateWithUTC(asStringFormat format: String?, withLocale:String?) -> String? {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone = anAbbreviation as TimeZone
        }
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        
        if(withLocale != nil){
            dateFormatter.locale = NSLocale(localeIdentifier: withLocale ?? "en") as Locale
        }
        
        // dateFormatter.timeZone  =   NSTimeZone.local
        var timestamp: String? = nil
        if let aDate = date {
            timestamp = dateFormatter.string(from: aDate)
        }
        return timestamp
    }
    
    
    func convertToLocalDateFromUTCDate(format: String) -> String {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        let dateFormatter = DateFormatter()
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        let formatter2 = DateFormatter()
        
        // formatter2.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
        
        formatter2.dateFormat = format
        let localTime = formatter2.string(from: date!)
        return localTime
    }
    
    
    func returnConvertedDateWithUTC(asStringFormat format: String?) -> String? {
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone = anAbbreviation as TimeZone
        }
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        //dateFormatter.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
        // dateFormatter.timeZone  =   NSTimeZone.local
        var timestamp: String? = nil
        if let aDate = date {
            timestamp = dateFormatter.string(from: aDate)
        }
        return timestamp
    }
    
    
    func toDate(_ withFormat: String?) -> Date{
        if self.count == 0 || (self == "0001-01-01T00:00:00") {
            return Date()
        }
        //        // self.convertToLocalDateFromUTCDate(dateStr: self)
        let dateFormatter = DateFormatter()
        var date: Date? = dateFormatter.date(from: self)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            date = dateFormatter.date(from: self)
        }
        if(date == nil){
            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
            date = dateFormatter.date(from: self)
        }
        //  dateFormatter.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
        
        if let aDate = date {
            date = aDate
        }
        return date ?? Date()
    }
    
    var asURL: URL? {
        URL(string: self)
    }
    
    
    func trimBeginAndEnd() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func generateCaptcha() -> String? {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let c = Array(charSet)
        var returnstring:String = ""
        for _ in (1...5) {
            //            returnstring.append(c[Int(arc4random()) % c.count])
            let length = UInt32 (charSet.count)
            let rand = arc4random_uniform(length)
            //            returnstring.append("%C",charSet.inde)
            returnstring.append(c[Int(rand)])
        }
        return returnstring
    }
    
    static func textByRemovingSpaces(value:String)-> String{
        let str =    value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return str
    }
    
    func setMixtureString(normalString: String,
                       boldString: String,
                       isBoldAtIntial: Bool,
                       normalFontSize: CGFloat,
                       boldFontSize: CGFloat) -> NSMutableAttributedString {
        let boldText = boldString
        let normalText = normalString

        let normalAttrs = [NSAttributedString.Key.font : UIFont.regularFont(with: normalFontSize)]
        let attrs = [NSAttributedString.Key.font : UIFont.boldFont(with: boldFontSize)]
    
        
        if isBoldAtIntial {
            let newAttributedString = NSMutableAttributedString(string:normalText, attributes:normalAttrs)
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

            attributedString.append(newAttributedString)
            return attributedString
        }else{
            let newAttributedString = NSMutableAttributedString(string:normalText, attributes:normalAttrs)
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

            newAttributedString.append(attributedString)
            return newAttributedString
        }
    }
    
     func convertToTimeInterval() -> TimeInterval {
           guard self != "" else {
               return 0
           }

           var interval:Double = 0

           let parts = self.components(separatedBy: ":")
           for (index, part) in parts.reversed().enumerated() {
               interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
           }

           return interval
       }
    
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


extension String{
    
    func deletingPrefix() -> String {
//        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst())
    }
        func deletingPrefix(_ prefix: String) -> String {
            guard self.hasPrefix(prefix) else { return self }
            return String(self.dropFirst(prefix.count))
        }
    
    func deletingPostfix(_ postfix: String) -> String {
        guard self.hasSuffix(postfix) else { return self }
        return String(self.dropLast())
    }
    
    
    
    
    
    static func convertDeviceTokenToString(_ deviceToken:Data) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        return token
    }
    
    
    
        
        static func stringWithTimerInterval(timeInterval:TimeInterval)->String{
            
            if timeInterval == 0{
                return "00:00"
            }
            let ti = Int(timeInterval)
            let seconds = ti % 60
            let minutes = (ti / 60) % 60
            let hours  = ti / 3600
            
            
            if hours > 0{
                return "\(String(format:"%.2di", hours)):\(String(format:"%.2li", minutes)):\(String(format:"%.2li", seconds))"
                
                
            }else{
                return "\(String(format:"%.2li", minutes)):\(String(format:"%.2li", seconds))"
                
            }
            
            
        }
        
        
        static func stringWithTimeDuration(timeDuration:String)->String{
            
            
            let totalSeconds = Int(timeDuration)
            let minutes = (totalSeconds! % 3600) / 60;
            let seconds = (totalSeconds! % 3600) % 60;
            
            let strSeconds = String(describing:seconds)
            
            
            
            if strSeconds.count == 1{
                return "0\(String(describing:minutes)):0\(String(describing:seconds))"
                
            }else{
                
                return "0\(String(describing:minutes)):\(String(describing:seconds))"
            }
            
        }
    
        var isNumeric: Bool {
            guard self.count > 0 else { return false }
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            return Set(self).isSubset(of: nums)
        }


    
    
    
}




extension String {
    var isLocalImageUrl: Bool {
        return !self.contains("http") && !self.contains("www.")
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
        if(self.count > 0){
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(self.startIndex, offsetBy: to)
            return String(self[startIndex...endIndex])
        }
        else{
            return ""
        }
    }
    
    
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
}

extension String {
    var currencyAppended: String {
        return "KD \(self)"
    }
}

extension String {
    func rangeFromNSRange(string: String, range: Range <String.Index>) -> NSRange? {
        guard let range = self.range(of: string, options: .caseInsensitive, range: range, locale: .current) else {
            return nil
            
        }
        
        return NSRange(range, in: self)
    }
    func nsRange(from range: Range<String.Index>) -> NSRange {
        if  let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) {
            
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                           length: utf16.distance(from: from, to: to))
        }
        return NSRange.init(location: 0, length: 1)
    }
    
    func width(with font: UIFont,
               padding: CGFloat = 0,
               maxWidth: CGFloat = 1000) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        let width = size.width + padding
        return width < maxWidth ? width : maxWidth
    }
    
}



////
////  String.swift
////  EdeeCircle
////
////  Created by Dev on 16/01/20.
////  Copyright © 2020 Dev. All rights reserved.
////
//
//import CommonCrypto
//import UIKit
//import CoreLocation
//
//extension String {
//
//    func sha1() -> String {
//        let data = Data(self.utf8)
//        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
//        data.withUnsafeBytes {
//            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
//        }
//        let hexBytes = digest.map { String(format: "%02hhx", $0) }
//        return hexBytes.joined()
//    }
//
//
//    var isValidEmailAddress: Bool {
//        var returnValue = true
//        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
//        do {
//            let regex = try NSRegularExpression(pattern: emailRegEx)
//            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
//            if results.isEmpty {
//                returnValue = false
//            }
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            returnValue = false
//        }
//        return  returnValue
//    }
//
//    var isValidName: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9_. ]", options: .regularExpression) == nil
//    }
//
//    var isValidMobileNumber: Bool {
//        return self.count > 6 && isDigits
//    }
//
//    var isValidPostCode: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
//    }
//
//    var isValidAddress: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9+-_#/ ]", options: .regularExpression) == nil
//    }
//
//    var isValidPassword: Bool {
//        return !isEmpty && self.count >= 8 && self.count <= 40
//    }
//    var isAlphanumeric: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
//    }
//
//    var isDigits: Bool {
//        let notDigits = NSCharacterSet.decimalDigits.inverted
//        if rangeOfCharacter(from: notDigits,
//                            options: String.CompareOptions.literal,
//                            range: nil) == nil {
//            return true
//        }
//        return false
//    }
//
//
//
//    func containsOnlyDigits() -> Bool {
//        let notDigits = NSCharacterSet.decimalDigits.inverted
//        if rangeOfCharacter(from: notDigits,
//                            options: String.CompareOptions.literal,
//                            range: nil) == nil {
//            return true
//        }
//        return false
//    }
//
//    func isAlphabetsString() -> Bool {
//        var returnValue = true
//        let trimmedString = self.trimmingCharacters(in: .whitespaces)
//        if trimmedString == "" || trimmedString.isEmpty {
//            return false
//        }
//
//        let nameEx = "^[a-zA-Z0-9._@ -]+$"
//        do {
//            let regex = try NSRegularExpression(pattern: nameEx)
//            let results = regex.matches(in: trimmedString, range: NSRange(location: 0, length: trimmedString.count - 1))
//            if results.isEmpty {
//                returnValue = false
//            }
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            returnValue = false
//        }
//        return  returnValue
//    }
//
//
//    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
//        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
//        return String(cleanedUpCopy.enumerated().map { $0.offset % groupSize == 0 ? [separator, $0.element]: [$0.element] }.joined().dropFirst())
//    }
//
//
//    func nullCheck(_ string: String?) -> String? {
//        let str     =    string?.trimBeginAndEnd()
//        if (str != nil && str != "<null>") {
//            return string
//        }
////        else if (str is NSNumber) {
////            //        if ([string isKindOfClass:]) {
////            //            <#statements#>
////            //        }
////            return String(format: "%.0f", Float(string ?? "") ?? 0.0)
////        } \
//        else {
//            return ""
//        }
//    }
//
//    func stringToNumberFormatting(withValue value: String?) -> String? {
//        var numberAsString = String()
//        var trimValue =  value?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
//        if(trimValue == "" || trimValue == "<null>" || trimValue == nil || trimValue == "0" || trimValue == "0.0" || trimValue == nil){
//            numberAsString  =   "0.00"
//        }
//        else{
//            print(trimValue ?? "")
//            //            trimValue = "2,20,000.00"
//            // if in string getting value with Commas at that time remove comma from string e.g 1,666.66.Following code is for remove comma from string 1666.66 value
//            if(trimValue?.contains(","))!{
//                trimValue = trimValue?.replacingOccurrences(of: ",", with: "")
//            }
//            print("After remove Comma \(trimValue ?? "")")
//            let numberFormatter = NumberFormatter()
//            numberFormatter.numberStyle = .currency
//            numberAsString = numberFormatter.string(from: (Double(trimValue ?? "") as NSNumber?)! )!
//            if (numberAsString.count  ) > 0 {
//                numberAsString = ((numberAsString as NSString?)?.substring(from: 1))!
//            }
//        }
//        return numberAsString
//    }
//
//    func returnConvertedDate(asStringFormat format: String?) -> String? {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
//            dateFormatter.timeZone = anAbbreviation as TimeZone
//        }
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//        dateFormatter.dateFormat = format
//        //    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//        var timestamp: String? = nil
//        if let aDate = date {
//            timestamp = dateFormatter.string(from: aDate)
//        }
//        return timestamp
//    }
//
//
//    func convertToLocalDateFromUTCDateWithoutSetLocale(format: String) -> String {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        // self.convertToLocalDateFromUTCDate(dateStr: self)
//        let dateFormatter = DateFormatter()
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            date = dateFormatter.date(from: self)
//        }
//
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//
//        if(date == nil){
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = format
//        let localTime = formatter2.string(from: date!)
//        return localTime
//    }
//
//    func convertToLocalDateFromUTCDate(format: String, withLocale: String?) -> String {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        // self.convertToLocalDateFromUTCDate(dateStr: self)
//        let dateFormatter = DateFormatter()
//
//        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        //        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
//        //            dateFormatter.timeZone = anAbbreviation as TimeZone
//        //        }
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            date = dateFormatter.date(from: self)
//        }
//
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        let formatter2 = DateFormatter()
//
//        if(withLocale != nil){
//            formatter2.locale = NSLocale(localeIdentifier: withLocale ?? "en") as Locale
//        }
//
//        formatter2.dateFormat = format
//        let localTime = formatter2.string(from: date!)
//        return localTime
//    }
//
//
//    func returnConvertedDateWithUTC(asStringFormat format: String?, withLocale:String?) -> String? {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
//            dateFormatter.timeZone = anAbbreviation as TimeZone
//        }
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//
//        if(withLocale != nil){
//            dateFormatter.locale = NSLocale(localeIdentifier: withLocale ?? "en") as Locale
//        }
//
//        // dateFormatter.timeZone  =   NSTimeZone.local
//        var timestamp: String? = nil
//        if let aDate = date {
//            timestamp = dateFormatter.string(from: aDate)
//        }
//        return timestamp
//    }
//
//
//    func convertToLocalDateFromUTCDate(format: String) -> String {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        let dateFormatter = DateFormatter()
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            date = dateFormatter.date(from: self)
//        }
//
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        let formatter2 = DateFormatter()
//
//        // formatter2.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
//
//        formatter2.dateFormat = format
//        let localTime = formatter2.string(from: date!)
//        return localTime
//    }
//
//
//    func returnConvertedDateWithUTC(asStringFormat format: String?) -> String? {
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return ""
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//        if let anAbbreviation = NSTimeZone(abbreviation: "UTC") {
//            dateFormatter.timeZone = anAbbreviation as TimeZone
//        }
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//        //dateFormatter.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
//        // dateFormatter.timeZone  =   NSTimeZone.local
//        var timestamp: String? = nil
//        if let aDate = date {
//            timestamp = dateFormatter.string(from: aDate)
//        }
//        return timestamp
//    }
//
//
//    func toDate(_ withFormat: String?) -> Date{
//        if self.count == 0 || (self == "0001-01-01T00:00:00") {
//            return Date()
//        }
//        //        // self.convertToLocalDateFromUTCDate(dateStr: self)
//        let dateFormatter = DateFormatter()
//        var date: Date? = dateFormatter.date(from: self)
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//
//        if date == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if date == nil {
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//            date = dateFormatter.date(from: self)
//        }
//        if(date == nil){
//            dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
//            date = dateFormatter.date(from: self)
//        }
//        //  dateFormatter.locale = NSLocale(localeIdentifier: SansStore.sharedInstance.language) as Locale
//
//        if let aDate = date {
//            date = aDate
//        }
//        return date ?? Date()
//    }
//
//
//    func convertToDate(format: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format // Your date format
//        let serverDate: Date = dateFormatter.date(from: self)! // according to date format your date string
//        return serverDate
//    }
//
//
//    func trimBeginAndEnd() -> String {
//        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//
//    func generateCaptcha() -> String? {
//        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let c = Array(charSet)
//        var returnstring:String = ""
//        for _ in (1...5) {
//            //            returnstring.append(c[Int(arc4random()) % c.count])
//            let length = UInt32 (charSet.count)
//            let rand = arc4random_uniform(length)
//            //            returnstring.append("%C",charSet.inde)
//            returnstring.append(c[Int(rand)])
//        }
//        return returnstring
//    }
//
//    static func textByRemovingSpaces(value:String)-> String{
//        let str =    value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
//        return str
//    }
//
//    func setMixtureString(normalString: String,
//                       boldString: String,
//                       isBoldAtIntial: Bool,
//                       normalFontSize: CGFloat,
//                       boldFontSize: CGFloat) -> NSMutableAttributedString {
//        let boldText = boldString
//        let normalText = normalString
//
//        let normalAttrs = [NSAttributedString.Key.font : UIFont.regularFont(with: normalFontSize)]
//        let attrs = [NSAttributedString.Key.font : UIFont.boldFont(with: boldFontSize)]
//
//
//        if isBoldAtIntial {
//            let newAttributedString = NSMutableAttributedString(string:normalText, attributes:normalAttrs)
//            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
//
//            attributedString.append(newAttributedString)
//            return attributedString
//        }else{
//            let newAttributedString = NSMutableAttributedString(string:normalText, attributes:normalAttrs)
//            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
//
//            newAttributedString.append(attributedString)
//            return newAttributedString
//        }
//    }
//
//}
//
////extension String{
////
////        func getAddressFromlocation(location:CLLocation,completion: @escaping (_ result:String?) -> Void ) {
////            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
////    //        let lat: Double = Double("\(pdblLatitude)")!
////    //        //21.228124
////    //        let lon: Double = Double("\(pdblLongitude)")!
////            //72.833770
////            let ceo: CLGeocoder = CLGeocoder()
////            center.latitude = location.coordinate.latitude
////            center.longitude = location.coordinate.longitude
////
////            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
////             var addressString : String = ""
////            ceo.reverseGeocodeLocation(loc, completionHandler:
////                {(placemarks, error) in
////
////                    if (error != nil)
////                    {
////                        completion("")
////                        print("reverse geodcode fail: \(error!.localizedDescription)")
////                        return
////                    }
////                    let pm = placemarks! as [CLPlacemark]
////
////                    if pm.count > 0 {
////                        let pm = placemarks![0]
////                        print(pm.country)
////                        print(pm.locality)
////                        print(pm.subLocality)
////                        print(pm.thoroughfare)
////                        print(pm.postalCode)
////                        print(pm.subThoroughfare)
////
////                        if pm.subLocality != nil {
////                            addressString = addressString + pm.subLocality! + ", "
////                        }
////                        if pm.thoroughfare != nil {
////                            addressString = addressString + pm.thoroughfare! + ", "
////                        }
////                        if pm.locality != nil {
////                            addressString = addressString + pm.locality! + ", "
////                        }
////                        if pm.country != nil {
////                            addressString = addressString + pm.country! + ", "
////                        }
////                        if pm.postalCode != nil {
////                            addressString = addressString + pm.postalCode! + " "
////                        }
////                        print(addressString)
////                        completion(addressString)
////                       // return addressString
////                  }
////                    else{
////                        completion("")
////                    }
////
////            })
////             //return (addressString)
////        }
////}
//
//
//
//extension String {
//    var isLocalImageUrl: Bool {
//        return !self.contains("http") && !self.contains("www.")
//    }
//}
//
//extension String {
//    func subString(from: Int, to: Int) -> String {
//        if(self.count > 0){
//            let startIndex = self.index(self.startIndex, offsetBy: from)
//            let endIndex = self.index(self.startIndex, offsetBy: to)
//            return String(self[startIndex...endIndex])
//        }
//        else{
//            return ""
//        }
//    }
//
//
//}
//
//extension String {
//    subscript (i: Int) -> Character {
//        return self[index(startIndex, offsetBy: i)]
//    }
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
//}
//
//extension String {
//
//    var containsEmoji: Bool {
//        for scalar in unicodeScalars {
//            switch scalar.value {
//            case 0x1F600...0x1F64F, // Emoticons
//            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
//            0x1F680...0x1F6FF, // Transport and Map
//            0x2600...0x26FF,   // Misc symbols
//            0x2700...0x27BF,   // Dingbats
//            0xFE00...0xFE0F,   // Variation Selectors
//            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
//            0x1F1E6...0x1F1FF: // Flags
//                return true
//            default:
//                continue
//            }
//        }
//        return false
//    }
//}
//
//extension String {
//    var currencyAppended: String {
//        return "KD \(self)"
//    }
//}
//
//extension String {
//    func rangeFromNSRange(string: String, range: Range <String.Index>) -> NSRange? {
//        guard let range = self.range(of: string, options: .caseInsensitive, range: range, locale: .current) else {
//            return nil
//
//        }
//
//        return NSRange(range, in: self)
//    }
//    func nsRange(from range: Range<String.Index>) -> NSRange {
//        if  let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) {
//
//            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
//                           length: utf16.distance(from: from, to: to))
//        }
//        return NSRange.init(location: 0, length: 1)
//    }
//
//    func width(with font: UIFont,
//               padding: CGFloat = 0,
//               maxWidth: CGFloat = 1000) -> CGFloat {
//        let fontAttributes = [NSAttributedString.Key.font: font]
//        let size = (self as NSString).size(withAttributes: fontAttributes)
//        let width = size.width + padding
//        return width < maxWidth ? width : maxWidth
//    }
//
//}
