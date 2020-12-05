//
//  EditPublicationViewController.swift
//  Plumby
//
//  Created by Thu Do on 12/5/20.
//

import UIKit
import Parse
import AlamofireImage

class EditPublicationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    var post : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInfo()
    }
    
    func loadInfo() {
        if post["image"] != nil {
            let imageFile = post["image"] as! PFFileObject
            let urlStr = imageFile.url!
            let url = URL(string: urlStr)!
            imageView.af.setImage(withURL: url)
        }
        
        titleField.text = post["title"] as! String
        locField.text = post["location"] as! String
        descField.text = post["description"] as! String
        priceField.text = post["price"] as! String
    }
    
    @IBAction func onCancel(_ sender: Any) {
        let alert = UIAlertController(title: "Discard Changes", message: "All changes will be discarded.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Keep Editing", style: .default, handler: { (action: UIAlertAction!) in
            // do nothing
        }))

        alert.addAction(UIAlertAction(title: "Discard", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        post["title"] = titleField.text!
        post["location"] = locField.text!
        post["description"] = descField.text!
        post["price"] = priceField.text!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        post["image"] = file
        post.saveInBackground{
            (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // There was a problem, check error.description
                    print("Cannot save changes: \(error?.localizedDescription)")
                    let alert = UIAlertController(title: "Sorry!", message: "An error occurred while we were trying to save your changes.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
                        // do nothing
                    }))
                }
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
