//
//  TextInputViewController.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class TextInputViewController: UIViewController {

    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    var inputtedText: String = ""
    
    var wordDefinitionPairs: [WordDefinitionPair] = []
    
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
        
       
        
        let parameters = ["text": text]
        let url = APIURL.postTextURL.rawValue
        
        APIManager.postJSON(url: url, parameters: parameters) { data in
            print(data)
            if data.isEmpty {
                let alert = UIAlertController(title: "Error getting API data.", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                self.wordDefinitionPairs = try decoder.decode([WordDefinitionPair].self, from: data["words"].rawData())
                
                self.performSegue(withIdentifier: "showTextTranslation", sender: self)
                
                
            } catch let error {
                print("Can't decode JSON because of error: \(error)")
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextTranslation" {
            
        }
    }
    
}

