//
//  OrganisationDetailsViewController.swift
//  Lend
//
//  Created by ОК on 21.01.2021.
//

import UIKit
import SDWebImage

class OrganisationDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToBasketButton: UIButton!
    
    var organization: OrganisationItem!
    var tableData: [Any] = []
    var headerCell: OrgHeaderTableViewCell?
    var onBackAction: (()->Void)?
    
    private let keySectionHeaderScores = "keySectionHeaderScores"
    private let keySectionHeaderPrograms = "keySectionHeaderPrograms"
    private let keySectionHeaderBoardLeaderships = "keySectionHeaderBoardLeaderships"
    private let keySectionHeaderCommunityReviews = "keySectionHeaderCommunityReviews"
    private let keySectionHeaderFPM = "keySectionHeaderFPM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToBasketButton.layer.cornerRadius = 0.5 * addToBasketButton.bounds.height
        setupTableData()
        setupTableView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupTableData() {
        tableData.removeAll()
        tableData.append(organization!)
        if !organization.scores.isEmpty {
            tableData.append(keySectionHeaderScores)
            tableData += organization.scores
        }
        
        if !organization.programs.isEmpty {
            tableData.append(keySectionHeaderPrograms)
            tableData += organization.programs
        }
        if !organization.leaders.isEmpty {
            tableData.append(keySectionHeaderBoardLeaderships)
            tableData += organization.leaders
        }
        if !organization.reviews.isEmpty {
            tableData.append(keySectionHeaderCommunityReviews)
            tableData += organization.reviews
        }
        if !organization.financialMetrics.isEmpty {
            tableData.append(keySectionHeaderFPM)
            tableData.append("FinanceMetricsHeaderTableViewCell")
            tableData += organization.financialMetrics
        }
    }
    
    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrgHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrgHeaderTableViewCell")
        tableView.register(UINib(nibName: "SectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionHeaderTableViewCell")
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreTableViewCell")
        tableView.register(UINib(nibName: "OrgProgramTableViewCell", bundle: nil), forCellReuseIdentifier: "OrgProgramTableViewCell")
        tableView.register(UINib(nibName: "LeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaderTableViewCell")
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        tableView.register(UINib(nibName: "FinanceMetricsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "FinanceMetricsHeaderTableViewCell")
        tableView.register(UINib(nibName: "FinanceMetricTableViewCell", bundle: nil), forCellReuseIdentifier: "FinanceMetricTableViewCell")
    }
    
    func showDonate() {
        let vc = Coordinator.instantiateDonateOrganizationVC()
        vc.organization = organization
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        onBackAction?()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donate() {
        if UserManager.shared.shouldSetAmount {
            showDonate()
        } else {
            let vc = Coordinator.instantiateMyBucketVC()
            vc.organizations = [organization]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addToBasketButtonPressed(_ sender: Any) {
        //todo:
    }
}

extension OrganisationDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let orgItem = tableData[indexPath.row] as? OrganisationItem {
            if let headerCell = headerCell {
                return headerCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrgHeaderTableViewCell", for: indexPath) as! OrgHeaderTableViewCell
            headerCell = cell
            cell.configureWith(data: orgItem)
            cell.onDonateAction = { [weak self] in
                self?.donate()
            }
            return cell
        }
        
        // SCORES
        if tableData[indexPath.row] as? String == keySectionHeaderScores {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell", for: indexPath) as! SectionHeaderTableViewCell
            cell.configureWithTitle("Overal Charity Navigator Scores", bottomOffset: 12)
            return cell
        }
        
        if let scoreItem = tableData[indexPath.row] as? OrganisationItem.Score {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell", for: indexPath) as! ScoreTableViewCell
            cell.configureWith(data: scoreItem)
            return cell
        }
        
        // PROGRAM
        if tableData[indexPath.row] as? String == keySectionHeaderPrograms {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell", for: indexPath) as! SectionHeaderTableViewCell
            cell.configureWithTitle("Notable Programs", topOffset: 32)
            return cell
        }
        
        if let programItem = tableData[indexPath.row] as? OrganisationItem.Program {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrgProgramTableViewCell", for: indexPath) as! OrgProgramTableViewCell
            cell.configureWith(data: programItem)
            return cell
        }
        
        // LEADER
        if tableData[indexPath.row] as? String == keySectionHeaderBoardLeaderships {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell", for: indexPath) as! SectionHeaderTableViewCell
            cell.configureWithTitle("Board Leadership")
            return cell
        }
        
        if let leaderItem = tableData[indexPath.row] as? OrganisationItem.Leader {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderTableViewCell", for: indexPath) as! LeaderTableViewCell
            cell.configureWith(data: leaderItem)
            return cell
        }
        
        // REVIEW
        if tableData[indexPath.row] as? String == keySectionHeaderCommunityReviews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell", for: indexPath) as! SectionHeaderTableViewCell
            cell.configureWithTitle("Community Reviews")
            return cell
        }
        
        if let reviewItem = tableData[indexPath.row] as? OrganisationItem.Review {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            cell.reviewLabel.text = reviewItem.text
            return cell
        }
        
        // FINANCIAL PERFORMANCE METRICS
        if tableData[indexPath.row] as? String == keySectionHeaderFPM {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell", for: indexPath) as! SectionHeaderTableViewCell
            cell.configureWithTitle("Financial Performance Metrics")
            return cell
        }
        
        if tableData[indexPath.row] as? String == "FinanceMetricsHeaderTableViewCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceMetricsHeaderTableViewCell", for: indexPath) as! FinanceMetricsHeaderTableViewCell
            return cell
        }
        
        if let metricItem = tableData[indexPath.row] as? OrganisationItem.FinanceMetric {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceMetricTableViewCell", for: indexPath) as! FinanceMetricTableViewCell
            cell.configureWith(data: metricItem)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension OrganisationDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nc = navigationController else { return true }
        
        if nc.viewControllers.count > 1 {
            onBackAction?()
            return true
        }
       
        return false
    }
}
