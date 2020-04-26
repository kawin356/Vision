//
//  TakeAPhotoViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit
import CoreData

class TakeAPhotoViewController: UIViewController {
    
    @IBOutlet weak var choicePhotoInputButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let pickImage = UIImagePickerController()
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickImage.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        prepareForNewImage()
        
    }
    
    func prepareForNewImage() {
        textView.isHidden = true
        textView.text = ""
        
        choicePhotoInputButton.layer.cornerRadius = choicePhotoInputButton.frame.size.width / 2
        choicePhotoInputButton.layer.masksToBounds = true
    }
    
    @IBAction func chooseInputButtonPressed(_ sender: UIButton) {
        
        prepareForNewImage()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.pickImage.sourceType = .camera
            self.present(self.pickImage, animated: true, completion: nil)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.pickImage.sourceType = .photoLibrary
            self.present(self.pickImage, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func saveImageAndTextBarButtonPressed(_ sender: UIBarButtonItem) {
        saveImageAndTextToCoreData()
    }
    
    func saveImageAndTextToCoreData() {
        let object = GoogleOCR(context: DataController.shared.viewContext)
        guard let image = imageView.image?.pngData() else {
            return
        }
        object.image = image
        object.text = textView.text
        object.date = Date()
        DataController.saveContext()
    }
}


//MARK: - ImagePickerDelegate

extension TakeAPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let newImage = image.resizeWithWidth(width: 800) else {return}
            imageView.image = newImage
            GoogleAPI.taskDetect(form: newImage) { (result) in
                guard let result = result else {
                    print("Don't have any text in image")
                    return
                }
                self.textView.isHidden = false
                self.textView.text = result.fullTextAnnotation.text
                self.saveImageAndTextToCoreData()
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
