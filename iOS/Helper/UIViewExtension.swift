//
//  UIView.swift


//

import Foundation
import UIKit

extension UIView{
    func dropShadow(scale: Bool = true) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
    }
}
