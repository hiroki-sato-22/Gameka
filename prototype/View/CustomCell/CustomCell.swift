//
//  CustomCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/08/30.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
