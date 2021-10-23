//
//  LoginViewController.swift
//  ReceiptScan
//
//  Created by Edison Ooi on 10/23/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    @IBOutlet weak var bruh: UIButton!
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let name = usernameTextField.text, let pass = passwordTextField.text else {return}
        
        if name == "" || pass == "" {
            return
        }
        
        //Show loading screen
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            //Remove loading view upon completion of Hypixel API calls
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        })
        
        
        
        

        
        
    }
    
}
