//
//  EditObjectivesViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//

import UIKit

protocol EditObjectiveProtocol {
    func update(_ objective: String)
}

class EditObjectivesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var placeholderLabel : UILabel!
    
    var resume: Resume?
    var delegate: EditObjectiveProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.layer.cornerRadius = 5
        placeholderLabel = UILabel()
        placeholderLabel.text = "Share your vision..."
        placeholderLabel.font = .italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let resume = resume, let objective = resume.objective else { return }
        textView.text = objective
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
 
    @objc func saveTapped(_ sender: UIButton) {
        delegate?.update(textView.text)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension EditObjectivesViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        guard let resume = resume, let objective = resume.objective else {
            navigationItem.rightBarButtonItem?.isEnabled = textView.text != "" ? true : false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = textView.text != objective ? true : false

    }
}
