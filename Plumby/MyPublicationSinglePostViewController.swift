//
//  MyPublicationSinglePostViewController.swift
//  Plumby
//
//  Created by Thu Do on 12/4/20.
//

import UIKit
import Parse
import AlamofireImage

class MyPublicationSinglePostViewController: UIViewController {
    
    var post : PFObject!
    var user = PFUser.current()!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFields()
    }
    
    func setFields() {
        // set post's image
        if post["image"] != nil {
            let imageFile = post["image"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            imageView.af.setImage(withURL: url)
        }
        
        titleLabel.text = post["title"] as! String
        
        starLabel.text = getAverageStar(total: post["totalRatings"] as! Float, numReviews: post["numRatings"] as! Float)
        
        countLabel.text = String(format: "(%.0f)", post["totalRatings"] as! Float)
        
        authorLabel.text = user.username
        locLabel.text = post["location"] as! String
        descLabel.text = post["description"] as! String
        
    }
    
    func getAverageStar(total: Float, numReviews: Float) -> String{
        if numReviews == 0 {
            return "No reviews"
        }
        let avg:Float = total/numReviews
        let avgStr: String = String(format: "%.1f", avg)
        return avgStr
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the selected row to details view controller
        let editViewController = segue.destination as! EditPublicationViewController
        editViewController.post = post
    }

}
