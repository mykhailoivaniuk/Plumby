//
//  MyRequests1TableViewCell.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 12/12/20.
//

import UIKit

class MyRequests1TableViewCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var numOfRatings: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
