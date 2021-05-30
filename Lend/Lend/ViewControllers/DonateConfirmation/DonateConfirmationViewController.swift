//
//  DonateConfirmationViewController.swift
//  Lend
//
//  Created by ОК on 01.05.2021.
//

import UIKit

class DonateConfirmationViewController: UIViewController {
    
    @IBOutlet weak var totalDonationValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableFooter: UIView!
    @IBOutlet weak var completeCheckoutButton: UIButton!
    
    var donateAmount: Int = 0
    var tipsAmount: Int = 0
    var donateItems: [OrganisationWithAmount] = []
    var tableData: [Any] = []
    var isOneTimeMode: Bool = false
    private var paymentManager: PaymentManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        completeCheckoutButton.layer.cornerRadius = 6
        setupTableView()
        totalDonationValueLabel.text = "$\(donateAmount + tipsAmount)"
        
        tableData = donateItems.filter { $0.amount > 0 }
        if tipsAmount > 0 {
            tableData.append(tipsAmount)
        }
        setupTableView()
    }
    
    func setupTableView() {
        tableView.tableFooterView = tableFooter
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrganisationWithAmountCell", bundle: nil), forCellReuseIdentifier: "OrganisationWithAmountCell")
    }
    
    private func addTips(completion: @escaping ()->Void) {
        guard tipsAmount > 0 else { return completion() }
        
        FirestoreManager.shared.addTips(amount: tipsAmount) { _ in
            completion()
        }
    }
    
    private func sendToUpdateDonates() {
        view.startActivityAnimating()

        var queryCount: Int = 0
        var isError: Bool = false
        
        for item in donateItems {
            if let donateId = item.donateId {
                if item.amount > 0  {
                    let data: [String:Any] = [DonateItemKey.amount : item.amount]
                    FirestoreManager.shared.editDonate(id: donateId, data: data) { [weak self] success in
                        guard let self = self else { return }

                        queryCount += 1
                        if !success {
                            isError = true
                        }
                        if queryCount == self.donateItems.count {
                            self.sendToUpdateDonatesHandler(success: !isError)
                        }
                    }
                } else {
                    FirestoreManager.shared.deleteDonate(id: donateId) { [weak self] success in
                        guard let self = self else { return }

                        queryCount += 1
                        if !success {
                            isError = true
                        }
                        if queryCount == self.donateItems.count {
                            self.sendToUpdateDonatesHandler(success: !isError)
                        }
                    }
                }
            } else {
                if item.amount > 0 {
                    FirestoreManager.shared.addDonate(organisationId: item.organisation.id, amount: item.amount) { [weak self] success in
                        guard let self = self else { return }

                        queryCount += 1
                        if !success {
                            isError = true
                        }
                        if queryCount == self.donateItems.count {
                            self.sendToUpdateDonatesHandler(success: !isError)
                        }
                    }
                } else {
                    queryCount += 1
                    if queryCount == self.donateItems.count {
                        self.sendToUpdateDonatesHandler(success: !isError)
                    }
                }
            }
        }
    }
        
    private func sendToUpdateDonatesHandler(success: Bool) {
        let completionBlock = {
            self.view.stopActivityAnimating()

            if !success {
                self.showNetworkErrorAlert()
            } else {
                UserManager.shared.completeDonation = nil
                UserManager.shared.tmpDonateAmount = nil
                self.showDonateResult()
            }
        }

        if !isOneTimeMode, donateAmount != UserManager.shared.defaultDonateAmount {
            FirestoreManager.shared.updateDefaultDonateAmount(donateAmount) { _ in
                completionBlock()
            }
        } else {
            completionBlock()
        }
    }
    
    func showDonateResult() {
        let vc = Coordinator.instantiateDonateSuccessVC()
        vc.donateAmount = donateAmount
        vc.tipsAmount = tipsAmount
        vc.isOneTimeMode = isOneTimeMode
        presentOverFullScreen(vc)
    }
    
    func addOneTimePaymentToFirebase() {
        view.startActivityAnimating()

        var queryCount: Int = 0
        var isError: Bool = false
        let timestamp = Date()
        
        var maxQueryCount = donateItems.count
        if tipsAmount > 0 {
            maxQueryCount += 1
            FirestoreManager.shared.addOneTimeDonate(organisationId: "tips", amount: tipsAmount, date: timestamp) { [weak self] success in
                guard let self = self else { return }
                
                queryCount += 1
                if !success {
                    isError = true
                }
                if queryCount == maxQueryCount {
                    self.sendToUpdateDonatesHandler(success: !isError)
                }
            }
        }
        
        for item in donateItems {
            FirestoreManager.shared.addOneTimeDonate(organisationId: item.organisation.id, amount: item.amount, date: timestamp) { [weak self] success in
                guard let self = self else { return }
                
                queryCount += 1
                if !success {
                    isError = true
                }
                if queryCount == maxQueryCount {
                    self.sendToUpdateDonatesHandler(success: !isError)
                }
            }
        }
    }
    
    @IBAction func completeCheckoutButtonPressed(_ sender: Any) {
        let userDonateAndTips = (UserManager.shared.user?.defaultDonateAmount ?? 0) + (UserManager.shared.user?.tips ?? 0)
        if (donateAmount + tipsAmount) != userDonateAndTips {
            paymentManager = PaymentManager(with: self)

            paymentManager?.pay(to: "Pledge", amount: Float(donateAmount + tipsAmount), isOneTimeMode: isOneTimeMode) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(_):
                    if self.isOneTimeMode {
                        self.addOneTimePaymentToFirebase()
                    } else {
                        self.addTips {
                            self.sendToUpdateDonates()
                        }
                    }
                case .failure:
                    return
                }
            }
        } else {
            sendToUpdateDonates()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DonateConfirmationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganisationWithAmountCell", for: indexPath) as! OrganisationWithAmountCell
        
        if let organisationWithAmount = tableData[indexPath.row] as? OrganisationWithAmount {
            cell.configureWith(data: organisationWithAmount)
        }
        
        if let tipsAmount = tableData[indexPath.row] as? Int {
            cell.imgView.image = UIImage(named: "dollar")
            cell.nameLabel.text = "Additional Tip to Pledge"
            cell.aboutLabel.text = "Helping support Pledge"
            cell.amountLabel.text = "$\(tipsAmount)"
        }
        
        return cell
    }
}
