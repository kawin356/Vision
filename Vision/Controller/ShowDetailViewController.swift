//
//  ShowDetailViewController.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit
import TransitionButton


class ShowDetailViewController: CustomTransitionViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageOCR: [GoogleOCR] = []
    
    var indexPathForSelectedRow: IndexPath?
    
    var isProcessing: Bool = false {
        didSet {
            addImageButton.isHidden = isProcessing
        }
    }
    
    let pickImage = UIImagePickerController()
    
    //MARK: - App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickImage.delegate = self
        tableView.register(UINib(nibName: K.ReuseCell.tableViewNibName, bundle: nil), forCellReuseIdentifier: K.ReuseCell.tableViewReuseCell)
        
        setupPullRefresh()
        setupRadiusButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCoreData()
        checkInternetConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.selectedDetail {
            let viewController = segue.destination as! SelectedDetailViewController
            if let indexPath = indexPathForSelectedRow {
                viewController.imageOCR = imageOCR[indexPath.row]
            }
        }
    }
    
    //MARK: - Function
    
    fileprivate func showAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func checkInternetConnection() {
        if !InternetConnection.shared.isConnectionNormal {
            isProcessing = true
        }
    }
    
    fileprivate func loadCoreData() {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        imageOCR = DataController.taskLoadData(type: GoogleOCR.self, search: nil, sort: sort)
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    fileprivate func setupRadiusButton() {
        addImageButton.layer.cornerRadius = addImageButton.frame.size.width / 2
        addImageButton.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.layer.masksToBounds = true
    }
    
    fileprivate func setupPullRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadCoreData()
        refreshControl.endRefreshing()
    }
    
    //MARK: - IBAction
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
    
    fileprivate func addCellProcessing(_ image: UIImage) {
        let object = GoogleOCR(context: DataController.shared.viewContext)
        object.text = K.Text.processing
        object.image = image.jpegData(compressionQuality: 0.5)
        object.date = Date()
        imageOCR.insert(object, at: 0)
        tableView.reloadData()
        isProcessing = true
    }
    
    fileprivate func removeCellProcessing() {
        DataController.shared.viewContext.delete(self.imageOCR[0])
        self.imageOCR.remove(at: 0)
        DataController.saveContext()
        self.tableView.reloadData()
        self.isProcessing = false
    }
    
    fileprivate func saveCoreDataInsertTable(_ object: GoogleOCR, _ image: Data, _ result: Results) {
        object.image = image
        object.text = result.fullTextAnnotation.text
        object.date = Date()
        DataController.saveContext()
        self.imageOCR.insert(object, at: 0)
        self.tableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let newImage = image.resizeWithWidth(width: 800) else {return}
            GoogleAPI.taskDetect(form: newImage) { (result,errorString) in
                guard let result = result else {
                    self.showAlert(text: errorString!)
                    self.removeCellProcessing()
                    return
                }
                let object = GoogleOCR(context: DataController.shared.viewContext)
                guard let image = newImage.pngData() else {
                    return
                }
                self.removeCellProcessing()
                self.saveCoreDataInsertTable(object, image, result)
                
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            addCellProcessing(image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - UITableViewDelegate
extension ShowDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageOCR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.ReuseCell.tableViewReuseCell, for: indexPath) as! DetailTableViewCell
        
        cell.activityIndicator.stopAnimating()
        
        if let text = imageOCR[indexPath.row].text, text != K.Text.processing {
            cell.finishLoadData()
            if let image = imageOCR[indexPath.row].image {
                cell.imageCurrent.image = UIImage(data: image)
            }
            
            if let text = imageOCR[indexPath.row].text {
                cell.textTitle.text = String(text.prefix(40))
            }
            
            if let textCount = imageOCR[indexPath.row].text?.count {
                cell.charCount.text = "Charector count: \(textCount)"
            }
            
            if let date = imageOCR[indexPath.row].date {
                cell.dateLabel.text = date.getFormattedDate(format: "yyyy-MM-dd HH:mm")
            }
        } else {
            if let image = imageOCR[indexPath.row].image {
                cell.imageCurrent.image = UIImage(data: image)
            }
            cell.textTitle.text = K.Text.processing
            cell.setLoadingData()
            cell.activityIndicator.startAnimating()
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
        tableView.deselectRow(at: indexPath, animated: true)
        indexPathForSelectedRow = indexPath
        performSegue(withIdentifier: K.Segue.selectedDetail, sender: nil)
    }
}

