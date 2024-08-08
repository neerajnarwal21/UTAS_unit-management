//
//  StudentDetailCellTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 11/05/21.
//

import UIKit

class StudentDetailCellTableViewCell: UITableViewCell {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tutorialTypeLabel: UILabel!
    @IBOutlet weak var weeklabel: UILabel!
    var tutorialObj: TutorialsModel?{
        didSet{
            self.shadowView.dropShadow()
            self.weeklabel.text = "Week \(self.tutorialObj?.weekNo ?? 0)"
            self.tutorialTypeLabel.text = self.tutorialObj?.tuteType?.getTuteTypeString()
            let matchedRecords = tutorialObj?.list?.filter({$0.studentId == self.studentObj?.id})
            if matchedRecords?.count ?? 0 > 0 {
                self.scoreLabel.text = "Score \(matchedRecords?.first?.totalMarks ?? 0)"
            }
            else{
                self.scoreLabel.text = "Score 0"
            }
        }
    }
    var studentObj: StudentModel?
    
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
