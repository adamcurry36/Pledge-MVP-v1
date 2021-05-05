//
//  MyBucketViewController.swift
//  Lend
//
//  Created by ОК on 31.03.2021.
//

import UIKit

class MyBucketViewController: UIViewController {
    
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet var tableFooterView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var keepBrowsingButton: UIButton!
    
    var cause: Cause!
    var isOneTimePaymentMode: Bool = false
    var organizations: [OrganisationItem]?
    var myImpactDonates: [DonateItem]?
    private var donateAmount: Int = 0
    var isCompleteDonation: Bool = false
    var shouldShowTipsPopUpWhenAppear: Bool = false
    
    private var donates: [DonateItem] = []
    private var tableData: [OrganisationWithAmount] = [] {
        didSet {
            tableView.reloadData()
            updateUI()
        }
    }
    private var paymentManager: PaymentManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.layer.cornerRadius = 0.5 * completeButton.bounds.height
        keepBrowsingButton.setUndlinedTitle()
        setupTableView()
        if isOneTimePaymentMode {
            setupOneTimePaymentUI()
        } else {
            setupMonthlyPaymentUI()
        }
        updateUI()
    }
    
    func setupOneTimePaymentUI() {
        regualaryLabel.text = " One Time"
        donateAmount = UserManager.shared.oneTimeDonateAmout
        
        if let completeDonation = UserManager.shared.completeDonation, completeDonation.isOneTimePaymentMode {
            tableData = UserManager.shared.completeDonation?.donatedOrganisations ?? []
        }
        loadData()
    }
    
    func setupMonthlyPaymentUI() {
        regualaryLabel.text = "/monthly"
        donateAmount = (UserManager.shared.tmpDonateAmount ?? UserManager.shared.user?.defaultDonateAmount) ?? 0
        if let myImpactDonates = myImpactDonates {
            tableData = myImpactDonates.map { OrganisationWithAmount(amount: $0.amount, organisation: $0.organisation, donateId: $0.id) }
        } else if let completeDonation = UserManager.shared.completeDonation, !completeDonation.isOneTimePaymentMode {
            tableData = completeDonation.donatedOrganisations
        } else {
            loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldShowTipsPopUpWhenAppear {
            showTipsPopup()
        }
    }
    
    private func loadData() {
        view.startActivityAnimating()
        
        if isOneTimePaymentMode {
            self.loadCauseOrganisations(causeId: self.cause?.id) { [weak self] success in
                self?.loadDataCompletionHandler(success)
            }
        } else {
            loadDonates { [weak self] success in
                guard let self = self else { return }
                guard success else { return self.loadDataCompletionHandler(false) }
                
                self.loadCauseOrganisations(causeId: self.cause?.id) { [weak self] success in
                    self?.loadDataCompletionHandler(success)
                }
            }
        }
    }
    
    private func loadDataCompletionHandler(_ success: Bool) {
        view.stopActivityAnimating()
        
        guard success else {
            self.showNetworkErrorAlert()
            return
        }
        
        var tableDataResult: [OrganisationWithAmount] = []
        var donatesToAdd: [DonateItem] = donates
        
        if let causeOrganizations = organizations {
            for causeOrgItem in causeOrganizations {
                var tableDataResultItem = OrganisationWithAmount(amount: 0, organisation: causeOrgItem)
                if let donateIndex = donatesToAdd.firstIndex(where: { $0.organisation.id == tableDataResultItem.organisation.id }) {
                    tableDataResultItem.amount = donatesToAdd[donateIndex].amount
                    tableDataResultItem.donateId = donatesToAdd[donateIndex].id
                    donatesToAdd.remove(at: donateIndex)
                }
                tableDataResult.append(tableDataResultItem)
            }
        }
        
        if isOneTimePaymentMode {
            if let completeDonatation = UserManager.shared.completeDonation, completeDonatation.isOneTimePaymentMode {
                for cdItem in completeDonatation.donatedOrganisations {
                    if let index = tableDataResult.firstIndex(where: { $0.organisation.id == cdItem.organisation.id }) {
                        tableDataResult[index].amount = cdItem.amount
                    } else {
                        tableDataResult.append(cdItem)
                    }
                }
            } else if tableDataResult.count == 1 {
                tableDataResult[0].amount = donateAmount
            }
        } else {
            for donateItem in donatesToAdd {
                let tableDataResultItem = OrganisationWithAmount(amount: donateItem.amount, organisation: donateItem.organisation, donateId: donateItem.id)
                tableDataResult.append(tableDataResultItem)
            }
            
            if let completeDonatation = UserManager.shared.completeDonation, !completeDonatation.isOneTimePaymentMode {
                for cdItem in completeDonatation.donatedOrganisations {
                    if let index = tableDataResult.firstIndex(where: { $0.organisation.id == cdItem.organisation.id }) {
                        tableDataResult[index].amount = cdItem.amount
                    } else {
                        tableDataResult.append(cdItem)
                    }
                }
            } else if tableDataResult.count == 1 {
                tableDataResult[0].amount = donateAmount
            }
        }
        
        tableData = tableDataResult
        tableView.reloadData()
        updateUI()
    }
    
    private func loadDonates(completion: @escaping (Bool)->Void) {
        FirestoreManager.shared.fetchDonates { [weak self] donates in
            guard let donates = donates else { return completion(false) }
            
            self?.donates = donates
            completion(true)
        }
    }
    
    private func loadCauseOrganisations(causeId: String?, completion: @escaping (Bool)->Void) {
        guard let causeId = causeId else { return completion(true) }
        guard organizations == nil else { return completion(true) }
        
        FirestoreManager.shared.fetchOrganisations(causeId: causeId) { [weak self]  data in
            guard let data = data else { return completion(false) }
            
            self?.organizations = data
            completion(true)
        }
    }
    
    func setupTableView() {
        tableView.tableFooterView = tableFooterView
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyBucketTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBucketTableViewCell")
    }
    
    func updateUI() {
        donateAmountLabel.text = "$\(donateAmount)"
        var totalSum: Int = 0
        tableData.forEach {
            totalSum += $0.amount
        }
        
        currentAmountLabel.text = "$\(totalSum)/\(donateAmount)"
        
        if totalSum == donateAmount {
            completeButton.isUserInteractionEnabled = true
            completeButton.backgroundColor = UIColor(named: "redBg")
        } else {
            completeButton.backgroundColor = UIColor(named: "grayButtonBg")
            completeButton.isUserInteractionEnabled = false
        }
    }
    
    func showDonateConfirmation(tips: Int) {
        let vc = Coordinator.instantiateDonateConfirmationVC()
        vc.donateAmount = donateAmount
        vc.donateItems = tableData
        vc.tipsAmount = tips
        vc.isOneTimeMode = isOneTimePaymentMode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTipsPopup() {
        shouldShowTipsPopUpWhenAppear = true
        let vc = Coordinator.instantiateDonateTipsPopupVC()
        vc.onDonateAction = { [weak self] tips in
            self?.showDonateConfirmation(tips: tips)
        }
        presentOverFullScreen(vc)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        if isOneTimePaymentMode {
            UserManager.shared.completeDonation = BucketModel(donatedOrganisations: tableData, isOneTimePaymentMode: true)
        } else {
            UserManager.shared.completeDonation = BucketModel(donatedOrganisations: tableData, isOneTimePaymentMode: false)
            UserManager.shared.tmpDonateAmount = donateAmount
        }
        
        showTipsPopup()
    }
    
    @IBAction func keepBrowsingButtonPressed(_ sender: Any) {
        if isOneTimePaymentMode {
            UserManager.shared.completeDonation = BucketModel(donatedOrganisations: tableData, isOneTimePaymentMode: true)
        } else {
            UserManager.shared.completeDonation = BucketModel(donatedOrganisations: tableData, isOneTimePaymentMode: false)
            UserManager.shared.tmpDonateAmount = donateAmount
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let vc = Coordinator.instantiateAdjustDonateAmountVC()
        vc.isOneTimePaymentMode = isOneTimePaymentMode
        vc.donateAmount = donateAmount
        vc.onContinueAction = { [weak self] amount in
            guard let self = self else { return }

            self.donateAmount = amount
            for (index, _) in self.tableData.enumerated() {
                self.tableData[index].amount = 0
            }

            self.updateUI()
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyBucketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBucketTableViewCell", for: indexPath) as! MyBucketTableViewCell
        let isLastRow = indexPath.row == tableData.count - 1
        
        var currentAmount: Int = 0
        for item in tableData {
            currentAmount += item.amount
        }
        
        var maxValue = donateAmount - currentAmount
        
        if maxValue < 0 {
            maxValue = 0
        }
        maxValue += tableData[indexPath.row].amount
        
        cell.configureWith(data: tableData[indexPath.row], maxSliderValue: maxValue, isLastRow: isLastRow)
        cell.onSliderActionMoved = { [weak self] value in
            guard let self = self, let index = tableView.indexPath(for: cell)?.row else { return }
            
            self.tableData[index].amount = value
            self.updateUI()
        }
        
        cell.onSliderActionEnded = { [weak self] value in
            self?.tableView.reloadData()
        }
        
        return cell
    }
}
