//
//  GeneralFeedViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 12/11/20.
//

import UIKit
import Parse
import AlamofireImage
import VegaScrollFlowLayout

class GeneralFeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
   
    var posts = [PFObject]()
    var user  = PFUser.current()!
    let myrefreshControl = UIRefreshControl()
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "Request Service", message: "Are you you sure you want to request this service?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let requestAction = UIAlertAction(title: "Request", style: .cancel) { (UIAlertAction) in
            let post = self.posts[indexPath.row]
            let request = PFObject(className: "Requests")
            request["requested_by"] = PFUser.current()!
            request["requested_by_username"] = PFUser.current()!.username as! String
            request["post"] = post
            
            post.add(request, forKey: "requests")
            post.add(PFUser.current()!.username, forKey: "requested_by_username")
            post.saveInBackground { (success, error) in
                if success{
                    print("Request Saved")
                }
                else {
                    print("Error Saving Request")
                }
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MyRequests2ViewController") as! MyRequests2ViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        sheet.addAction(requestAction)
        sheet.addAction(cancelAction)
        present(sheet, animated: true, completion: nil)
        
        
        return
    }
    
    
    
    func getAverageStar(total: Float, numReviews: Float) -> String{
        if numReviews == 0 {
            return "No reviews"
        }
        let avg:Float = total/numReviews
        let avgStr: String = String(format: "%.1f", avg)
        return avgStr
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        
        
    }
    @objc func loadData(){
        let query = PFQuery(className: "Publications")
        query.includeKeys(["objectId", "author", "image", "totalRatings", "numRatings", "title"])
        query.findObjectsInBackground{
            (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myrefreshControl.endRefreshing()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        myrefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = myrefreshControl

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralFeed1Cell") as! GeneralFeed1Cell
        
        let post = posts[indexPath.row]
        
        cell.postAuthor.text = user.username
        cell.postTitleLabel.text = post["title"] as! String
        cell.pricePH.text = post["price"] as! String
        cell.ratingAverage.text = getAverageStar(total: post["totalRatings"] as! Float, numReviews: post["numRatings"] as! Float)
        cell.postDescription.text = post["description"] as! String
        cell.Location.text = post["location"] as! String
        cell.numberOfRatings.text = String(format: "(%.0f)", post["totalRatings"] as! Float)
        // set post's image
        if post["image"] != nil {
            let imageFile = post["image"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            cell.postPicture.af.setImage(withURL: url)
        }
        
//        cell.objectId = post.objectId!
//        cell.delegate = self
//        cell.reloadDelegate = self
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
