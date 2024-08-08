//
//  ScoreTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var obtainScore: UITextField!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentName: UILabel!
    var changeTextField:((UITextField)->Void)?
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
            self.profilePic.sd_setImage(with: URL(string: self.studentObj?.photoURL ?? ""), placeholderImage: UIImage(named: "dummyUser"), options:.continueInBackground, completed: nil)
            self.profilePic.backgroundColor = UIColor(red: 152/255.0, green: 113/255.0, blue: 201/255.0, alpha: 1.0)
            self.shadowView.dropShadow()
            self.profilePic.clipsToBounds = true
            self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
            self.studentName.text = self.studentObj?.name ?? ""
            self.studentIdLabel.text = self.studentObj?.id
            self.obtainScore.addTarget(self, action:  #selector(textFieldEditingDidChange), for: .editingChanged)
            self.obtainScore.text = "\(studentObj?.score ?? 0)"
            self.totalScoreLabel.text = "/\(studentObj?.maxScore ?? 0)"
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

extension ScoreTableViewCell:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        print("textField: \(sender.text!)")
        self.changeTextField?(sender)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(Int(newText) ?? 0 <= self.studentObj?.maxScore ?? 0)
        return  Int(newText) ?? 0 <= self.studentObj?.maxScore ?? 0
     }
    
}
