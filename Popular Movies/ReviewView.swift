//
//  ReviewView.swift
//  Popular Movies
//
//  Created by Owen LaRosa on 10/21/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit

class ReviewView: UIView {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func toggleExpandedState(_ sender: UIButton) {
        if sender.titleLabel?.text == "Expand" {
            sender.titleLabel?.text = "Collapse"
        } else {
            sender.titleLabel?.text = "Expand"
        }
    }
    
}
