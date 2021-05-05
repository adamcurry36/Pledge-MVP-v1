//
//  CauseDetailsViewController.swift
//  Lend
//
//  Created by ОК on 31.03.2021.
//

import UIKit

class CauseDetailsViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bgConainer: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var pledgedMonthlyLabel: UILabel!
    @IBOutlet weak var monthlyDonorsLabel: UILabel!
    @IBOutlet weak var donateButton2: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var cause: Cause!
    var tableData: [OrganisationItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        bgConainer.layer.cornerRadius = bannerImageView.layer.cornerRadius
        donateButton.layer.cornerRadius = 0.5 * donateButton.bounds.height
        donateButton2.layer.cornerRadius = 0.5 * donateButton2.bounds.height
        bannerImageView.sd_setImage(with: cause.imageUrl)
        stateLabel.text = cause.state.title.uppercased()
        titleLabel.text = cause.name.uppercased()
        descriptionLabel.text = cause.description
        setupTableView()
        updateTableData([])
        loadOrganisations()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrganisationTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganisationTableViewCell")
    }
    
    func updateTableData(_ data: [OrganisationItem]) {
        tableViewHeight.constant = CGFloat(data.count * 100)
        tableData = data
        tableView.reloadData()
    }
    
    func loadOrganisations() {
        tableView.startActivityAnimating()
        
        FirestoreManager.shared.fetchOrganisations(causeId: cause.id) { [weak self] data in
            guard let self = self else { return }
            
            self.tableView.stopActivityAnimating()
            self.updateTableData(data ?? [])
        }
    }
    
    func showDonate() {
        let vc = Coordinator.instantiateDonateCauseVC()
        vc.cause = cause
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showMyBucket() {
        let vc = Coordinator.instantiateMyBucketVC()
        vc.cause = cause
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showOrganisationDetails(_ organisation: OrganisationItem) {
        let storyboard = UIStoryboard(name: "OrganisationDetails", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! OrganisationDetailsViewController
        vc.organization = organisation
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func donateOrganisation(_ organisation: OrganisationItem) {
        if UserManager.shared.shouldSetAmount {
            let vc = Coordinator.instantiateDonateOrganizationVC()
            vc.organization = organisation
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = Coordinator.instantiateMyBucketVC()
            vc.organizations = [organisation]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func shareOrganisation(_ organisation: OrganisationItem) {
        //todo:
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        if UserManager.shared.shouldSetAmount {
            showDonate()
        } else {
            showMyBucket()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func questionButtonPressed(_ sender: Any) {
        let vc = Coordinator.instantiateInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CauseDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganisationTableViewCell", for: indexPath) as! OrganisationTableViewCell
        cell.configureWith(data: tableData[indexPath.row], showMenu: true)
        cell.onMenuAction = { [weak self] in
            guard let self = self else { return }
            guard let index = self.tableView.indexPath(for: cell)?.row else { return }
            
            let organisation = self.tableData[index]
            let items = ["View Profile", "Donate", "Share"]
            self.showActionSheet(items: items, onDismissWithIndex: { index in
                if index == 0 {
                    self.showOrganisationDetails(organisation)
                } else if index == 1 {
                    self.donateOrganisation(organisation)
                } else if index == 2 {
                    self.shareOrganisation(organisation)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showOrganisationDetails(tableData[indexPath.row])
    }
}
