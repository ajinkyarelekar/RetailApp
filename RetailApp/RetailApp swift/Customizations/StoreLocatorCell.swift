//
//  StoreLocatorCell.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 30/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class StoreLocatorCell: UITableViewCell
{
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblAddrs: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
