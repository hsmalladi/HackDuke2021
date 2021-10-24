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

class TextInputViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var placeholderText: UILabel!
    
    var inputtedText: String = ""
    
    var wordDefinitionPairs: [WordDefinitionPair] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Translate Text"
        self.navigationController?.isNavigationBarHidden = false
        
        mainTextView.delegate = self
        placeholderText.text = "Type in text or paste here"
        placeholderText.font = UIFont.italicSystemFont(ofSize: (mainTextView.font?.pointSize)!)
        placeholderText.sizeToFit()
        mainTextView.addSubview(placeholderText)
        placeholderText.textColor = UIColor.lightGray
        placeholderText.isHidden = !mainTextView.text.isEmpty
        mainTextView.textContainerInset.left = 10

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
            placeholderText.isHidden = !mainTextView.text.isEmpty
        }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        performSearch()
        
    }
    
    func performSearch() {
        guard let text = mainTextView.text else {
            return
        }
        
        performSegue(withIdentifier: "showTextTranslation", sender: self)
        
        
        
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
            let fakePairs = [
                WordDefinitionPair(word: "lmao", definition: "Laugh my ass off"),
                WordDefinitionPair(word: "lol", definition: "Laugh out loud"),
                WordDefinitionPair(word: "wtf", definition: "aweufiuwaen fiuawefiu enwafuawe  iufnlaiweufi awejcilu snfiuan wilcun awieyfb lweajcn auwr fhla sjd clkuawnefciaelfbarybvld jsncuawrgi awenf weo fn  ajefa lweflk ajw  awef nalwf n afnwenfwea"),
                
                
            ]
//            destVC.pairs = self.wordDefinitionPairs
            destVC.pairs = fakePairs
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            // Do any additional stuff here
            dismissKeyboard()
            performSearch()
            
            return false
        }
        return true
    }
    
}

