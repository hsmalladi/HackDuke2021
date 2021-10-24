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

class TextInputViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    @IBOutlet weak var placeholderText: UITextView!
    
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
        
        //Show loading screen
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        let parameters = ["text": text]
        let url = APIURL.postTextURL.rawValue
        
        APIManager.postJSON(url: url, parameters: parameters) { data in
            print(data)
            if data.isEmpty {
                //Remove loading view upon completion of API Calls
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                
                let alert = UIAlertController(title: "Error getting API data.", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                self.wordDefinitionPairs = try decoder.decode([WordDefinitionPair].self, from: data["words"].rawData())
                
                //Remove loading view upon completion of API Calls
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                
                self.performSegue(withIdentifier: "showTextTranslation", sender: self)
                
                
            } catch let error {
                //Remove loading view upon completion of API Calls
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                
                let alert = UIAlertController(title: "Error parsing API data.", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextTranslation" {
            let destVC = segue.destination as! DefinitionsViewController
            destVC.pairs = self.wordDefinitionPairs
        }
    }
    
}

