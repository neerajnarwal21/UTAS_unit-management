//
//  HomeViewController.swift
//  UTAS Tutorial marking
//
//  Created by Neeraj Narwal on 07/05/21.
//

import UIKit
import  XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Configuration
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor =
            UIColor(red: 31.0/255.0, green: 0.0/255.0, blue: 169.0/255.0, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 31.0/255.0, green: 0.0/255.0, blue: 169.0/255.0, alpha: 1)

        settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = .gray
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        settings.style.selectedBarHeight = 6.0
        settings.style.selectedBarBackgroundColor = UIColor(red: 95.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)
        
        // Changing item text color on swipe
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .white
        }
    }
    
  
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard.init(name: Constant.storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewControllerIdentifier.tutorialViewController) as! ChildViewController
        //child1.childNumber = "One"
        
        let child2 = UIStoryboard.init(name: Constant.storyboard.main, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewControllerIdentifier.studentViewvontroller) as! SecondChildViewController
       
        return [child1, child2]
    }

}
