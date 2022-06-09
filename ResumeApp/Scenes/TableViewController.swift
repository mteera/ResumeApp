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
            return "\(EditBasicInfoViewController.self)"
        case .education:
            return "\(EditBasicInfoViewController.self)"
        case .project:
            return "\(EditBasicInfoViewController.self)"
        }
    }
}


class MenuOptionPresenter {
    private var view: MenuOptionsView?
    
    init() { }
    
    func attachView(view: MenuOptionsView) {
        self.view = view
    }
    
    func detachview() {
        view = nil
    }
  
}


class ResumeManager {
    
    static let shared = ResumeManager()
    
    init() {}
    
    func storeResume(_ newResume: Resume, context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            
        }
    }
}

protocol MenuOptionsView {
    func newResume(_ resume: Resume)
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var array: [Work] = []
    
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
    
    private var presenter = MenuOptionPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        guard let title = resume?.title else { return }
                    titleTextField.text = title
        navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    
    func setup() {
        self.presenter.attachView(view: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: flowType == .create ? "Create" : "Update", style: .done, target: self, action: #selector(saveTapped(_:)))
        tableView.register(UINib(nibName: "SelectableTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SelectableTableViewCell else { fatalError() }
        
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

        switch menuOption {
        case.info:
            routeToInfo(resume: resume, menu: menuOption)
        case .objective:
            routeToObjectives(resume: resume, menu: menuOption)
        case .workSummary:
            routeToWorkSummary(resume: resume, menu: menuOption)
        default: break
        }
        
    }

    @objc func saveTapped(_ sender: UIButton) {
        guard let resume = self.resume else {
            let resume = Resume(context: context)
            resume.title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sample CV"
            ResumeManager.shared.storeResume(resume, context: context)
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationController?.dismiss(animated: true)

            return
            
        }
        resume.title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Untitled"
        ResumeManager.shared.storeResume(resume, context: context)
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.dismiss(animated: true)

    }
}

extension TableViewController {
    
    func routeToInfo(resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EditBasicInfoViewController
        vc.title = menu.title
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToObjectives(resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EditObjectivesViewController
        vc.title = menu.title
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToWorkSummary(resume: Resume?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! WorkSummaryViewController
        vc.title = menu.title
        
        if let resume = resume, let work = resume.work {
            let array: [Work] = work.toArray()
            vc.workSummaries = array

        }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func initFromStoryboard(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: identifier)
    }
}

extension TableViewController: MenuOptionsView {
    func newResume(_ resume: Resume) {
 
    }
}

extension TableViewController: EditInfoProtocol {
    func update(_ info: Info) {
        let resume = Resume(context: context)
        resume.info = info
//        ResumeManager.shared.storeResume(resume, context: context)
    }
}

extension TableViewController: EditObjectivesProtocol {
    func update(_ objectives: String) {
        let resume = Resume(context: context)
        resume.objective = objectives
//        ResumeManager.shared.storeResume(resume)
    }
}


extension TableViewController: WorkSummaryProtocol {
    func update(_ workSummaries: [Work]) {
        guard let resume = self.resume else {
            let resume = Resume(context: context)
            workSummaries.forEach({ work in
                resume.addToWork(work)
            })
            ResumeManager.shared.storeResume(resume, context: context)
            return
        }
        workSummaries.forEach({ work in
            resume.addToWork(work)
        })
        ResumeManager.shared.storeResume(resume, context: context)

    }
}
