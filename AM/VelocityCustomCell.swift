//
//  VelocityCustomCell.swift
//  AMMAC
//
//  Created by Sefa Sevtekin on 3/22/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit

class VelocityCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

