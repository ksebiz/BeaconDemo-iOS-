//
//  BeaconListCell.swift
//  BeaconInterview
//
//  Created by Hari Krishna on 8/3/23.
//

import UIKit

class BeaconListCell: UITableViewCell {

  @IBOutlet weak var minorLabel: UILabel!
  @IBOutlet weak var majorLabel: UILabel!
  @IBOutlet weak var uuidLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
