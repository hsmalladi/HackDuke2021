//
//  TextInputViewController.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import UIKit
import Foundation

class TextInputViewController: UIViewController {

    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    var inputtedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        guard let text = mainTextView.text else {
            return
        }
        
        if text.trimmingCharacters(in: .whitespaces) == "" {
            print("Please enter some text to translate.")
            let alert = UIAlertController(title: "Please enter some text to translate.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        // Create model
        struct UploadData: Codable {
            let textToTranslate: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(textToTranslate: text)
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        //APIManager.postMethod(postURL: <#T##String#>, data: jsonData)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextTranslation" {
            
        }
    }
    
}

