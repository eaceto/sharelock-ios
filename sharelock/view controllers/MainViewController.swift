//
//  MainViewController.swift
//  sharelock
//
//  Created by Kimi on 18/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dataToShareTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var typeYourSecretBaseView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var charsLimitCounter: UILabel!
    
    var sharelockMenuImageView: UIImageView!
    var didPerfomInitialAnimation = false
    
    let kDataToShareLimit = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharelockImage = UIImage.init(named: "sharelockIcon")
        self.sharelockMenuImageView = UIImageView.init(image: sharelockImage)
        let w = self.view.frame.width
        let h = self.view.frame.height
        self.sharelockMenuImageView.frame = CGRect.init(x: (w - 180)/2, y: (h - 180)/2, width: 180, height: 180)
        self.sharelockMenuImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.sharelockMenuImageView)
        
        NotificationCenter.default.addObserver(forName: Secret.secretClearedNotification.name, object: nil, queue: OperationQueue.main, using: { notification in
            self.dataToShareTextView.text = ""
            self.updateUI()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (didPerfomInitialAnimation == false) {
            perfomInitialAnimation()
        }
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataToShareTextView.becomeFirstResponder()
    }
    
    func perfomInitialAnimation() {
        let endFrame = CGRect.init(x: 12, y: 6, width: 32, height: 32)
        self.sharelockMenuImageView.animateTo(frame: endFrame, withDuration: 0.5, completion: { end in
                self.didPerfomInitialAnimation = true
            UIView.animate(withDuration: 0.5, animations: {
                self.typeYourSecretBaseView.isHidden = false
            })
            })
    }
    
    func updateUI() {
        nextButton.isEnabled = !dataToShareTextView.text.isEmpty
        nextButton.tintColor = dataToShareTextView.text.isEmpty ? UIColor.darkGray : UIColor.white
        let current = dataToShareTextView.text.count
        charsLimitCounter.text = "\(kDataToShareLimit - current)"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUI()
    }

    @IBAction func onNextPressed(_ sender: Any) {
        if dataToShareTextView.text.count > kDataToShareLimit {
            return
        }
        let whoToShareWithVC = WhoToShareWithViewController.init(nibName: "WhoToShareWithViewController", bundle: nil)
        Secret.current = Secret.init(secret: dataToShareTextView.text)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.pushViewController(whoToShareWithVC, animated: true)
    }
}

