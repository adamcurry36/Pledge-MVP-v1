//
//  SettingsViewController.swift
//  Lend
//
//  Created by ОК on 06.03.2021.
//

import UIKit



class SettingsViewController: UIViewController {
    
    @IBOutlet weak var topBarTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var tableData: [String] = []
    private let separatorCell = "_SEPARATOR_"
    private let myAccountCell = "My Account"
    private let howTribeWorksCell = "How Tribe Works"
    private let ourTransparencyCell = "Our Transparency"
    private let suggestionBoxCell = "Suggestion Box :)"

    override func viewDidLoad() {
        super.viewDidLoad()

        topBarTopConstaint.constant = safeAreaInsets.top == 0 ? 0 : 30
        setupTableView()
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor(named: "redBg")!.cgColor
        logoutButton.layer.cornerRadius = 0.5 * logoutButton.bounds.height
    }
    
    func setupTableView() {
        tableData = [myAccountCell, separatorCell, howTribeWorksCell, ourTransparencyCell, separatorCell, suggestionBoxCell]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        tableView.register(UINib(nibName: "SettingsSeparatorTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsSeparatorTableViewCell")
    }
    
    func showMyAccount() {
        let storyboard = UIStoryboard(name: "MyAccount", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MyAccountViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showHowTribeWorks() {
        let storyboard = UIStoryboard(name: "HowTribeWorks", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! HowTribeWorksViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showOurTransparency() {
        let storyboard = UIStoryboard(name: "OurTransparency", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! OurTransparencyViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSuggestionBox() {
        let storyboard = UIStoryboard(name: "SuggestionBox", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SuggestionBoxViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        if let error = FirestoreManager.shared.signOut() {
            showAlert(message: error, type: .error)
        } else {
            UserManager.shared.resetUserData()
            Coordinator.redirectToAuth()
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableData[indexPath.row] == separatorCell {
            return 20
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData[indexPath.row] == separatorCell {
            return tableView.dequeueReusableCell(withIdentifier: "SettingsSeparatorTableViewCell", for: indexPath) as! SettingsSeparatorTableViewCell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.titleLabel.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellTitle = tableData[indexPath.row]
        
        if cellTitle == myAccountCell {
            showMyAccount()
        } else if cellTitle == howTribeWorksCell {
            showHowTribeWorks()
        } else if cellTitle == ourTransparencyCell {
            showOurTransparency()
        } else if cellTitle == suggestionBoxCell {
            showSuggestionBox()
        }
    }
}
