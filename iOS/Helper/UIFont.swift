//
//  UIFont.swift

//

import UIKit

// MARK: - UIFont Extension
extension UIFont {
        
    class func boldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica-Bold",
                      size: size)!
    }
    
    class func regularFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica",
                      size: size)!
    }

}
