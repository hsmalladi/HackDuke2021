//
//  ImageInputViewController.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import UIKit
import AWSS3
import AWSMobileClient

class ImageInputViewController: UIViewController {
    
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    var selectedImage: UIImage?
    var currentImageName: String?
    
    var wordDefinitionPairs: [WordDefinitionPair] = []
    var fullText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.setImage(nil, for: .normal)
        imageButton.setTitle("Tap to upload an image", for: .normal)

    }
    
    @IBAction func imageViewTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        //Show loading screen
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        guard let image = imageButton.currentImage, let selected = selectedImage else {
            //Remove loading view upon completion of API Calls
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            
            
            let alert = UIAlertController(title: "Please upload an image.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        AWSS3Manager.shared.uploadImage(withImage: selected) { imageName in
            if imageName == "Error" {
                //Remove loading view upon completion of API calls
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                
                
                let alert = UIAlertController(title: "Error uploading image.", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let parameters = ["image_name": imageName]
            let url = APIURL.postImageURL.rawValue
            
            APIManager.postJSON(url: url, parameters: parameters) { data in
                print(data)
                if data.isEmpty {
                    //Remove loading view upon completion of API calls
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
                    
                    //Remove loading view upon completion of API calls
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    
                    self.performSegue(withIdentifier: "showImageTranslation", sender: self)
                    
                    
                } catch let error {
                    //Remove loading view upon completion of API calls
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    
                    print("Can't decode JSON because of error: \(error)")
                }
                
            }
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    

}


extension ImageInputViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.selectedImage = image
            imageButton.setTitle("", for: .normal)
            imageButton.setImage(image, for: .normal)
        }
        
        if let imageName = info[.imageURL] as? String {
            currentImageName = imageName
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}


