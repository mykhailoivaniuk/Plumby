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
        let publication = PFObject(className:"Publications")
        publication["author"] = PFUser.current()!
        publication["price"] = priceField.text!
        publication["description"] = descriptionField.text!
        publication["title"] = titleField.text!
        publication["location"] = locationField.text!
        publication["totalRatings"] = Float(0)
        publication["numRatings"] = Float(0)
        publication["requests"] = [PFObject]() // an array of Request objects
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        publication["image"] = file
        
        publication.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                let alert = UIAlertController(title: "Published!", message: "Do you want to stay or navigate to My Services tab?", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "My services", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.resetFields()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "myPublicationsViewController") as! MyPublicationsViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Stay", style: .default, handler: { (action: UIAlertAction!) in
                    self.resetFields()
                }))

                self.present(alert, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
                print("Cannot save publication: \(error?.localizedDescription)")
                let alert = UIAlertController(title: "Sorry!", message: "An error occurred while we were trying to save your post.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
                    // do nothing
                }))
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        let alert = UIAlertController(title: "Delete", message: "All fields will be emptied. Do you want to proceed?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.resetFields()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              // do nothing
        }))

        present(alert, animated: true, completion: nil)
        
    }
    
    func resetFields() {
        // reset image and text fields to original state
        self.imageView.image = UIImage(named: "image_placeholder")
        self.titleField.text = ""
        self.priceField.text = ""
        self.locationField.text = ""
        self.descriptionField.text = ""
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
