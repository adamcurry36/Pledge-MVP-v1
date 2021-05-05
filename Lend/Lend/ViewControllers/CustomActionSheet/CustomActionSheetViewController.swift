//
//  CustomActionSheetViewController.swift
//  Lend
//
//  Created by ОК on 03.05.2021.
//

import UIKit

class CustomActionSheetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    
    var items: [String] = [] {
        didSet {
            tableViewHeight?.constant = tableView.rowHeight * CGFloat(items.count)
            tableView?.reloadData()
        }
    }
    
    var onIndexSelected: ((Int?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        tableViewHeight.constant = tableView.rowHeight * CGFloat(items.count)
    }
    
    func setupTableView() {
        tableView.layer.cornerRadius = 22
        cancelButton.layer.cornerRadius = 0.5 * cancelButton.bounds.height
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ActionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionTableViewCell")
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.onIndexSelected?(nil)
        }
    }
}

extension CustomActionSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTableViewCell", for: indexPath) as! ActionTableViewCell
        cell.configureWith(title: items[indexPath.row], hideSeparator: indexPath.row == items.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.onIndexSelected?(indexPath.row)
        }
    }
}

