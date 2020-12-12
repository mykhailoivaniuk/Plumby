//
//  startControllerViewController.swift
//  Plumby
//
//  Created by Mykhailo Ivaniuk on 11/27/20.
//

import UIKit

class startControllerViewController: UIViewController {
    @IBOutlet weak var LogoGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gif = try! UIImage(gifName: "2gears.gif")
        self.LogoGif.setGifImage(gif, loopCount: -1) // Will loop forever
        // Do any additional setup after loading the view.
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
