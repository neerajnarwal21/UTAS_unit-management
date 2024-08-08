//
//  StudentTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 08/05/21.
//

import UIKit
import SDWebImage
class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var studentAvgLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var studentObj: StudentModel?{
        didSet{
            self.shadowView.dropShadow()
            self.profilePic.clipsToBounds = true
            self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
            self.studentNameLabel.text = self.studentObj?.name ?? ""
            self.studentIdLabel.text = self.studentObj?.id
            if self.studentObj?.average ?? 0 > 0{
                self.studentAvgLabel.text = "Avg: \(self.studentObj?.average ?? 0 )%"
            }
            else{
                self.studentAvgLabel.text = ""
            }
            self.profilePic.sd_setImage(with: URL(string: self.studentObj?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.profilePic.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
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

}
