//
//  GlobalFunctions.swift
//

import SwiftMessages
import UIKit

// global functions
func delay(_ seconds: Double, f: @escaping () -> Void) {
    let delay = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delay) {
        f()
    }
}

// MARK: - Top bar
func showWorkInProgress() {
    showMessage(with: "Work in progress", theme: .warning)
}


func showMessage(with title: String, theme: Theme = .error) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
        view.bodyLabel?.font = UIFont.regularFont(with: 12)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}

// MARK: - Get/Set image
func getImageFromTempDirectory(_ imageName: String) -> UIImage? {
    if imageName.isLocalImageUrl {
        let tempDirectory  = NSTemporaryDirectory()
        let imageURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(imageName)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    return nil
}

func saveImageToTempDirectory(image: UIImage, specificFileName: String? = nil) -> String? {
    if let imageData = image.pngData() {
        let tempDirectory  = NSTemporaryDirectory()
        let fileName = specificFileName ?? "\(Date().timeIntervalSince1970).png"
        let imageURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
        do {
            try imageData.write(to: imageURL)
            return fileName
        } catch {
            print("error saving file:", error)
        }
    }
    return nil
}

func getPriceInFloatWithCurrency(tCurrency: String?, tAmount: Double?)-> String {
    let  currency = tCurrency?.uppercased()
    var price: String?
    let decimalValue =  ("\(tAmount ?? 0)" as NSString).floatValue
    let floatValue = String(format:"%.2f", decimalValue)
    if(currency == "$"){
        price = " \(currency ?? "") "+"\(floatValue) "
    }
    else{
        price = " \(currency ?? "") "+"\(floatValue) "
    }
    
    return price ?? ""
}
