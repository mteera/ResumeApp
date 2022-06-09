//
//  WorkSummaryViewController.swift
//  ResumeApp
//
//  Created by mongkol.teera on 7/6/22.
//

import UIKit

struct SomeData {
    let name: String
}

protocol WorkSummaryProtocol {
    func update(_ workSummaries: [Work])
}

class WorkSummaryViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    var delegate: WorkSummaryProtocol?
    var workSummaries: [Work]? = [] {
        didSet {
            companyNameTextField.text = ""
            durationTextField.text = ""

            self.tableView.reloadData()
            navigationItem.rightBarButtonItem?.isEnabled = workSummaries != nil ? true : false
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Work Summary"
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false

    }
    @IBAction func addWorkSummary(_ sender: Any) {
        let workSummary = Work(context: context)
        workSummary.companyName = companyNameTextField.text
        workSummary.duration = Int16(durationTextField.text!)!
        workSummaries?.append(workSummary)
        
    }
    @objc func saveTapped(_ sender: UIButton) {
        guard let workSummaries = workSummaries else {
            return
            
        }

        delegate?.update(workSummaries)
        navigationController?.dismiss(animated: true)
    }
}

extension WorkSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let workSummary = workSummaries?[indexPath.row] else { return cell }
        cell.textLabel?.text = "\(workSummary.companyName ?? "")"
        cell.detailTextLabel?.text = "\(workSummary.duration) years"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workSummaries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
