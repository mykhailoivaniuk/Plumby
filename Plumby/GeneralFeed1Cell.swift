//
//  GeneralFeed1Cell.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 12/12/20.
//

import UIKit

class GeneralFeed1Cell: UITableViewCell {
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var postPicture: UIImageView!
    
    @IBOutlet weak var numberOfRatings: UILabel!
    @IBOutlet weak var ratingAverage: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var pricePH: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
