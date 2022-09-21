//
//  DetetctedTextViewController.swift
//  GoogleMLDemo
//
//  Created by Haider Ali on 21/09/2022.
//

import UIKit

class DetetctedTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var textDetected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = textDetected
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
