//
//  takeAPhotoViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 25/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class takeAPhotoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    let pickImage = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickImage.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        pickImage.sourceType = .camera
        self.present(pickImage, animated: true, completion: nil)
    }
    
    @IBAction func photoLibrary(_ sender: UIBarButtonItem) {
        pickImage.sourceType = .photoLibrary
        self.present(pickImage, animated: true, completion: nil)
    }
    
}


//MARK: - ImagePickerDelegate

extension takeAPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let newImage = image.resizeWithWidth(width: 800) else {return}
            imageView.image = newImage
            GoogleAPI.taskDetect(form: newImage) { (result) in
                guard let result = result else {
                    print("Don't have any text in image")
                    return
                }
                self.textView.text = result.fullTextAnnotation.text
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

