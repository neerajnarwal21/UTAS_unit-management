//
//  TutorialTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 08/05/21.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tutorialTypeLabel: UILabel!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var classAverageLabel: UILabel!
    var tutorialObj:TutorialsModel?{
        didSet{
//            var tutorialType = String()
//            switch self.tutorialObj?.tuteType {
//            case 1:
//                tutorialType = "Checkpoints"
//            case 2:
//                tutorialType = "Score"
//            case 3:
//                tutorialType = "Grades"
//            case 4:
//                tutorialType = "Grades(A-F)"
//            default:
//                tutorialType = "Attendance"
//            }

            self.tutorialLabel.text = "Week \(self.tutorialObj?.weekNo ?? 0)"
            self.classAverageLabel.text =  "\(Constant.Statictext.classavg) \(self.tutorialObj?.average ?? 0 )%"
            self.tutorialTypeLabel.text = self.tutorialObj?.tuteType?.getTuteTypeString() ?? ""
            self.shadowView.dropShadow()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
