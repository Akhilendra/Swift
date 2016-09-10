//
//  sidebarFirstCell.swift
//  Travelling
//
//  Created by Muskan on 8/15/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit

class sidebarFirstCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgUser.image = UIImage(named: "dride-transparent")
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.valueForKey(TravellingConstants.NSUserDefaults.username)!
        let mobile = defaults.valueForKey(TravellingConstants.NSUserDefaults.user_mobile)!
        lblMobile.textColor = UIColor.whiteColor()
        lblName.textColor = UIColor.whiteColor()
        lblName.text = name as? String
        lblMobile.text = mobile as? String
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
