//
//  PublishViewController.swift
//  Plumby
//
//  Created by Thu Do on 11/28/20.
//

import UIKit
import Parse
import AlamofireImage

class PublishViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let publication = PFObject(className:"Publication")
        publication["author"] = PFUser.current()!
        publication["price"] = priceField.text!
        publication["description"] = descriptionField.text!
        publication["title"] = titleField.text!
        publication["location"] = locationField.text!
        publication["rating"] = [Int]()
        publication["requests"] = [PFObject]() // an array of Request objects
        publication.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Delete", message: "All fields will be emptied.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            // reset image and text fields to original state
            self.imageView.image = UIImage(named: "image_placeholder")
            self.titleField.text = ""
            self.priceField.text = ""
            self.locationField.text = ""
            self.descriptionField.text = ""
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              // do nothing
        }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
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
