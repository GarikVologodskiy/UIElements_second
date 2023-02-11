//
//  ViewController.swift
//  UIElements_second
//
//  Created by Igor Vologodskiy on 08.02.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        textView.isHidden = true
//        textView.alpha = 0
        
//        textView.text = ""

        textView.font = UIFont(name: "AppleSDGothicNeo-Regular" , size: 17)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 10
        
        stepper.value = 17
        stepper.minimumValue = 10
        stepper.maximumValue = 25
        stepper.layer.cornerRadius = 10
        
        stepper.tintColor = .white
        stepper.backgroundColor = .lightGray
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        progressView.setProgress(0, animated: true)
        
        
//        'beginIgnoringInteractionEvents()' was deprecated in iOS 13.0: Use UIView's userInteractionEnabled property instead
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Keyboard appearence tracking
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        //Keyboard hide tracking
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
//        UIView.animate(withDuration: 0, delay: 5, options: .curveEaseIn, animations: {
//            self.textView.alpha = 1
//        }) { (finished) in
//            self.activityIndicator.stopAnimating()
//            self.textView.isHidden = false
//            self.view.isUserInteractionEnabled = true
//
//    //        'beginIgnoringInteractionEvents()' was deprecated in iOS 13.0: Use UIView's userInteractionEnabled property instead
//             UIApplication.shared.endIgnoringInteractionEvents()
//        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.2
            } else {
                self.activityIndicator.stopAnimating()
                self.textView.isHidden = false
                self.view.isUserInteractionEnabled = true
                self.progressView.isHidden = true
            }
        }
    }
    
    // Hide keyboard on tap outside TextView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true) //  Hiding keyboard called for any object
        
//        textView.resignFirstResponder() // Hiding keyboard called for a specific object
    }
    
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
              else { return }
        
        if notification.name
            == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - textViewBottomConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
//        print("Text count: \(text.count)")
//        print("Range length: \(range.length)")
        return textView.text.count + (text.count - range.length) <= 3000
    }
}
