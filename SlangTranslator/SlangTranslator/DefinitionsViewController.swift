//
//  DefinitionsViewController.swift
//  SlangTranslator
//
//  Created by Eric Xie on 10/24/21.
//

import UIKit

class DefinitionsViewController: UIViewController {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTableCell: UITableViewCell!
    
    // translated text here for myTextView
    public var translatedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.text = translatedText
        myTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        myTextView.layer.borderWidth = 4
        myTextView.layer.cornerRadius = 5
    }
    


}
