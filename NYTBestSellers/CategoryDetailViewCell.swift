//
//  CategoryDetailViewCell.swift
//  nyTimesBestSeller
//
//  Created by Kyle Ong on 10/1/16.
//  Copyright © 2016 Kyle Ong. All rights reserved.
//

import UIKit

class CategoryDetailViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var ranksValue: UILabel!

    @IBOutlet weak var bookDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

