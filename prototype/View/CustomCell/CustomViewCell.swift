//
//  SmallGoalViewCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit

class CustomViewCell: UITableViewCell{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
