//
//  MyImpactsViewController.swift
//  Lend
//
//  Created by ОК on 23.01.2021.
//

import UIKit

class MyImpactsViewController: UIViewController {
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var organisationsCountLabel: UILabel!
    @IBOutlet weak var adjustButton: UIButton!
    @IBOutlet weak var contentShadowView: RoundedViewWithShadow!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmChangeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var completeDonationButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var tableData: [DonateItem] = []
    var tableDataBeforeEdit: [DonateItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //adjustButton.layer.cornerRadius = 0.4 * adjustButton.bounds.height
        contentView.layer.cornerRadius = contentShadowView.cornerRadius
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        editButton.layer.cornerRadius = 0.4 * editButton.bounds.height
        //confirmChangeButton.layer.cornerRadius = 0.5 * confirmChangeButton.bounds.height
        completeDonationButton.layer.cornerRadius = 4
        settingsButton.setUndlinedTitle()
        setupTableView()
        updateUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Coordinator.rootTabbar?.setTabbarHidden(false, animated: true)
        updateUI()
        loadData()
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ImpactTableViewCell", bundle: nil), forCellReuseIdentifier: "ImpactTableViewCell")
    }
    
    func loadData() {
        if tableData.isEmpty {
            contentView.startActivityAnimating()
        }
        
        FirestoreManager.shared.fetchUpdateUser { [weak self] _ in
            guard let self = self else { return }
            
            self.updateUI()
            FirestoreManager.shared.fetchDonates { lends in
                self.contentView.stopActivityAnimating()
                guard let lends = lends else {
                    self.showNetworkErrorAlert()
                    return
                }
                self.tableData = lends
                self.tableView.reloadData()
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        let defaultDonateAmount = UserManager.shared.user?.defaultDonateAmount ?? 0
        totalAmountLabel.text = "$\(defaultDonateAmount)"
        let peopleCount = 0//todo:
        organisationsCountLabel.text = "To \(tableData.count) organizations, alongside \(peopleCount) other people"
        
        if UserManager.shared.completeDonation != nil {
            editButton.isHidden = true
            completeDonationButton.isHidden = false
            
            let amount = UserManager.shared.tmpDonateAmount ?? UserManager.shared.user?.defaultDonateAmount ?? 0
            if amount > 0 {
                completeDonationButton.setTitle("Complete Donation - $\(amount)", for: .normal)
            } else {
                completeDonationButton.setTitle("Complete Donation", for: .normal)
            }
        } else {
            editButton.isHidden = tableData.isEmpty
            completeDonationButton.isHidden = true
        }
    }
    
    func removeDonate(_ donateItem: DonateItem) {
        if let index = tableData.firstIndex(where: { $0.id == donateItem.id }) {
            self.tableData.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.updateUI()
        }
    }
    
    func showEdit(donate: DonateItem) {
        let storyboard = UIStoryboard(name: "EditImpact", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EditImpactViewController
        vc.donateItem = donate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showBacket() {
        let vc = Coordinator.instantiateMyBucketVC()
        vc.myImpactDonates = tableData
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func adjustButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showBacket()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showSettings()
    }
    
    @IBAction func completeDonationButtonPressed(_ sender: Any) {
        guard let _ = UserManager.shared.completeDonation else { return }
        
        let vc = Coordinator.instantiateMyBucketVC()
        vc.isCompleteDonation = true
        if let model = UserManager.shared.completeDonation {
            vc.isOneTimePaymentMode = model.isOneTimePaymentMode
        }
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyImpactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImpactTableViewCell", for: indexPath) as! ImpactTableViewCell
        let donateItem = tableData[indexPath.row]
        cell.configureWith(data: donateItem, maxDonate: 0, isEditing: false)
        cell.onRemoveAction = { [weak self] in
            self?.removeDonate(donateItem)
        }
        cell.onSliderAction = { [weak self] value in
            guard let self = self else { return }
            guard let idp = self.tableView.indexPath(for: cell) else { return }
            
            self.tableData[idp.row].amount = Int(value)
            cell.updateAmountLabel(amount: Int(value))
            self.updateUI()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEdit(donate: tableData[indexPath.row])
    }
}
