//
//  TableViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 3/6/22.
//

import UIKit
import CoreData

enum FlowType {
    case create, edit
    
    var navTitle: String {
        switch self {
        case .create:
            return "Build Your Resume"
        case .edit:
            return "Edit"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .create:
            return "Create"
        case .edit:
            return "Update"
        }
    }
}

enum MenuOption {
    case info, objective, workSummary, skills, education, project
    var title: String {
        switch self {
        case .info:
            return "Basic Info"
        case .objective:
            return "Objective"
        case .workSummary:
            return "Work Summary"
        case .skills:
            return "Skills"
        case .education:
            return "Education Details"
        case .project:
            return "Project Details"
        }
    }
    
    var identifier: String {
        switch self {
        case .info:
            return "\(EditBasicInfoViewController.self)"
        case .objective:
            return "\(EditObjectivesViewController.self)"
        case .workSummary:
            return "\(WorkSummaryViewController.self)"
        case .skills:
            return "\(SkillsViewController.self)"
        case .education:
            return "\(EducationViewController.self)"
        case .project:
            return "\(ProjectsViewController.self)"
        }
    }
}


class ResumeManager {
    var resume: Resume!
    static let shared = ResumeManager()
    
    private init() {}
    
    func update(_ resume: Resume) {
        self.resume = resume
    }
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var array: [Work] = []
    @IBOutlet weak var errorHeight: NSLayoutConstraint!
    
    var hasTitle: Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    var flowType: FlowType? {
        didSet {
            guard let flowType = self.flowType else { return }
            self.navigationItem.title = flowType.navTitle
        }
    }
    var resume: Resume?
    var menuOptions: [MenuOption] = [.info,
                                     .objective,
                                     .workSummary,
                                     .skills,
                                     .education,
                                     .project]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        titleTextField.layer.borderColor = UIColor.systemGray4.cgColor
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.cornerRadius = 15
        titleTextField.clipsToBounds = true
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: titleTextField.frame.size.height))
        leftView.backgroundColor = titleTextField.backgroundColor
        titleTextField.leftView = leftView
        titleTextField.leftViewMode = .always
        titleTextField.delegate = self
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        errorHeight.constant = textField.text != "" ? 0 : 20.5

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        
    }
  
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        navigationItem.rightBarButtonItem?.isEnabled = textField.text != "" ? true : false
        errorHeight.constant = 0
        
        guard let resume = resume else { return }
        navigationItem.rightBarButtonItem?.isEnabled = textField.text != resume.title
    }

    
    func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: flowType?.buttonTitle,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveTapped(_:)))
        tableView.register(UINib(nibName: "\(SelectableTableViewCell.self)",
                                 bundle: nil),
                           forCellReuseIdentifier: "\(SelectableTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        titleTextField.addTarget(self,
                                 action: #selector(textFieldEditingChanged(_:)),
                                 for: .editingChanged)
        
        guard let resume = resume else { return }
        titleTextField.text = resume.title
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SelectableTableViewCell.self)", for: indexPath) as? SelectableTableViewCell else { fatalError() }
        
        let menu = menuOptions[indexPath.row]
        cell.titleLabel.text = menu.title
        cell.selectionStyle = .none
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
  
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = menuOptions[indexPath.row]
         
         if resume == nil {
             errorHeight.constant = 20.5
             return
         }
         errorHeight.constant = 0
        switch menuOption {
        case.info:
            routeToInfo(resume, menu: menuOption)
        case .objective:
            routeToObjectives(resume, menu: menuOption)
        case .workSummary:
            routeToWorkSummary(resume, menu: menuOption)
        case .skills:
            routeToSkills(resume, menu: menuOption)
        case . education:
            routeToEducation(resume, menu: menuOption)
        case .project:
            routeToProjects(resume, menu: menuOption)
        }
           }

    @objc func saveTapped(_ sender: UIButton) {
        let resume = Resume(context: context)
        resume.title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sample CV"
        updateResume(resume)
    }
    
    func updateResume(_ resume: Resume) {
        do {
            try context.save()
            self.resume = resume
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationController?.dismiss(animated: true)
        } catch {
            
        }
    }
}


// MARK: - Routing
extension TableViewController {
    
    func routeToInfo(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EditBasicInfoViewController
        vc.title = menu.title
        vc.resume = resume
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToObjectives(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EditObjectivesViewController
        vc.title = menu.title
        vc.resume = resume
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToWorkSummary(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! WorkSummaryViewController
        vc.title = menu.title
        vc.workSummaries = resume?.work?.toArray() ?? nil
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToSkills(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! SkillsViewController
        vc.title = menu.title
        vc.skills = resume?.skills ?? nil
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToEducation(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EducationViewController
        vc.title = menu.title
        vc.educationList = resume?.education?.toArray() ?? nil
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToProjects(_ resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! ProjectsViewController
        vc.title = menu.title
        vc.projectList = resume?.projects?.toArray() ?? nil
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    private func initFromStoryboard(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: - Delegates
extension TableViewController: EditInfoProtocol {
    func update(_ info: Info) {
        guard let resume = resume else { return }
        resume.info = info
        updateResume(resume)
        
    }
}

extension TableViewController: EditObjectiveProtocol {
    func update(_ objective: String) {
        guard let resume = resume else { return }
        resume.objective = objective
        updateResume(resume)
    }
}

extension TableViewController: WorkSummaryProtocol {
    func update(_ workSummaries: [Work]) {
        guard let resume = resume else { return }
        workSummaries.forEach({ work in
            resume.addToWork(work)
        })
        updateResume(resume)
    }
}

extension TableViewController: SkillsProtocol {
    func update(_ skills: [String]) {
        guard let resume = resume else { return }
        resume.skills = skills
        updateResume(resume)
    }
}

extension TableViewController: EducationProtocol {
    func update(_ educationList: [Education]) {
        guard let resume = resume else { return }
        educationList.forEach({ education in
            resume.addToEducation(education)
        })
        updateResume(resume)
    }
}

extension TableViewController: ProjectProtocol {
    func update(_ projectList: [Project]) {
        guard let resume = resume else { return }
        projectList.forEach({ education in
            resume.addToProjects(education)
        })
        updateResume(resume)
    }
 
}
