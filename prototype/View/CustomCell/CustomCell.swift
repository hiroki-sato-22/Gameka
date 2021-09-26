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
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
