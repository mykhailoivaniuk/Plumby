//
//  MyPublicationsViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 11/28/20.
//

import UIKit
import Parse

class MyPublicationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        PFUser.logOut()
                
                let main = UIStoryboard(name: "Main", bundle: nil)
                let startController = main.instantiateViewController(identifier: "startController")
                
                let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                delegate.window?.rootViewController = startController
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
