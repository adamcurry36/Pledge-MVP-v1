//
//  FinanceMetricTableViewCell.swift
//  Lend
//
//  Created by ОК on 28.04.2021.
//

import UIKit

class FinanceMetricTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.FinanceMetric) {
        nameLabel.text = data.name
        noteLabel.text = data.note.isEmpty ? "" : "(\(data.note))"
        valueLabel.text = "\(data.value)\(data.unit)"
    }
}
