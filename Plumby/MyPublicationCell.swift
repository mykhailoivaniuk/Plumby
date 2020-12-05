//
//  MyPublicationCell.swift
//  Plumby
//
//  Created by Thu Do on 12/4/20.
//

import UIKit
import Parse

protocol MyPublicationCellDelegate {
    func reloadTable()
}

class MyPublicationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    var objectId:String!
    var delegate: MyPublicationsViewController?
    var reloadDelegate: MyPublicationCellDelegate?
    
    @IBAction func onDelete(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Delete this post?", message: "We cannot undo this action", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let query = PFQuery(className: "Publications")
            query.includeKeys(["objectId"]).whereKey("objectId", equalTo: self.objectId!)
            query.findObjectsInBackground{
                (posts, error) in
                if posts != nil {
                    for post in posts as! [PFObject]{
                        post.deleteEventually()
                        self.reloadDelegate?.reloadTable()
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
//        let main = UIStoryboard(name: "Main", bundle: nil)
//        let vc = main.instantiateViewController(identifier: "myPublicationsViewController")
            
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
