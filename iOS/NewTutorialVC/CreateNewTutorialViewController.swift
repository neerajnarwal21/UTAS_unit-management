//
//  CreateNewTutorialViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 09/05/21.
//

import UIKit
import DropDown

class CreateNewTutorialViewController: UIViewController {
    var selectedWeekId: Int?
    var selectedTutorialTypeId: Int?
    var selectedCheckPointOptionId: Int?
    
    
    @IBOutlet weak var selectedCheckPointOptionLabel: UILabel!
    @IBOutlet weak var maxScoreTextfield: UITextField!
    @IBOutlet weak var scoreheightConstraints: NSLayoutConstraint!
    @IBOutlet weak var checkPointViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var selectTutorialTypeLabel: UILabel!
    @IBOutlet weak var selectedWeekLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedWeekId = 1
        self.selectedTutorialTypeId = 0
        self.selectTutorialTypeLabel.text = UTASStore.tutorialType[0]
        self.selectedWeekLabel.text = UTASStore.tutorialWeek[0]
        self.checkPointViewHeightConstraints.constant = 0
        self.scoreheightConstraints.constant = 0
    }
    
    @IBAction func didTapTutorialWeek(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = UTASStore.tutorialWeek
        // Do any additional setup after loading the view.
        dropDown.show()
        
        dropDown.selectionAction = {  (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.selectedWeekId = index+1
            self.selectedWeekLabel.text = UTASStore.tutorialWeek[index]
        }
    }
    
    @IBAction func didTapSelectTutorialTypeButton(_ sender: UIButton) {
        
        let dropDown = DropDown()
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = sender.tag == 2 ? UTASStore.checkPointOption : UTASStore.tutorialType
        // Do any additional setup after loading the view.
        dropDown.show()
        
        dropDown.selectionAction = {  (index: Int, item: String) in
            if(sender.tag != 2){
                self.checkPointViewHeightConstraints.constant = index == 1 ? 77 : 0
                self.selectedCheckPointOptionLabel.text = index == 1 ? "1" : ""
                self.selectedCheckPointOptionId =  index == 1 ? 1 : nil
                self.scoreheightConstraints.constant = index == 2 ? 77 : 0
                
                self.selectedTutorialTypeId = index
                self.selectTutorialTypeLabel.text = UTASStore.tutorialType[index]
            }
            else{
                self.selectedCheckPointOptionId = index+1
                self.selectedCheckPointOptionLabel.text = item
            }
        }
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        if let matchedWeek = FireBaseManager.sharedInstance.tutorialArray?.filter({$0.weekNo == selectedWeekId}) {
            if matchedWeek.count > 0 {
                showMessage(with: Constant.Statictext.alreadyExist)
            }
            else{
                // move to next screen
                // add validation for if tutorialType is Score
                if self.selectedTutorialTypeId?.getTuteTypeEnum() == .score {
                    // new add and type is score
                    guard let maxScore = self.maxScoreTextfield.text else { return showMessage(with: Constant.Statictext.enterMaxScore) }
                    if maxScore.isEmpty {
                        return showMessage(with: Constant.Statictext.enterMaxScore)
                    }
                    let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.weeklyList) as! WeeklyListViewController
                    vc.title = Constant.Statictext.title
                    vc.weeklyListFor = .newAdded
                    vc.maxScore = self.selectedTutorialTypeId?.getTuteTypeEnum() == .score ? Int(maxScore) : nil
                    vc.tutorialIntValueForAdded = self.selectedTutorialTypeId // for all
                    vc.weekNoIdForAdded = self.selectedWeekId // for all
                    vc.selectedCheckPoints = self.selectedCheckPointOptionId // for chrckpoints
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
                else{
                    let vc = storyboard?.instantiateViewController(identifier: Constant.ViewControllerIdentifier.weeklyList) as! WeeklyListViewController
                    vc.title = Constant.Statictext.title
                    vc.weeklyListFor = .newAdded
//                    vc.maxScore = self.selectedTutorialTypeId?.getTuteTypeEnum() == .score ? Int(self.maxScoreTextfield.text ?? "0") : nil
                    vc.tutorialIntValueForAdded = self.selectedTutorialTypeId // for all
                    vc.weekNoIdForAdded = self.selectedWeekId // for all
                    vc.selectedCheckPoints = self.selectedCheckPointOptionId // for chrckpoints
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            }
        }
    }
    
    
}

extension CreateNewTutorialViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(1 ?? 0 <= 100)
        return  (Int(newText) ?? 1 <= 100 && Int(newText) ?? 1 >= 1)
     }
}
