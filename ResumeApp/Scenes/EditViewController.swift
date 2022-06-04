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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = info != nil ? false : true
        setupTextFields()
        updateView(info)

    }
    
    func updateView(_ info: BasicInfo?) {
        guard let info = info else { return }
        firstNameTextField.text = info.firstName
        lastNameTextField.text = info.lastName
        emailTextField.text = info.email
        addressTextField.text = info.address
        phoneTextField.text = info.number
    }
    
    func setupTextFields() {
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func isValuesChanged(info: BasicInfo) -> Bool {
        return firstNameTextField.text != info.firstName
            || lastNameTextField.text != info.lastName
            || emailTextField.text != info.email
            || addressTextField.text != info.address
            || phoneTextField.text != info.number
    }
    
    // MARK: - Actions
    @objc func saveTapped(_ sender: UIButton) {
        let newInfo: BasicInfo = BasicInfo(firstName: firstNameTextField.text ?? "",
                                        lastName: lastNameTextField.text ?? "",
                                        number: phoneTextField.text ?? "",
                                        email: emailTextField.text ?? "",
                                        address: addressTextField.text ?? "",
                                        imageUrl: "")
        
        // TODO:  Add to CoreData and display in ResumeList
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let info = info else {
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = isValuesChanged(info: info)
    }
}
