//
//  HomeViewController.swift
//  Lend
//
//  Created by ОК on 20.01.2021.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completeDonationButton: UIButton!
    
    var tableData: [Any] = []
    var filterTypes: [FilterType] = []
    var filterSubjects: [FilterSubject] = []
    var homeHeaderCell: HomeHeaderTableViewCell?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        setupTableView()
        completeDonationButton.layer.cornerRadius = 4
        
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(tabbarCurrentIndexDidChange), name: .tabbarCurrentIndexDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Coordinator.rootTabbar?.setTabbarHidden(false, animated: true)
        updateUI()
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CauseTableViewCell", bundle: nil), forCellReuseIdentifier: "CauseTableViewCell")
        tableView.register(UINib(nibName: HomeHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeHeaderTableViewCell.identifier)
    }
    
    func updateUI() {
        if let displayName = UserManager.shared.user?.displayName, !displayName.isEmpty {
            homeHeaderCell?.welcomeLabel.text = "Welcome, \(displayName)! 👋"
        } else {
            homeHeaderCell?.welcomeLabel.text = "Welcome! 👋"
        }
        
        if let completeDonationModel =  UserManager.shared.completeDonation {
            completeDonationButton.isHidden = false
            
            var amount: Int = 0
            if completeDonationModel.type == .once {
                amount = UserManager.shared.oneTimeDonateAmout
            } else {
                amount = UserManager.shared.tmpDonateAmount ?? UserManager.shared.defaultDonateAmount
            }
            
            if amount > 0 {
                completeDonationButton.setTitle("Complete Donation - $\(amount)", for: .normal)
            } else {
                completeDonationButton.setTitle("Complete Donation", for: .normal)
            }
        } else {
            completeDonationButton.isHidden = true
        }
    }
    
    func loadData() {
        FirestoreManager.shared.fetchUpdateUser { _ in
            self.updateUI()
        }
        
        self.loadCauses()
    }
    
    func loadCauses() {
        tableView.startActivityAnimating()
        FirestoreManager.shared.fetchCauses { [weak self] data in
            guard let self = self else { return }
            
            self.tableView.stopActivityAnimating()
            var result: [Any] = data ?? []
            result.insert(HomeHeaderTableViewCell.identifier, at: 0)
            self.tableData = result
            self.tableView.reloadData()
        }
    }
    
    func showDetails(cause: Cause) {
        let storyboard = UIStoryboard(name: "CauseDetails", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! CauseDetailsViewController
        vc.cause = cause
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func completeDonationButtonPressed(_ sender: Any) {
        guard let completeDonation = UserManager.shared.completeDonation else { return }
        
        let vc = Coordinator.instantiateMyBucketVC()
        vc.isCompleteDonation = true
        vc.isOneTimePaymentMode = completeDonation.type == .once
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabbarCurrentIndexDidChange(notification: Notification) {
        if Coordinator.rootTabbar?.selectedIndex == 0 {
            loadCauses()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let str = tableData[indexPath.row] as? String, str == HomeHeaderTableViewCell.identifier {
            if let cell = homeHeaderCell {
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeHeaderTableViewCell.identifier, for: indexPath) as! HomeHeaderTableViewCell
            return cell
        }
        
        if let cause = tableData[indexPath.row] as? Cause {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CauseTableViewCell", for: indexPath) as! CauseTableViewCell
            cell.configureWith(data: cause)
            cell.onDonateAction = { [weak self] in
                guard let self = self,
                      let idp = tableView.indexPath(for: cell),
                      let cause = self.tableData[idp.row] as? Cause
                else { return }
                self.showDonateCauseFlow(cause)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cause = self.tableData[indexPath.row] as? Cause {
            showDetails(cause: cause)
        }
    }
}

