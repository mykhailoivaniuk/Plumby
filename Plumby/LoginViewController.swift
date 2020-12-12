//
//  LoginViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 11/27/20.
//

import UIKit
import Parse
import SwiftyGif


extension UIView {
    func setBorderLogin(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
  func setCorner1(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}




class LoginViewController: UIViewController {

    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var logintextfield: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gif = try! UIImage(gifName: "2gears.gif")
        self.Logo.setGifImage(gif, loopCount: -1) // Will loop forever
        
        logintextfield.setBorderLogin(width: 1, color: UIColor.systemGray)
        passwordField.setBorderLogin(width: 1, color: UIColor.systemGray)

        logintextfield.setCorner1(radius: 15)
        passwordField.setCorner1(radius: 15)

        logintextfield.attributedPlaceholder =
            NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordField.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let username = logintextfield.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
//    */
    



}

