//
//  ResumeListViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//

import UIKit

enum Skill {
    case html, css, javascript, php, swift, kotlin, node, sql
}

struct Project {
    let name, teamSize, summary, role: String
    let technologies: [Skill]
}

struct Education {
    let degree, passYear, gpa: String
}

struct ResumeItem {
    let title: String
    let info: BasicInfo
    let objectives: String
    let skills: [Skill]
    let educations: [Education]
    let projects: [Project]
}

class ResumeListViewController: UITableViewController {
    
    let array: [ResumeItem] = [
        ResumeItem(
            title: "iOS CV",
            info: BasicInfo(
                            firstName: "Chace",
                            lastName: "Teera",
                            number: "0641792141",
                            email: "chace.teera@hotmail.co.uk",
                            address: "93 Sukhumvit Rd, Bang Chak, Phra Khanong, Bangkok, 10260", imageUrl: ""),
            objectives: "",
            skills: [.html, .css, .javascript, .swift],
            educations: [Education(degree: "BA Digital Media Design", passYear: "2017", gpa: "3.7")],
            projects: [Project(name: "KTB Next", teamSize: "200", summary: "", role: "iOS Developer",
                               technologies: [.swift])]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Resumes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(addResumeTapped(_:)))
    }
    
    // MARK: - Table view data source
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = array[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        vc.flowType = .edit
        vc.resumeItem = array[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Actions
    @objc func addResumeTapped(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        vc.flowType = .create
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
