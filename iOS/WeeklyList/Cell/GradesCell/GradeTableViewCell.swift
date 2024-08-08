//
//  GradeTableViewCell.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit
import DropDown

class GradeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var selectedGradeLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentName: UILabel!
    var selectedDropDownValue:((String,_ withIndex:Int)->Void)?
    var cellFor: Weeklytype?
    let dropDown = DropDown()
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
            self.selectedGradeLabel.text = cellFor == .grades ? self.studentObj?.score?.getGradesfromInt() : self.studentObj?.score?.getGradesAtoFfromInt()
           
        }
    }
    
    @IBAction func didTapSelectGrade(_ sender: UIButton) {
        dropDown.anchorView = sender
        // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        switch cellFor {
        case .grades:
            dropDown.dataSource = UTASStore.grades
        default:
            dropDown.dataSource = UTASStore.gradesAtoF
        }
        // Do any additional setup after loading the view.
        dropDown.show()
        dropDown.selectionAction = {  (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.selectedGradeLabel.text = item
            self.selectedDropDownValue?(item, index)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
