//
//  User.swift
//  ReceiptScan
//
//  Created by Edison Ooi on 10/23/21.
//

import Foundation

class User: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var password: String = ""
    var foodGoal: Double = 0.0
    var foodAmount: Double = 0.0
    var clothesGoal: Double = 0.0
    var clothesAmount: Double = 0.0
    var entertainmentGoal: Double = 0.0
    var entertainmentAmount: Double = 0.0
    
    typealias Receipts = [Receipt]
    
    
    //Singleton user
    static var global = User()
    
    enum CodingKeys: String, CodingKey {
        case username, password
    }
    
    func configure() {
        
    }
    
    func resetInfo() {
        
    }
    
    
    
    
}
