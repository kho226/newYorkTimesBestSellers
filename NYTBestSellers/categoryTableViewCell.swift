//
//  categoryTableViewCell.swift
//  nyTimesBestSeller
//
//  Created by Kyle Ong on 10/1/16.
//  Copyright © 2016 Kyle Ong. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
