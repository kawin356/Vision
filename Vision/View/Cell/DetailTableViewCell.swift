//
//  DetailTableViewCell.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 26/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageCurrent: UIImageView!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var charCount: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setLoadingData() {
        imageView?.isHidden = true
        textTitle?.text = "Processing..."
        charCount?.isHidden = true
        dateLabel?.isHidden = true
    }
    
    func finishLoadData() {
        imageView?.isHidden = false
        charCount?.isHidden = false
        dateLabel?.isHidden = false
    }
    
}
