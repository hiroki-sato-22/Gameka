//
//  SmallGoalViewCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/07/17.
//

import UIKit

class CustomViewCell: UITableViewCell{

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
