//
//  ProfileViewController.swift
//  Lend
//
//  Created by ОК on 08.06.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileActionView: UIView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var organizationsCountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var orgsCollectionView: UICollectionView!

    var user: LendUser {
        return UserManager.shared.user!
    }
    var organisations: [OrganisationItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.layer.cornerRadius = 0.5 * avatarImageView.bounds.height
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor(named: "graySeparator")!.cgColor
        editProfileActionView.layer.cornerRadius = 0.5 * editProfileActionView.bounds.height
        usernameLabel.text = user.displayName ?? ""
        emailLabel.text = user.email
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupCollectionView() {
        orgsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 220, height: orgsCollectionView.bounds.height)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        orgsCollectionView.setCollectionViewLayout(layout, animated: false)
       
        orgsCollectionView.delegate = self
        orgsCollectionView.dataSource = self
        orgsCollectionView.register(UINib(nibName: "PrevSupportedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PrevSupportedCollectionViewCell")
    }
    
    func updateUI() {
        followersCountLabel.text = "0"
        organizationsCountLabel.text = "\(organisations.count)"
        amountLabel.text = "$\(user.defaultDonateAmount)"
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        //todo:
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return organisations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrevSupportedCollectionViewCell", for: indexPath) as! PrevSupportedCollectionViewCell
        cell.configureWith(data: organisations[indexPath.row])
        return cell
    }
}
