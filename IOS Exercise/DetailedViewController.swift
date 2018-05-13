//
//  DetailedViewController.swift
//  IOS Exercise
//
//  Created by YOUSEF ALKHALIFAH on 22/08/1439 AH.
//  Copyright © 1439 YOUSEF ALKHALIFAH. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var postTitle: String? = nil
    var content: String? = nil
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        titleLabel.text = postTitle
        title = postTitle
        textView.text = content
        imageView.image = image
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this is to enable going back on left swap
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}
