//
//  AttendanceTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentId: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    var buttonTapped:((UIButton)->Void)?
    /*
     // for attendance
     var isPresent: Bool?
     // for checkpoint
     var checkList: [Bool]?
     // score
     var score: Int? // this is used for grades, gradeA-F
     var maxScore: Int?
     */
    var studentObj: StudentModel?{
        didSet{
            let image = self.studentObj?.isPresent ?? false == true ? UIImage(named: "check") :UIImage(named: "uncheck")
            print(image)
            self.checkButton.setImage(image, for: .normal)
            self.profilePic.sd_setImage(with: URL(string: self.studentObj?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.profilePic.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
            self.shadowView.dropShadow()
            self.profilePic.clipsToBounds = true
            self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
            self.studentName.text = self.studentObj?.name ?? ""
            self.studentId.text = self.studentObj?.id
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    @IBAction func didTapCheckUncheck(_ sender: UIButton) {
        self.buttonTapped?(sender)
        if sender.imageView?.image == UIImage(named: "check"){
            sender.setImage( UIImage(named: "uncheck"), for: .normal)
        }
        else{
            sender.setImage( UIImage(named: "check"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
