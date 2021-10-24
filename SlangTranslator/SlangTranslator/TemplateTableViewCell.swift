//
//  TemplateTableViewCell.swift
//  SlangTranslator
//
//  Created by Eric Xie on 10/23/21.
//

import UIKit


class TemplateTableViewCell: UITableViewCell {
    
    
    @IBOutlet var wordTitle: UILabel!
    @IBOutlet var wordDefinition: UILabel!
    
    static let identifier = "TemplateTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "TemplateTableViewCell",
                     bundle: nil)
            
    }
    
    public func configure(with title: String, wordDef: String){
        wordTitle.text = title
        wordDefinition.text = wordDef
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
    
}


