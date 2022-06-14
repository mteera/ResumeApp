//
//  SkillsViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 13/6/22.
//

import UIKit

protocol SkillsProtocol {
    func update(_ skills: [String])
}

class SkillsViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    var delegate: SkillsProtocol?
    var skills: [String]? = [] {
        didSet {
            guard let skills = skills else { return }
            navigationItem.rightBarButtonItem?.isEnabled = skills.count > 0 ? true : false
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Work Summary"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        setupTextFields()
        addButton.isEnabled = isValid()
        
        
    }
    
    func setupTextFields() {
        skillTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func isValid() -> Bool {
        return skillTextField.text != ""
    }
    
    
    @IBAction func addWorkSummary(_ sender: Any) {
        guard let skill = skillTextField.text else { return }
        if (skills?.append(skill)) == nil {
            skills = [skill]
        }
        skillTextField.text = ""
        addButton.isEnabled = isValid()
        self.tableView.reloadData()
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        guard let skills = skills else {
            return
        }
        
        delegate?.update(skills)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        addButton.isEnabled = isValid()
    }
}

extension SkillsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let skill = skills?[indexPath.row] else { return cell }
        cell.textLabel?.text = skill
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

