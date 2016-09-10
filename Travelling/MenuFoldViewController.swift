//
//  MenuFoldViewController.swift
//  Menu Foldable
//
//  Created by Agus Cahyono on 5/4/16.
//  Copyright © 2016 Agus Cahyono. All rights reserved.
//

import UIKit

class MenuFoldViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuFoldItemTable: UITableView!
    let identiferCell = "menu"
    
    let shareData = ShareData.sharedInstance
    var NumberofRows: Int!
    var display_nameArray = [String]()
    var companyArray = [String]()
    var minimumArray = [String]()
    var cost_per_distanceArray = [String]()
    var base_fareArray = [String]()
    var cancellation_feeArray = [String]()
    var cost_per_minuteArray = [String]()
    var surge_multiplierArray = [String]()
    var ride_estimate_minArray = [String]()
    var ride_estimate_maxArray = [String]()
    var etaArray = [String]()
    

    //let cabItem = ["Mini","Sedan","Mini","Sedan","Mini","Sedan","Mini","Sedan"]
    //var etaArray = [7,8,5,4,7,45,4,5]
    //var baseArray = [12,56,45,87,134,67,78,54]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "MenuFoldViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    override func viewDidLayoutSubviews() {
    
        let tempImageView = UIImageView(image: UIImage(named: "welcome-background-2"))
        tempImageView.frame = self.menuFoldItemTable.frame
        self.menuFoldItemTable.backgroundView = tempImageView;
        
        
        //        self.menuFoldItemTable.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.menuFoldItemTable.registerNib(MenuItemTableViewCell.createNib(), forCellReuseIdentifier: identiferCell)
        
        self.display_nameArray = self.shareData.display_nameArray
        self.companyArray = self.shareData.companyArray
        self.minimumArray = self.shareData.minimumArray
        self.cost_per_distanceArray = self.shareData.cost_per_distanceArray
        self.base_fareArray = self.shareData.base_fareArray
        self.cancellation_feeArray = self.shareData.cancellation_feeArray
        self.cost_per_minuteArray = self.shareData.cost_per_minuteArray
        self.surge_multiplierArray = self.shareData.surge_multiplierArray
        self.ride_estimate_minArray = self.shareData.ride_estimate_minArray
        self.ride_estimate_maxArray = self.shareData.ride_estimate_maxArray
        self.etaArray = self.shareData.etaArray
        
        print("display name from menufold: \(display_nameArray)")
    }
    
    //MARK: UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //To Add Clear Spaces Between two cells
//        if shareData.selection == 2  {
//            return 1
//        }
//        else if shareData.selection == 1 {
//            return 4
//        } else {
//            return 0
//        }
         return display_nameArray.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identiferCell) as! MenuItemTableViewCell
        
            
        cell.lblCab.text = display_nameArray[indexPath.section]
        cell.lblCab.textColor = UIColor.yellowColor()
        if companyArray[indexPath.section] == "ola" {
            cell.imgCompany.image = UIImage(named: "ola_logo")
        } else {
            cell.imgCompany.image = UIImage(named: "uber_logo")
        }
        cell.lblETA.text = "ETA: \(etaArray[indexPath.section]) min"
        cell.lblBase.text = "Base: Rs. \(base_fareArray[indexPath.section])/-, Rs. \(cost_per_distanceArray[indexPath.section])/km"
            
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        // remove separator cell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        

        return cell
        //cell.contentView.backgroundColor = UIColor(netHex: colorMenus[indexPath.row])
        
        
    }
    

}

