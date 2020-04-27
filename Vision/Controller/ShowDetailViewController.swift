//
//  ShowDetailViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageButton: UIButton!
    
    var imageOCR: [GoogleOCR] = []
    
    var isProcessing: Bool = false {
        didSet {
            addImageButton.isHidden = isProcessing
        }
    }
    
    let pickImage = UIImagePickerController()
    
    fileprivate func loadCoreData() {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        imageOCR = DataController.taskLoadData(type: GoogleOCR.self, search: nil, sort: sort)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickImage.delegate = self
        tableView.register(UINib(nibName: K.ReuseCell.tableViewNibName, bundle: nil), forCellReuseIdentifier: K.ReuseCell.tableViewReuseCell)
        loadCoreData()
        
        addImageButton.layer.cornerRadius = addImageButton.frame.size.width / 2
        addImageButton.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.selectedDetail {
            let viewController = segue.destination as! SelectedDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                viewController.imageOCR = imageOCR[indexPath.row]
            }
        }
    }
    
    @IBAction func addImageFrom(_ sender: Any) {
        
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
    
}
//MARK: - ImagePickerDelegate

extension ShowDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let newImage = image.resizeWithWidth(width: 800) else {return}
            //imageView.image = newImage
            GoogleAPI.taskDetect(form: newImage) { (result) in
                guard let result = result else {
                    print("Don't have any text in image")
                    return
                }
                let object = GoogleOCR(context: DataController.shared.viewContext)
                guard let image = newImage.pngData() else {
                    return
                }
                DataController.shared.viewContext.delete(self.imageOCR[0])
                self.imageOCR.remove(at: 0)
                DataController.saveContext()
                self.tableView.reloadData()
                object.image = image
                object.text = result.fullTextAnnotation.text
                object.date = Date()
                DataController.saveContext()
                self.imageOCR.insert(object, at: 0)
                self.tableView.reloadData()
                self.isProcessing = false
            }
        }
        let object = GoogleOCR(context: DataController.shared.viewContext)
        object.text = "Processing..."
        object.image = UIImage(named: "clock.fill")?.pngData()
        imageOCR.insert(object, at: 0)
        tableView.reloadData()
        isProcessing = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension ShowDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageOCR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.ReuseCell.tableViewReuseCell, for: indexPath) as! DetailTableViewCell
        
        cell.activityIndicator.stopAnimating()
        
        if let image = imageOCR[indexPath.row].image {
            cell.imageCurrent.image = UIImage(data: image)
            cell.finishLoadData()
        } else {
            cell.setLoadingData()
            cell.activityIndicator.startAnimating()
        }
        
        if let text = imageOCR[indexPath.row].text {
            cell.textTitle.text = String(text.prefix(40))
        }
        
        if let textCount = imageOCR[indexPath.row].text?.count {
            cell.charCount.text = "Charector count: \(textCount)"
        }
        
        if let date = imageOCR[indexPath.row].date {
            cell.dateLabel.text = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            DataController.shared.viewContext.delete(self.imageOCR[indexPath.row])
            self.imageOCR.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            DataController.saveContext()
        }
        action.title = "Delete"
        action.backgroundColor = .red
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isProcessing {
            performSegue(withIdentifier: K.Segue.selectedDetail, sender: nil)
        }
    }
}
