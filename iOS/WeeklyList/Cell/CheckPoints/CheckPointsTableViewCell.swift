//
//  CheckPointsTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit

class CheckPointsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkImage1: UIImageView!
    @IBOutlet weak var checkImage2: UIImageView!
    @IBOutlet weak var checkImage3: UIImageView!
    @IBOutlet weak var checkImage4: UIImageView!
    
    @IBOutlet weak var checkLabel1: UILabel!
    @IBOutlet weak var checkLabel2: UILabel!
    @IBOutlet weak var checkLabel3: UILabel!
    @IBOutlet weak var checkLabel4: UILabel!
    
    
    @IBOutlet weak var checjbox4: UIButton!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var bottomViewButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkbox3: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var checkBox1: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    /*
     // for attendance
     var isPresent: Bool?
     // for checkpoint
     var checkList: [Bool]?
     // score
     var score: Int? // this is used for grades, gradeA-F
     var maxScore: Int?
     */
    var buttonTapped:((_ tagValue : Int,_ selectedStudent: StudentModel)->Void)?
    // for newAdded
    
    var checkPoints: Int?{
        didSet{
            switch self.checkPoints {
            case 1:
                self.checkImage1.isHidden = false
                self.checkLabel1.isHidden = false
                self.checkImage2.isHidden = true
                self.checkLabel2.isHidden = true
                self.checkImage3.isHidden = true
                self.checkLabel3.isHidden = true
                self.checkImage4.isHidden = true
                self.checkLabel4.isHidden = true
            case 2:
                self.checkImage1.isHidden = false
                self.checkLabel1.isHidden = false
                self.checkImage2.isHidden = false
                self.checkLabel2.isHidden = false
                self.checkImage3.isHidden = true
                self.checkLabel3.isHidden = true
                self.checkImage4.isHidden = true
                self.checkLabel4.isHidden = true
            case 3:
                self.checkImage1.isHidden = false
                self.checkLabel1.isHidden = false
                self.checkImage2.isHidden = false
                self.checkLabel2.isHidden = false
                self.checkImage3.isHidden = false
                self.checkLabel3.isHidden = false
                self.checkImage4.isHidden = true
                self.checkLabel4.isHidden = true
            default:
                self.checkImage1.isHidden = false
                self.checkLabel1.isHidden = false
                self.checkImage2.isHidden = false
                self.checkLabel2.isHidden = false
                self.checkImage3.isHidden = false
                self.checkLabel3.isHidden = false
                self.checkImage4.isHidden = false
                self.checkLabel4.isHidden = false
            }
        }
    }
    
    var studentObj: StudentModel?{
        didSet{
            
            self.setImage()
            self.shadowView.layer.cornerRadius = 10
            self.profilePic.sd_setImage(with: URL(string: self.studentObj?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.profilePic.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
            self.shadowView.dropShadow()
            self.profilePic.clipsToBounds = true
            self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
            self.studentName.text = self.studentObj?.name ?? ""
            self.studentIdLabel.text = self.studentObj?.id
        }
    }
    
    func setImage()  {
    
        for i in 0..<(self.studentObj?.checkList!.count)! {
            let value = self.studentObj?.checkList?[i]
            let image = UIImage(named: value == true ? "check" : "uncheck")
            if i == 0 {
                self.checkImage1.image = image
                    //setImage(image)
            }
            else if i == 1{
                self.checkImage2.image = image
            }
            else if i == 2{
                self.checkImage3.image = image
            }
            else{
                self.checkImage4.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didCheckButtonTapped(_ sender: UIButton) {
        self.buttonTapped?(sender.tag, self.studentObj!)
        
        if sender.tag == 1 {
            //let image = UIImage(named: value == true ? "check" : "uncheck")
            let image = (self.checkImage1.image == UIImage(named: "check") ? UIImage(named: "uncheck") : UIImage(named: "check"))
            self.checkImage1.image = image
            //setImage(image)
        }
        else if sender.tag == 2{
            let image = (self.checkImage2.image == UIImage(named: "check") ? UIImage(named: "uncheck") : UIImage(named: "check"))
            self.checkImage2.image = image
        }
        else if sender.tag == 3{
            let image = (self.checkImage3.image == UIImage(named: "check") ? UIImage(named: "uncheck") : UIImage(named: "check"))
            self.checkImage3.image = image
        }
        else{
            let image = (self.checkImage4.image == UIImage(named: "check") ? UIImage(named: "uncheck") : UIImage(named: "check"))
            self.checkImage4.image = image
        }
    }
    
}
