//
//  ImageInputViewController.swift
//  SlangTranslator
//
//  Created by Edison Ooi on 10/23/21.
//

import UIKit

class ImageInputViewController: UIViewController {
    
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    var currentImageName: String?
    
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
        guard let image = imageButton.currentImage else {
            let alert = UIAlertController(title: "Please upload an image.", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        
    }
    

}


extension ImageInputViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
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
