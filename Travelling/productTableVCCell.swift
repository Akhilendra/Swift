//
//  productTableVCCell.swift
//  Travelling
//
//  Created by Muskan on 8/14/16.
//  Copyright © 2016 Muskan. All rights reserved.
//

import UIKit

class productTableVCCell: UITableViewCell {

    
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblCab: UILabel!
    @IBOutlet weak var lblEta: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    
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
