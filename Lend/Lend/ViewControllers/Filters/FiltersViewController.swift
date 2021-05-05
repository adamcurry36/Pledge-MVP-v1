//
//  FiltersViewController.swift
//  Lend
//
//  Created by ОК on 22.01.2021.
//

import UIKit

enum FilterType {
    case nearMe, smallOrg, locallyOperated
}

enum FilterSubject {
    case blackOwned, socialImpact, directAid, impactVerified
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var contentView: RoundedViewWithShadow!
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet var subjectButtons: [UIButton]!
    @IBOutlet weak var applayFiltersButton: UIButton!
    
    var onApplyFilters: (([FilterType], [FilterSubject])->Void)?
    var allTypes: [FilterType] = [.nearMe, .smallOrg, .locallyOperated]
    var allSubjects: [FilterSubject] = [.blackOwned, .socialImpact, .directAid, .impactVerified]
    
    var selectedTypes: [FilterType] = []
    var selectedSubjects: [FilterSubject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.cornerRadius = 40
        contentView.shadowOffsetHeight = -3
        contentView.shadowOffsetWidth = 0
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        applayFiltersButton.layer.cornerRadius = 0.5 * applayFiltersButton.bounds.height
        
        (typeButtons + subjectButtons).forEach {
            $0.layer.cornerRadius = 0.5 * $0.bounds.height
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "borderGray")?.cgColor
        }
        updateUI()
    }
    
    func updateUI() {
        for (index, button) in typeButtons.enumerated() {
            let type = allTypes[index]
            if selectedTypes.contains(type) {
                button.backgroundColor = UIColor(named: "redBg")
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(named: "lightGray")
                button.setTitleColor(.black, for: .normal)
            }
        }
        
        for (index, button) in subjectButtons.enumerated() {
            let subject = allSubjects[index]
            if selectedSubjects.contains(subject) {
                button.backgroundColor = UIColor(named: "redBg")
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(named: "lightGray")
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        guard let index = typeButtons.firstIndex(of: sender) else { return }
        
        let type = allTypes[index]
        if let toRemoveIndex = selectedTypes.firstIndex(of: type) {
            selectedTypes.remove(at: toRemoveIndex)
        } else {
            selectedTypes.append(type)
        }
        updateUI()
    }
    
    @IBAction func subjectButtonPressed(_ sender: UIButton) {
        guard let index = subjectButtons.firstIndex(of: sender) else { return }
        
        let subject = allSubjects[index]
        if let toRemoveIndex = selectedSubjects.firstIndex(of: subject) {
            selectedSubjects.remove(at: toRemoveIndex)
        } else {
            selectedSubjects.append(subject)
        }
        updateUI()
    }
    
    @IBAction func applyFiltersButtonPressed(_ sender: Any) {
        onApplyFilters?(selectedTypes, selectedSubjects)
        dismiss(animated: true, completion: nil)
    }
}
