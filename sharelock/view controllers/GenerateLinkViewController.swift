//
//  GenerateLinkViewController.swift
//  sharelock
//
//  Created by Kimi on 19/10/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import Crashlytics

class GenerateLinkViewController: UIViewController {

    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var encryptingView: UIView!
    
    private var secret: Secret?
    private var done = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secret = Secret.current
        self.exitButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        if let secret = self.secret {
            LinkAPIClient.shared.generateLinkForSecret(secret, { link, error in
                self.done = true
                if let error = error {
                    Crashlytics.sharedInstance().recordError(error)
                    var message = error.localizedDescription
                    if let err = error as? APIError {
                        message = err.desc
                    }
                    let a = UIAlertController.init(title: "Sharelock", message: message, preferredStyle: .alert)
                    a.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(a, animated: true, completion: nil)
                    return
                }
                if let link = link {
                    self.secret?.addLink(link: link)
                    Answers.logCustomEvent(withName: "Link Created", customAttributes: nil)
                }
                self.updateUI()
            })
        }
    }
    
    func updateUI() {
        if self.done == true {
            DispatchQueue.main.async {
                self.exitButton.isEnabled = true
                self.encryptingView.isHidden = true
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                if let link = self.secret?.link, !link.isEmpty {
                    self.linkTextView.text = link
                    
                    Secret.current?.clear()
                    let shareViewController = UIActivityViewController.init(activityItems: [link], applicationActivities: nil)
                    shareViewController.popoverPresentationController?.sourceView = self.view
                    self.present(shareViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func onExit(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
