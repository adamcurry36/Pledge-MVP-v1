//
//  CustomTabbarViewController.swift
//  Lend
//
//  Created by ОК on 16.01.2021.
//

import UIKit

class CustomTabbarViewController: UIViewController {
    
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabbarStackView: UIStackView!
    @IBOutlet weak var tabbarHeightConstraint: NSLayoutConstraint!
    
    lazy var viewControllers: [UIViewController] = {
        return [UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()!,
                UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController()!,
                UIStoryboard(name: "MyImpacts", bundle: nil).instantiateInitialViewController()!]
    }()
    
    var itemTitles = ["Home", "Search", "My Impacts"]
    var inactiveItemIcons = ["home inactive", "search inactive", "user inactive"]
    var activeItemIcons = ["home active", "search active", "user active"]
    var tabbarMaxHeight: CGFloat {
        return safeAreaInsets.bottom == 0 ? 50 : 74
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                setViewControllerAsActive(index: selectedIndex)
                resignViewControllerAsActive(index: oldValue)
                updateUI()
                NotificationCenter.default.post(name: .tabbarCurrentIndexDidChange, object: nil)
            } else {
                if let navigationController = viewControllers[selectedIndex] as? UINavigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    var isTabbarHidden: Bool {
        return tabbarView.alpha == 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerItems()
        updateUI()
        setViewControllerAsActive(index: selectedIndex)
        tabbarHeightConstraint.constant = tabbarMaxHeight
    }
        
    func setupViewControllerItems() {
        for (index, _) in viewControllers.enumerated() {
            let barItemView = BarItemView(frame: .zero)
            barItemView.index = index
            barItemView.activeIcon = UIImage(named: activeItemIcons[index])
            barItemView.inactiveIcon = UIImage(named: inactiveItemIcons[index])
            barItemView.titleLabel.text = itemTitles[index]
            
            barItemView.onSelectedAction = { index in
                self.selectedIndex = index
            }
            tabbarStackView.addArrangedSubview(barItemView)
        }
    }
    
    private func setViewControllerAsActive(index: Int) {
        let viewController = viewControllers[index]
        contentView.addSubview(viewController.view)
        viewController.view.fixToView(contentView)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    private func resignViewControllerAsActive(index: Int) {
        let viewController = viewControllers[index]
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func setTabbarHidden(_ isHidden: Bool, animated: Bool) {
        tabbarHeightConstraint.constant = isHidden ? 0 : tabbarMaxHeight
        tabbarView.alpha = isHidden ? 0 : 1
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func updateUI() {
        for (i, view) in tabbarStackView.subviews.enumerated() {
            guard let barItem = view as? BarItemView else {
                continue
            }
            
            barItem.isSelected = (i == selectedIndex)
        }
    }
}

extension Notification.Name {
    static let tabbarCurrentIndexDidChange = Notification.Name("tabbarCurrentIndexDidChange")
}
