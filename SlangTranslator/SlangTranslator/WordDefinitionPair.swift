//
//  WordDefinitionPair.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import Foundation

class WordDefinitionPair: Codable {
    var word: String
    var definition: String
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.word = try values.decode(String.self, forKey: .word)
        self.definition = try values.decode(String.self, forKey: .definition)

    }
    
    enum CodingKeys: String, CodingKey {
        case word, definition
    }

}
