//
//  ImageDefinitionsViewController.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/24/21.
//

import UIKit

class ImageDefinitionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    
    var image = UIImage()
    var pairs: [WordDefinitionPair] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.image = image
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(TemplateTableViewCell.nib(), forCellReuseIdentifier: TemplateTableViewCell.identifier)
        
        
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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


}
