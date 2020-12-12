//
//  MyRequests2ViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 12/12/20.
//

import UIKit
import Parse
import AlamofireImage

class MyRequests2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
   
    
    
    var posts = [PFObject]()
    var requests = [PFObject]()
    var user = PFUser.current()!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Requests")
        query.includeKeys(["post","requested_by_username"]).whereKey("requested_by", equalTo: user)
        
        query.findObjectsInBackground { (requests, error) in
            if requests != nil{
                self.requests = requests!
                self.tableView.reloadData()
                
            }
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = requests[indexPath.row]
        let post = request["post"] as! PFObject
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRequests1TableViewCell") as! MyRequests1TableViewCell
        cell.taskTitleLabel.text = post["title"] as! String
        cell.taskerNameLabel.text = post["author"] as! String
        
        if post["image"] != nil {
            let imageFile = post["image"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            cell.postImage.af.setImage(withURL: url)
        }
        
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
