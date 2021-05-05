//
//  OnboardingViewController.swift
//  Lend
//
//  Created by ОК on 06.01.2021.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: RoundedButtonWithShadow!
    
    var collectionData: [OnboardingModel] = []
    var currentPageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupCollectionView()
        getStartedButton.cornerRadius = getStartedButton.bounds.height
    }
    
    func setupData() {
        var page_1 = OnboardingModel(image: "Onboard 1",
                                     imageInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                     title: "Pledge encourages you to make your donations directly",
                                     firstSubtitle: "Connecting donors and recipients in a single platform makes money transfers more efficient, boosts cause discovery and adds transparency for everyone.",
                                     secondSubtitle: "This means you can focus on doing\nwhat you do best: making an impact.")
        page_1.secondSubtitleInBold = "making an impact."
        
        let page_2 = OnboardingModel(image: "Onboard 2",
                                     imageInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                     title: "And never pay unnecessary fees",
                                     firstSubtitle: "Other platforms take small fees on top of credit card processing (which everyone needs to pay, even us).  While this seems insignificant at first, these small fees add up quickly and limit the funds a recipient can receive.",
                                     secondSubtitle: "With Pledge, we run on tips and nothing more. Period.")
        
        let page_3 = OnboardingModel(image: "Onboard 3",
                                     imageInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20),
                                     title: "While joining a movement bigger than yourself",
                                     firstSubtitle: "Even with a few bucks per month,\nyou can join the efforts of thousands of others and make an impact larger than the sum of its parts.",
                                     secondSubtitle: nil)
        
        collectionData = [page_1, page_2, page_3]
    }

    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.isPagingEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "OnboardingCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCell")
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        Coordinator.onboardingFinished = true
        if FirestoreManager.shared.isAuthorized {
            Coordinator.redirectToRoot()
        } else {
            Coordinator.presentAuth(from: self)
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.configureWith(data: collectionData[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: collectionView.contentOffset.x + (collectionView.frame.width / 2), y: (collectionView.frame.height / 2))
        if let ip = collectionView.indexPathForItem(at: center) {
            currentPageIndex = ip.row
        }
        pageControl.currentPage = currentPageIndex
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
