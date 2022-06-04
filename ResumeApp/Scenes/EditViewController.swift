//
//  DetailViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 3/6/22.
//

import UIKit


struct BasicInfo {
    let firstName, lastName, number, email, address, imageUrl: String
}

class EditBasicInfoViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var info: BasicInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
 
        guard let info = info else { return }
        firstNameTextField.text = info.firstName
        lastNameTextField.text = info.lastName
        emailTextField.text = info.email
        addressTextField.text = info.address
        phoneTextField.text = info.number
    }
}
