//
//  CropperViewController.swift
//
//  Created by Artem Krachulov.
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit
import AKImageCropperView

final class CropperViewController: UIViewController {

    //  MARK: - Properties
    
    var image: UIImage!
    
    var completionHandler: (UIImage) -> Void = { _ in
        
    }
    
    // MARK: - Connections:
    
    // MARK: -- Outlets
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? cropViewStoryboard
    }
    
    @IBOutlet weak var cropViewStoryboard: AKImageCropperView!
    private var cropViewProgrammatically: AKImageCropperView!
    
    @IBOutlet weak var navigationView: UIView!
    
    // MARK: -- Actions
    
    @IBAction func backAction(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cropImageAction(_ sender: AnyObject) {
        guard let image = cropView.croppedImage?.resizeWithWidth(width: 800) else {
            return
        }
        
        completionHandler(image)
    }
    
    @IBAction func showHideOverlayAction(_ sender: AnyObject) {
        if cropView.isOverlayViewActive {
            cropView.hideOverlayView(animationDuration: 0.3)
        } else {
            cropView.showOverlayView(animationDuration: 0.3)
        }
    }
    
    var angle: Double = 0.0
    
    @IBAction func rotateAction(_ sender: AnyObject) {
        
        angle += Double.pi / 2
        
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * Double.pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        
        cropView.reset(animationDuration: 0.3)
        angle = 0.0
    }
    
    // MARK: -  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        
        cropView.delegate = self
        cropView.image = image
    }
}

//  MARK: - AKImageCropperViewDelegate

extension CropperViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        //        print("New crop rectangle: \(rect)")
    }
    
}
