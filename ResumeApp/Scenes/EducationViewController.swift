//
//  EducationViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 14/6/22.
//

import UIKit

struct ResumeModel {
    var title: String
    var workSummaries: [Work]
    var objective: String
    var skills: [String]
    var info: Info
    var projects: [Project]
    var isPDF: Bool
}

protocol EducationProtocol {
    func update(_ educationList: [Education])
}

class EducationViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    var delegate: EducationProtocol?
    var educationList: [Education]? = [] {
        didSet {
            guard let educationList = educationList else { return }
            navigationItem.rightBarButtonItem?.isEnabled = educationList.count > 0 ? true : false
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var graduationYearTextField: UITextField!
    @IBOutlet weak var gpaTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Education Details"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        setupTextFields()
        addButton.isEnabled = isValid()
        
        
    }
    
    func setupTextFields() {
        institutionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        graduationYearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        gpaTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func isValid() -> Bool {
        return institutionTextField.text != "" && graduationYearTextField.text != "" && gpaTextField.text != ""
    }
    
    
    @IBAction func addWorkSummary(_ sender: Any) {
        let education = Education(context: context)
        education.degree = institutionTextField.text
        education.passYear = Int16(graduationYearTextField.text!)!
        education.gpa = Double(gpaTextField.text!)!
        if (educationList?.append(education)) == nil {
            educationList = [education]
        }
        institutionTextField.text = ""
        graduationYearTextField.text = ""
        gpaTextField.text = ""
        addButton.isEnabled = isValid()
        self.tableView.reloadData()
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        guard let educationList = educationList else {
            return
        }
        
        delegate?.update(educationList)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        addButton.isEnabled = isValid()
    }
}

extension EducationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let education = educationList?[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(education.degree ?? "")"
        cell.detailTextLabel?.text = "Graduated in: \(education.passYear) GPA: \(education.gpa)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

