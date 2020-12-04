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
        query.includeKeys(["objectId", "author", "image", "rating", "title"]).whereKey("author", equalTo: user)
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
        cell.starLabel.text = getAverageStar(array: post["rating"] as! [Int])
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
    
    func getAverageStar(array: [Int]) -> String{
        if array.count == 0 {
            return "No reviews"
        }
        var sum:Float = 0
        for num in array {
            sum += Float(num)
        }
        let avg:Float = sum/Float(array.count)
        let avgStr: String = String(format: "%.1f", avg)
        return avgStr
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
