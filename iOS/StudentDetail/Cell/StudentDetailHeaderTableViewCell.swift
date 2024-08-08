//
//  StudentDetailHeaderTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 11/05/21.
//

import UIKit

class StudentDetailHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weeklyDetailLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    var didTapButton: ((Int)->Void)?
    

    var studentobj: StudentModel?{
        didSet{
            self.profilePicImageView.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
            self.profilePicImageView.clipsToBounds = true
            self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.width/2
            self.profilePicImageView.sd_setImage(with: URL(string: self.studentobj?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.studentNameLabel.text = self.studentobj?.name ?? ""
            self.studentIdLabel.text = self.studentobj?.id ?? ""
            self.weeklyDetailLabel.text = "Weekly Detail(Avg \(self.studentobj?.average ?? 0))%"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.getPercentage()
        // Initialization code
    }
    
    func getPercentage()  {
       
        
        
    }
    
    

    @IBAction func didTapButton(_ sender: UIButton) {
        self.didTapButton?(sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
