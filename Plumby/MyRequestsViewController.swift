//
//  MyRequestsViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 12/12/20.
//

import UIKit
import Parse
import AlamofireImage

class MyRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var requests = [PFObject]()
    var user = PFUser.current()!
    let myrefreshControl = UIRefreshControl()
    var mypost : PFObject
    




    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadposts()
    }
    
    func loadposts(){
        let query = PFQuery(className: "Requests")
        query.whereKey("requested_by", equalTo: user)
        query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
            if let error = error {
                // The request failed
                print(error.localizedDescription)
            } else {
                // comments now contains the comments for myPost
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
}
