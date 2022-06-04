//
//  TableViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 3/6/22.
//

import UIKit


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
            return "\(EditBasicInfoViewController.self)"
        case .skills:
            return "\(EditBasicInfoViewController.self)"
        case .education:
            return "\(EditBasicInfoViewController.self)"
        case .project:
            return "\(EditBasicInfoViewController.self)"
        }
    }
}

class TableViewController: UITableViewController {
    
    var flowType: FlowType? {
        didSet {
            guard let flowType = self.flowType else { return }
            self.navigationItem.title = flowType.navTitle
        }
    }
    var resumeItem: ResumeItem?
    var menuOptions: [MenuOption] = [.info,
                                     .objective,
                                     .workSummary,
                                     .skills,
                                     .education,
                                     .project]
    
    let editSegueIdentifier = "editSegueIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SelectableTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SelectableTableViewCell else { fatalError() }
        
        let menu = menuOptions[indexPath.row]
        cell.titleLabel.text = menu.title
        cell.selectionStyle = .none
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = menuOptions[indexPath.row]

        switch menuOption {
        case.info:
            routeToInfo(resumeItem?.info, menu: menuOption)
        case .objective:
            routeToObjectives(menuOption)
        default: break
        }
        
    }
}

extension TableViewController {
    
    func routeToInfo(_ info: BasicInfo?, menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier) as! EditBasicInfoViewController
        vc.title = menu.title
        vc.info  = info
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToObjectives(_ menu: MenuOption) {
        let vc = initFromStoryboard(identifier: menu.identifier)
        vc.title = menu.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func initFromStoryboard(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: identifier)
    }
}

