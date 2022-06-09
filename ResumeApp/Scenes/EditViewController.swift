//
//  DetailViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 3/6/22.
//

import UIKit


protocol EditInfoProtocol {
    func update(_ info: Info)
}


struct BasicInfo {
    let firstName, lastName, number, email, address, imageUrl: String
}

class EditBasicInfoViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var info: Info?
    var delegate: EditInfoProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        navigationItem.rightBarButtonItem?.isEnabled = info != nil ? false : true
        setupTextFields()
        updateView(info)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let info = Info(context: context)
        info.firstName = firstNameTextField.text ?? ""
        info.lastName = lastNameTextField.text ?? ""
        info.number = phoneTextField.text ?? ""
        info.email = emailTextField.text ?? ""
        info.address = addressTextField.text ?? ""
        info.imageUrl = ""
        delegate?.update(info)
        
    }
    
    func updateView(_ info: Info?) {
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
    
    func isValuesChanged(info: Info) -> Bool {
        return firstNameTextField.text != info.firstName
            || lastNameTextField.text != info.lastName
            || emailTextField.text != info.email
            || addressTextField.text != info.address
            || phoneTextField.text != info.number
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let info = info else {
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = isValuesChanged(info: info)
    }
}


