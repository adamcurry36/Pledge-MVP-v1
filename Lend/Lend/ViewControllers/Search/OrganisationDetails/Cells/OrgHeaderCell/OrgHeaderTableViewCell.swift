//
//  OrgHeaderTableViewCell.swift
//  Lend
//
//  Created by ОК on 26.04.2021.
//

import UIKit
import SDWebImage

class OrgHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var pledgedMonthlyLabel: UILabel!
    @IBOutlet weak var monthlyDonorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    @IBOutlet weak var contactsCollectionViewHeight: NSLayoutConstraint!
    
    var organization: OrganisationItem!
    var contacts: [ContactItem] {
        return organization?.contacts ?? []
    }
    var onDonateAction: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        donateButton.layer.cornerRadius = 0.5 * donateButton.bounds.height
        setupCollectionView()
    }
    
    func setupCollectionView() {
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
        contactsCollectionView.register(UINib(nibName: "ContactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContactCollectionViewCell")
    }
    
    func configureWith(data: OrganisationItem) {
        self.organization = data
        nameLabel.text = organization.name
        filterTitleLabel.text = organization.filterName ?? ""
        descriptionLabel.text = organization.desctiptionText
        coverImageView.sd_setImage(with: organization.imageUrl)
        pledgedMonthlyLabel.text = "\(data.monthPledged)"
        monthlyDonorsLabel.text = "\(data.monthDonors)"
        contactsCollectionViewHeight.constant = 0
        
        contactsCollectionViewHeight.constant = data.contacts.isEmpty ? 0 : 60
        contactsCollectionView.reloadData()
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        onDonateAction?()
    }
}

extension OrgHeaderTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath) as! ContactCollectionViewCell
        cell.configureWith(data: contacts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = contacts[indexPath.row].webUrl
        UIApplication.shared.open(url)
    }
}

extension OrgHeaderTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidht: CGFloat = (contactsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.width ?? 0.0
        let cellSpacing: CGFloat = (contactsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let totalCellWidth = Int(cellWidht) * contacts.count
        let totalSpacingWidth = Int(cellSpacing) * (contacts.count - 1)
        let leftInset = (contactsCollectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
