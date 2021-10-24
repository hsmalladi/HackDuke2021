//
//  APIManager.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    
    static func getJSON(url: String, completion:@escaping (JSON) -> ()) {
        
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            let json = JSON(value)
                            completion(json)
                        case 400:
                            completion(JSON(["failure": "Error: Invalid query, please contact app support"]))
                        case 403:
                            completion(JSON(["failure": "Error: Invalid API key, please contact app support"]))
                        case 429:
                            completion(JSON(["failure": "Error: Too many requests, please contact app support"]))
                        default:
                            completion(JSON(""))
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(JSON(""))
            }
            
        }
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func postMethod(postURL: String, data: Data) {
            guard let url = URL(string: postURL) else {
                print("Error: cannot create URL")
                return
            }
            
            // Create model
            struct UploadData: Codable {
                let name: String
                let salary: String
                let age: String
            }
            
            // Add data to the model
            let uploadDataModel = UploadData(name: "Jack", salary: "3540", age: "23")
            
            // Convert model to JSON data
            guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
                print("Error: Trying to convert model to JSON data")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling POST")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Couldn't print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
    
    
    
}

