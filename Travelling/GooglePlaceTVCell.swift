//
//  GooglePlaceTVCell.swift
//  Travelling
//
//  Created by Muskan on 8/27/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit

class GooglePlaceTVCell: UITableViewCell {
    
    static func createNib() -> UINib {
        //return UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        return UINib(nibName: "productTableVCCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
