//
//  receiptsCell.swift
//  RetailApp swift
//
//  Created by Ajinkya's on 30/04/15.
//  Copyright (c) 2015 Ajinkya. All rights reserved.
//

import UIKit

class receiptsCell: UITableViewCell
{

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblCode: UILabel!
    @IBOutlet var lblAmmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
