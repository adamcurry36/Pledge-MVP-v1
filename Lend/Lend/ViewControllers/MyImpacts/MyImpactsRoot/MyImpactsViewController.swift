//
//  MyImpactsViewController.swift
//  Lend
//
//  Created by ОК on 23.01.2021.
//

import UIKit

class MyImpactsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var headerDonateAmountLabel: UILabel!
    @IBOutlet weak var headerActiveCountLabel: UILabel!
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    @IBOutlet weak var supportedCollectionView: UICollectionView!
    @IBOutlet weak var adjustDonationActionView: UIView!
    
    var activeDonates: [DonateItem] = []
    var prevSupported: [OrganisationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustDonationActionView.layer.cornerRadius = 0.5 * adjustDonationActionView.bounds.height
        setupDonationsCollectionView()
        setupPreviousSupportedCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Coordinator.rootTabbar?.setTabbarHidden(false, animated: true)
        updateUI()
        loadData()
    }
    
    private func setupDonationsCollectionView() {
        donationsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: donationsCollectionView.bounds.height)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        donationsCollectionView.setCollectionViewLayout(layout, animated: false)
       
        donationsCollectionView.delegate = self
        donationsCollectionView.dataSource = self
        donationsCollectionView.register(UINib(nibName: "ImactDonationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImactDonationCollectionViewCell")
    }
    
    private func setupPreviousSupportedCollectionView() {
        supportedCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 220, height: supportedCollectionView.bounds.height)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        supportedCollectionView.setCollectionViewLayout(layout, animated: false)
       
        supportedCollectionView.delegate = self
        supportedCollectionView.dataSource = self
        supportedCollectionView.register(UINib(nibName: "PrevSupportedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrevSupportedCollectionViewCell")
    }
    
    func loadData() {        
        FirestoreManager.shared.fetchUpdateUser { [weak self] _ in
            guard let self = self else { return }
            
            self.updateUI()
            FirestoreManager.shared.fetchDonates { [weak self]  lends in
                
                guard let self = self else { return }
                guard let lends = lends else {
                    self.showNetworkErrorAlert()
                    return
                }
                
                self.activeDonates = lends
                self.updateUI()
                self.donationsCollectionView.reloadData()
            }
            
            FirestoreManager.shared.fetchPaymentHistory { [weak self] data in
                guard let self = self else { return }
                
                self.prevSupported = data ?? []
                self.supportedCollectionView.reloadData()
            }
        }
    }
    
    func updateUI() {
        usernameLabel.text = UserManager.shared.user?.displayName ?? ""
        countryLabel.text = ""//todo:6yl
        let defaultDonateAmount = UserManager.shared.user?.defaultDonateAmount ?? 0
        headerDonateAmountLabel.text = "$\(defaultDonateAmount)"
        headerActiveCountLabel.text = "$\(activeDonates.count)"
    }
    
    func showSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showBacket() {
        let vc: MyBucketViewController = Coordinator.instantiateViewController("MyBucket")
        vc.myImpactDonates = activeDonates
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showProfile() {
        let vc: ProfileViewController = Coordinator.instantiateViewController("Profile")
        vc.organisations = activeDonates.map { $0.organisation }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showProfile()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        showSettings()
    }
    
    @IBAction func adjustActiveDonationsButtonPressed(_ sender: Any) {
        showBacket()
    }
}

extension MyImpactsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == donationsCollectionView {
            return activeDonates.count
        }
        
        return prevSupported.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Acitve Donates
        if collectionView == donationsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImactDonationCollectionViewCell", for: indexPath) as! ImactDonationCollectionViewCell
            cell.configureWith(data: activeDonates[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrevSupportedCollectionViewCell", for: indexPath) as! PrevSupportedCollectionViewCell
        cell.configureWith(data: prevSupported[indexPath.row])
        return cell
    }
}
