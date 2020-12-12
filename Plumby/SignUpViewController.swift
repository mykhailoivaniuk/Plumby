//
//  SignUpViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 11/27/20.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordTextFieldSU: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextFieldSU.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        phoneTextField.attributedPlaceholder =
            NSAttributedString(string: "8053053495", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        usernameTextField.attributedPlaceholder =
            NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        emailTextField.attributedPlaceholder =
            NSAttributedString(string: "your_email@mail.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextFieldSU.text
        user.email = emailTextField.text
        user["phone"] = phoneTextField.text

        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                print("User phone in label.text : \(self.phoneTextField.text)")
                print("User phone in user['phone'] : \(user["phone"])")
            }
            else {
                print("Error: \(error?.localizedDescription)")
            }
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
    */


