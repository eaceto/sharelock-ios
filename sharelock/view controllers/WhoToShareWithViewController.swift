//
//  WhoToShareWithViewController.swift
//  sharelock
//
//  Created by Kimi on 18/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import WSTagsField

class WhoToShareWithViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tagsBaseView: UIView!
    let tagsField = WSTagsField()
    
    public var secret: Secret?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTagsField()
        
        NotificationCenter.default.addObserver(forName: Secret.secretClearedNotification.name, object: nil, queue: OperationQueue.main, using: { notification in
            self.tagsField.removeTags()
            self.updateUI()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsField.becomeFirstResponder()
    }
    
    func initTagsField() {
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsField.spaceBetweenLines = 4.0
        tagsField.spaceBetweenTags = 8.0
        tagsField.font = .systemFont(ofSize: 12.0)
        tagsField.backgroundColor = .white
        tagsField.tintColor = UIColor.darkGray
        tagsField.textColor = .white
        tagsField.fieldTextColor = .darkGray
        tagsField.selectedColor = .black
        tagsField.selectedTextColor = .white
        tagsField.delimiter = ","
        tagsField.isDelimiterVisible = false
        tagsField.placeholderColor = .white
        tagsField.placeholder = ""
        tagsField.placeholderAlwaysVisible = false
        tagsField.returnKeyType = .next
        tagsField.enableScrolling = true
        
        tagsBaseView.addSubview(tagsField)
        
        tagsField.translatesAutoresizingMaskIntoConstraints = false
    tagsBaseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": tagsField]))
    tagsBaseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": tagsField]))
        
        tagsField.onDidAddTag = { (_,_) in
            self.updateUI()
        }
        
        tagsField.onDidRemoveTag = { (_,_) in
            self.updateUI()
        }
        
        tagsField.onDidChangeText = { _, text in }
        
        tagsField.onDidChangeHeightTo = { sender, height in }
        
        tagsField.onValidateTag = { tag, tags in return true }
    }
    
    func updateUI() {
        self.nextButton.isEnabled = !self.tagsField.tags.isEmpty
    }

    @IBAction func onNextButtonPressed(_ sender: Any) {
        let contacts = tagsField.tags.map({t in return t.text})
        if contacts.isEmpty {
            return
        }
        
        let generateLinkViewController = GenerateLinkViewController.init(nibName: "GenerateLinkViewController", bundle: nil)
        Secret.current?.replace(allowedViewers: contacts)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(generateLinkViewController, animated: true)
    }
}
