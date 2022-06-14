//
//  ProjectsViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 14/6/22.
//

import UIKit

protocol ProjectProtocol {
    func update(_ projectList: [Project])
}

class ProjectsViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    var delegate: ProjectProtocol?
    var projectList: [Project]? = [] {
        didSet {
            guard let projectList = projectList else { return }
            navigationItem.rightBarButtonItem?.isEnabled = projectList.count > 0 ? true : false
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamSizeTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var technologyTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
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
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        teamSizeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        projectTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        technologyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        roleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func isValid() -> Bool {
        return nameTextField.text != ""
        && teamSizeTextField.text != ""
        && projectTextField.text != ""
        && technologyTextField.text != ""
        && roleTextField.text != ""
    }

    @IBAction func addProject(_ sender: Any) {
        let project = Project(context: context)
        project.name = nameTextField.text
        project.teamSize = teamSizeTextField.text
        project.summary = projectTextField.text
        project.role = roleTextField.text
        if (projectList?.append(project)) == nil {
            projectList = [project]
        }
        nameTextField.text = ""
        teamSizeTextField.text = ""
        projectTextField.text = ""
        technologyTextField.text = ""
        roleTextField.text = ""
        addButton.isEnabled = isValid()
        self.tableView.reloadData()
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        guard let projectList = projectList else {
            return
        }
        
        delegate?.update(projectList)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        addButton.isEnabled = isValid()
    }
}

extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let project = projectList?[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(project.name ?? "")"
        cell.detailTextLabel?.text = "Team Size: \(project.teamSize!), Summary: \(project.summary!), Role: \(project.role!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

