//
//  Top10CustomCell.swift
//  AMMAC
//
//  Created by Sefa Sevtekin on 3/19/16.
//  Copyright © 2016 Sefa Sevtekin. All rights reserved.
//

import UIKit

class Top10CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
