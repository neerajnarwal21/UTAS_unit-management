//
//  CreateStudentViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 11/05/21.
//

import UIKit
import SkyFloatingLabelTextField
import AVKit
import Photos
import MobileCoreServices
import WebKit
import FirebaseStorage

class CreateStudentViewController: UIViewController {
    var imagePicker:UIImagePickerController!
    private let reference = Storage.storage().reference().child("images").child("234")
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var studentNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var studentIDTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var userProfileImageView: UIImageView!
    var student: StudentModel?
    
    var imageURL: String?{
        didSet{
            self.addButton.isEnabled =   student?.photoURL?.trimBeginAndEnd().lowercased() == self.imageURL?.trimBeginAndEnd().lowercased() ? false : true
            self.addButton.alpha = student?.name?.trimBeginAndEnd().lowercased() == self.imageURL?.trimBeginAndEnd().lowercased() ? 0.5 : 1.0
        }
    }
    var comingFor: Weeklytype?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfileImageView.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
        self.userProfileImageView.clipsToBounds = true
        self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.width/2
        
        switch comingFor {
        case .newAdded:
            self.titleLabel.text = Constant.Statictext.addstudent
            self.studentIDTextfield.isEnabled = true
            self.addButton.setTitle(Constant.Statictext.addStudentUpper, for: .normal)
            self.addButton.isEnabled = true
            self.addButton.alpha = 1.0
        default:
            self.titleLabel.text = Constant.Statictext.updateStudent
            self.studentIDTextfield.isEnabled = false
            self.studentIDTextfield.text = self.student?.id ?? ""
            self.studentNameTextField.text = self.student?.name ?? ""
            self.imageURL = self.student?.photoURL ?? ""
            self.userProfileImageView.sd_setImage(with: URL(string: self.student?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.addButton.setTitle(Constant.Statictext.updateStudentupper, for: .normal)
            self.addButton.isEnabled = false
            self.addButton.alpha = 0.5
            self.studentNameTextField.addTarget(self, action:  #selector(textFieldEditingDidChange), for: .editingChanged)
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.studentNameTextField.resignFirstResponder()
        self.studentIDTextfield.resignFirstResponder()
    }
    
    @IBAction func didTapProfileImage(_ sender: UIButton) {
        switch comingFor {
        case .newAdded:
            print("nw Added")
            DispatchQueue.main.async {
                self.openPhotoSelection()
            }
            
        default:
            print("update")
            DispatchQueue.main.async {
                self.openPhotoSelection()
            }
        }
    }
    
    @IBAction func didTapAddStudent(_ sender: UIButton) {
        if studentIDTextfield.text?.isEmpty == true {
            showMessage(with:Constant.Statictext.enterStudentId)
            return
        }
        else if studentNameTextField.text?.isEmpty == true {
            showMessage(with:Constant.Statictext.enterStudentname)
            return
        }
        else if(FireBaseManager.sharedInstance.studentsAray.filter({$0.id ?? "" == self.studentIDTextfield.text?.trimBeginAndEnd() })).count > 0{
            showMessage(with:Constant.Statictext.studentAlready)
            return
        }
        else{
            let newDict = ["active":1,"id":studentIDTextfield.text ?? "","name":studentNameTextField.text ?? "","photoURL":self.imageURL ?? ""] as [String:Any]
            print(self.student?.documentId ?? "")
            
            switch comingFor {
            case .newAdded:
                print("nw Added")
                FireBaseManager.sharedInstance.create(tableName: Constant.firebaseTableName.student, data: newDict) { (isSucess, message, errorMessage) in
                    if isSucess == true{
                        print("Got Sucess added")
                        let alert = UIAlertController(title:Constant.Statictext.studentaddedSucess, message: "", preferredStyle: .alert)
                        let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(ok)
                        self.navigationController?.present(alert, animated: true, completion:nil)
                        
                    }
                    else{
                        print("Got failure added")
                        let alert = UIAlertController(title:Constant.Statictext.somethingWentWrong, message: "", preferredStyle: .alert)
                        let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                        }
                        alert.addAction(ok)
                        self.navigationController?.present(alert, animated: true, completion:nil)
                    }
                }
                
            default:
                print("update")
                FireBaseManager.sharedInstance.update(tableName: Constant.firebaseTableName.student, tableRefID: student?.documentId ?? "", withData: newDict) { (isSucess, message, errorMessage) in
                    if isSucess == true{
                        print("Got Sucess update")
                        let alert = UIAlertController(title:Constant.Statictext.studentupdatedSucess, message: "", preferredStyle: .alert)
                        let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                            // self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popViewControllers(viewsToPop: 2)
                        }
                        alert.addAction(ok)
                        //.actions[ok,cancel]
                        self.navigationController?.present(alert, animated: true, completion:nil)
                    }
                    else{
                        print("Got failure update")
                        let alert = UIAlertController(title:Constant.Statictext.somethingWentWrong, message: "", preferredStyle: .alert)
                        let  ok = UIAlertAction(title: Constant.Statictext.ok, style: .default) { (action) in
                            
                        }
                        alert.addAction(ok)
                        self.navigationController?.present(alert, animated: true, completion:nil)
                    }
                }
            }
        }
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        print("textField: \(sender.text!)")
        self.addButton.isEnabled =   student?.name?.trimBeginAndEnd().lowercased() == sender.text?.trimBeginAndEnd().lowercased() ? false : true
        self.addButton.alpha = student?.name?.trimBeginAndEnd().lowercased() == sender.text?.trimBeginAndEnd().lowercased() ? 0.5 : 1.0
    }
}
 

extension CreateStudentViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func openPhotoSelection(){
        let optionMenu = UIAlertController(title:"Choose Action", message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style:.default, handler:
        {
            
            (alert: UIAlertAction!) -> Void in
            self.CameraOpenGallery(isCamera: true)
            
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style:.default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.CameraOpenGallery(isCamera: false)
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style:.destructive, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(CancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    /**
     - CameraOpenGallery: This  function is used to fetch images from gallery or camera
     -parameter:
     -isCamera:  its used to check wheither it selects gallery or camera
     */
    func CameraOpenGallery(isCamera:Bool){
        
        
         let  camera_gallery_Permission_message = "App does not have access to your camera or Photos. To enable access, tap Settings and turn On Camera and Photos. This allows you to select the profile photo from the photo library & Camera on your phone";
        
      let  alert_camera_message = "Permission Denied!";
        
        let mediaImg = kUTTypeImage  as String
        let mediaVid = kUTTypeMovie  as String
        
        if isCamera == true{
            let status  = AVCaptureDevice.authorizationStatus(for: .video)
            
            if status == .authorized{
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                //   imagePicker.allowsEditing = true
                self.imagePicker.mediaTypes = [mediaImg,mediaVid]
                self.imagePicker.allowsEditing = true
                self.imagePicker.videoMaximumDuration = 20
                self.imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                
            }else if status == .notDetermined{
                
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (status) in
                    if status == true{
                        DispatchQueue.main.async {
                            self.imagePicker =  UIImagePickerController()
                            self.imagePicker.delegate = self
                            self.imagePicker.sourceType = .camera
                            self.imagePicker.videoMaximumDuration = 20
                            self.imagePicker.mediaTypes = [mediaImg,mediaVid]
                            self.imagePicker.allowsEditing = true
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }else if status == .restricted || status == .denied{
                
                let optionMenu = UIAlertController(title: alert_camera_message, message: camera_gallery_Permission_message, preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "Settings", style:.default, handler:
                {
                    
                    (alert: UIAlertAction!) -> Void in
                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                })
                
                let CancelAction = UIAlertAction(title: "Cancel", style:.cancel, handler:
                {
                    (alert: UIAlertAction!) -> Void in
                })
                optionMenu.addAction(OkAction)
                optionMenu.addAction(CancelAction)
                self.present(optionMenu, animated: true, completion: nil)
            }
        }else{
            checkPhotoLibraryPermission()
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            DispatchQueue.main.async {
                self.askForImageViewOption()
               
            }
            break
        case .denied :
            self.openRestrictedAlert()
            break
        case.restricted:
            self.openRestrictedAlert()
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                
                switch status {
                case .authorized:
                    
                    self.askForImageViewOption()
                    break
                // as above
                case .denied, .restricted:
                    
                    self.openRestrictedAlert()
                    break
                // as above
                case .notDetermined:
                    
                    break
                default:
                    break
                    // won't happen but still
                }
            }
        default:
            break
        }
    }
    func askForImageViewOption(){
        let mediaImg = kUTTypeImage  as String
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = [mediaImg]
        
        self.imagePicker.allowsEditing = false
        self.present(self.imagePicker, animated: true, completion: nil)
       
    }
    func openRestrictedAlert(){
        
        let  camera_gallery_Permission_message = "App does not have access to your camera or Photos. To enable access, tap Settings and turn On Camera and Photos. This allows you to select the profile photo from the photo library & Camera on your phone";
        
        let  alert_camera_message = "Permission Denied!";
        
        let optionMenu = UIAlertController(title: alert_camera_message, message: camera_gallery_Permission_message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "Settings", style:.default, handler:
        {
            
            (alert: UIAlertAction!) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style:.cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(OkAction)
        optionMenu.addAction(CancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    
    //
    //MARK: -  Delegate functions IMAGE PICKER CONTROLLER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let cameraImage  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let sb = UIStoryboard.init(name: Constant.storyboard.main, bundle: nil)
        let cropperVC = sb.instantiateViewController(withIdentifier: "CropperViewController") as! CropperViewController
        
        
        cropperVC.image = cameraImage
        cropperVC.completionHandler = { image in
            picker.dismiss(animated: true, completion: nil)
           // self.sendPhotoAttachment(image:image)
            self.uploadImageToFirebase(image: image)
            // use this image where ever required
        }
        
        picker.show(cropperVC, sender: true)
        
    }
    
    
    
    func uploadImageToFirebase(image:UIImage)  {
        let filename = Date().milliStamp
        self.userProfileImageView.image = image
        guard let imageData = image.pngData() else { return  }
        reference.child("\(filename).png")
            .putData(imageData, metadata: nil) { (metadata, error) in
                // print(metadata.)
                guard  error == nil else{
                    print("failed to upload")
                    return
                }
                
                self.reference.child("\(filename).png").downloadURL { (url, error) in
                    guard let url = url,error == nil else{
                        return
                    }
                    self.imageURL = url.absoluteString
                    print("Downloaded image \(self.imageURL)")
                    
                }
            }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if imagePicker != nil{
            imagePicker.dismiss(animated: false, completion: nil)
        }
        // imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    

    
}

