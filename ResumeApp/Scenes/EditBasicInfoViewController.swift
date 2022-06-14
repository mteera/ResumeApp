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

protocol EditInfoProtocol {
    func update(_ info: Info)
}

class EditBasicInfoViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var delegate: EditInfoProtocol?
    var resume: Resume?
    private var imageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))

        navigationItem.rightBarButtonItem?.isEnabled = false
        setupTextFields()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
        guard let resume = resume, let info = resume.info, let imageData = info.image else { return }
        firstNameTextField.text = info.firstName
        lastNameTextField.text = info.lastName
        emailTextField.text = info.email
        addressTextField.text = info.address
        phoneTextField.text = info.number
        imageView.image = UIImage(data: imageData)
        self.imageData = imageData
    }


    
    func setupTextFields() { 
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func isValid() -> Bool {
        return firstNameTextField.text != ""
        && lastNameTextField.text != ""
        && emailTextField.text != ""
        && addressTextField.text != ""
        && phoneTextField.text != ""
    }
    
    func isValuesChanged(info: Info) -> Bool {
        return firstNameTextField.text != info.firstName
            || lastNameTextField.text != info.lastName
            || emailTextField.text != info.email
            || addressTextField.text != info.address
            || phoneTextField.text != info.number
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        guard let resume = resume, let info = resume.info else {
            navigationItem.rightBarButtonItem?.isEnabled = isValid()
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = isValuesChanged(info: info) && isValid()
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        let info = Info(context: context)
        info.firstName = firstNameTextField.text ?? ""
        info.lastName = lastNameTextField.text ?? ""
        info.number = phoneTextField.text ?? ""
        info.email = emailTextField.text ?? ""
        info.address = addressTextField.text ?? ""
        info.image = imageData
        delegate?.update(info)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}


extension EditBasicInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image  = tempImage
        imageData = tempImage.pngData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

