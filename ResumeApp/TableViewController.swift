//
//  TableViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 3/6/22.
//

import UIKit

struct MenuOption {
    let title: String
}

class TableViewController: UITableViewController {
    
    var menuOptions: [MenuOption] = [MenuOption(title: "Basic Info"),
                                     MenuOption(title: "Objective"),
                                     MenuOption(title: "Work Summary"),
                                     MenuOption(title: "Skills"),
                                     MenuOption(title: "Education Details"),
                                     MenuOption(title: "Project Details")]
    let editSegueIdentifier = "editSegueIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Build Your Resume"
        tableView.register(UINib(nibName: "SelectableTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditBasicInfoViewController") as! EditBasicInfoViewController
        navigationController?.pushViewController(vc, animated: true)
        
        let menu = menuOptions[indexPath.row]
        vc.title = menu.title

        
    }
   
}
