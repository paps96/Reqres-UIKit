//
//  ProtoTableViewCell.swift
//  Reqres-UIKit
//
//  Created by Pedro Alberto Parra Solis on 25/08/22.
//

import UIKit

class ProtoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageCell: UIImageView!
    @IBOutlet weak var NameCell: UILabel!
    @IBOutlet weak var LastNameCell: UILabel!
    @IBOutlet weak var EmailCell: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
