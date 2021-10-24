//
//  DefinitionsViewController.swift
//  SlangTranslator
//
//  Created by Eric Xie on 10/24/21.
//

import UIKit

class DefinitionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTableCell: UITableViewCell!
    
    // translated text here for myTextView
    public var translatedText: String = ""
    var pairs: [WordDefinitionPair] = []
    var ranges: [String: NSRange] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.text = translatedText
        myTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        myTextView.layer.borderWidth = 4
        myTextView.layer.cornerRadius = 5
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(TemplateTableViewCell.nib(), forCellReuseIdentifier: TemplateTableViewCell.identifier)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TemplateTableViewCell.identifier, for: indexPath) as! TemplateTableViewCell
        let pair: WordDefinitionPair = pairs[indexPath.row]
        
        cell.configure(with: pair.word, wordDef: pair.definition)
        return cell
    }
    
    func initializeAttributedText() {
        let originalText = translatedText.lowercased()
        
        let originalAttributedText = NSMutableAttributedString(string: originalText)
        for pair in pairs {
            ranges[pair.word] = originalAttributedText.mutableString.range(of: pair.word, options: .caseInsensitive)
        }
        
        for(word, _) in ranges {
            let linkRange = originalAttributedText.mutableString.range(of: word, options: .caseInsensitive)
            print(linkRange)
            
            originalAttributedText.addAttribute(.foregroundColor, value: UIColor.green, range: linkRange)
            originalAttributedText.addAttribute(.link, value: word, range: linkRange)
        }
    }


}

extension DefinitionsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let selectedWord = URL.absoluteString
        if let index = pairs.firstIndex(where: {$0.word == selectedWord}) {
            
            myTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
        }
        
        return false
    }
}


