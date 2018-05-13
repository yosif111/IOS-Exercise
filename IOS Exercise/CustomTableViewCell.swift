//
//  CustomTableViewCell.swift
//  IOS Exercise
//
//  Created by YOUSEF ALKHALIFAH on 21/08/1439 AH.
//  Copyright © 1439 YOUSEF ALKHALIFAH. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
