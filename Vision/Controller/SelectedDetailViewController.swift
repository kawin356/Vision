//
//  SelectedDetailViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class SelectedDetailViewController: UIViewController {
    
    var imageOCR: GoogleOCR!
    
    var pasteBoard = UIPasteboard.general
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneEditBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneEditBarButton.isEnabled = false
        checkKeyboard()
        
        imageView.image = UIImage(data: imageOCR.image!)
        textView.text = imageOCR.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeCheckKeyboard()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        imageOCR.text = textView.text
        DataController.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneEditingButtonPressed(_ sender: UIBarButtonItem) {
        textView.endEditing(true)
        doneEditBarButton.isEnabled = false
    }
    
    @IBAction func copyTextButtonPressed(_ sender: UIBarButtonItem) {
        copyToClipBoard(textToCopy: textView.text)
    }
    
    private func copyToClipBoard(textToCopy: String) {
        pasteBoard.string = textToCopy
    }
}
