//
//  MenuItemTableViewCell.swift
//  Menu Foldable
//
//  Created by Agus Cahyono on 5/4/16.
//  Copyright © 2016 Agus Cahyono. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookNowBtn: UIButton!
    
    @IBOutlet weak var lblCab: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    @IBOutlet weak var imgCompany: UIImageView!
    
    static func createNib() -> UINib {
        return UINib(nibName: "MenuItemTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        bookNowBtn.titleLabel!.lineBreakMode = .ByWordWrapping
//        bookNowBtn.titleLabel!.numberOfLines = 2
        bookNowBtn.titleLabel!.textAlignment = .Center
        bookNowBtn.layer.cornerRadius = bookNowBtn.frame.size.height / 2
        bookNowBtn.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
