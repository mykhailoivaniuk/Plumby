//
//  MyPublicationsViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 11/28/20.
//

import UIKit
import Parse
import AlamofireImage

class MyPublicationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPublicationCellDelegate {
    
    // function used in MyPublicationCellDelegate to reload table after deleting posts
    func reloadTable() {
        print("getting called")
        loadPosts()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var user = PFUser.current()!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        loadPosts()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    @objc func loadPosts() {
            
        let query = PFQuery(className: "Publications")
        query.includeKeys(["objectId", "author", "image", "totalRatings", "numRatings", "title"]).whereKey("author", equalTo: user)
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        PFUser.logOut()
                
        let main = UIStoryboard(name: "Main", bundle: nil)
        let startController = main.instantiateViewController(identifier: "startController")
                
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = startController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPublicationCell") as! MyPublicationCell
        
        cell.nameLabel.text = user.username
        cell.summaryLabel.text = post["title"] as! String
        cell.starLabel.text = getAverageStar(total: post["totalRatings"] as! Float, numReviews: post["numRatings"] as! Float)
        
        cell.countLabel.text = String(format: "(%.0f)", post["totalRatings"] as! Float)
        // set post's image
        if post["image"] != nil {
            let imageFile = post["image"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            cell.photoView.af.setImage(withURL: url)
        }
        
        cell.objectId = post.objectId!
        cell.delegate = self
        cell.reloadDelegate = self
        return cell
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
        // find the selected row
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        // pass the selected row to details view controller
        let detailsViewController = segue.destination as! MyPublicationSinglePostViewController
        detailsViewController.post = post
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
