//
//  InfoCell.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/07.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.backgroundColor = .systemGray2
        colorView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
