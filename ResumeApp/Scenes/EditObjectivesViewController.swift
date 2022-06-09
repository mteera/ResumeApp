//
//  EditObjectivesViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//

import UIKit

protocol EditObjectivesProtocol {
    func update(_ objectives: String)
}

class EditObjectivesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var placeholderLabel : UILabel!
    
    var objectives: String? {
        didSet {
            guard let objectives = objectives else {
                return
            }

            textView.text = objectives
        }
    }
    
    var delegate: EditObjectivesProtocol?

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        delegate?.update(textView.text)

    }
}

extension EditObjectivesViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
