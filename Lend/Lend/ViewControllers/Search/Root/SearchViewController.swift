//
//  SearchViewController.swift
//  Lend
//
//  Created by ОК on 26.01.2021.
//

import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearSearchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var tapView: UIView = {
        let tapView = UIView()
        tapView.isUserInteractionEnabled = true
        tapView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapView.addGestureRecognizer(tap)
        return tapView
    }()
    
    var filters: [FilterItem] = []
    var selectedFilterIndex: Int?
    var organisations: [OrganisationItem] = []
    var tableData: [OrganisationItem] {
        var sourse = organisations
        if let index = selectedFilterIndex {
            sourse = organisations.filter { $0.fieldId == filters[index].id }
        }
        
        if searchText.isEmpty {
            return sourse
        } else {
            return sourse.filter { $0.name.contains(searchText) }
        }
    }
    
    var searchText: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarView.layer.cornerRadius = 5
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor(named: "graySeparator")?.cgColor
        searchTextField.delegate = self
        clearSearchButton.isHidden = true
        setupCollectionView()
        setupTableView()
        loadOrganisations()
        NotificationCenter.default.addObserver(self, selector: #selector(tabbarCurrentIndexDidChange), name: .tabbarCurrentIndexDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Coordinator.rootTabbar?.setTabbarHidden(false, animated: true)
        if filters.isEmpty {
            loadFilters()
        }
    }
    
    private func loadFilters() {
        FirestoreManager.shared.fetchFilters { filters in
            guard let filters = filters else {
                //todo: show Alert
                return
            }
            
            self.filters = filters
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrganisationTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganisationTableViewCell")
    }
    
    private func updateFiltersCollectionVisibleCells() {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
                let isSelected = selectedFilterIndex == indexPath.row
                cell.configureWith(data: filters[indexPath.row], isSelected: isSelected)
            }
        }
    }
    
    private func loadOrganisations() {
        tableView.startActivityAnimating()
        
        FirestoreManager.shared.fetchOrganisations { organisations, snapshot in
            self.tableView.stopActivityAnimating()
            self.organisations = organisations ?? []
            
            self.tableView.reloadData()
        }
    }
    
    private func showOrganisationDetails(_ organisation: OrganisationItem) {
        let storyboard = UIStoryboard(name: "OrganisationDetails", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! OrganisationDetailsViewController
        vc.organization = organisation
        
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
    
    @IBAction func clearSearchButtonPressed(_ sender: Any) {
        clearSearchButton.isHidden = true
        searchTextField.text = ""
        searchText = ""
    }
    
    @objc func tabbarCurrentIndexDidChange(notification: Notification) {
        if Coordinator.rootTabbar?.selectedIndex == 1 {
            loadOrganisations()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganisationTableViewCell", for: indexPath) as! OrganisationTableViewCell
        cell.configureWith(data: tableData[indexPath.row], showMenu: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showOrganisationDetails(organisations[indexPath.row])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addSubview(tapView)
        tapView.fixToView(tableView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tapView.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            searchText = updatedText
        } else {
            searchText = ""
        }
        clearSearchButton.isHidden = searchText.isEmpty
                 
        return true
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let isSelected = selectedFilterIndex == indexPath.row
        cell.configureWith(data: filters[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedFilterIndex == indexPath.row {
            selectedFilterIndex = nil
        } else {
            selectedFilterIndex = indexPath.row
        }
        
        updateFiltersCollectionVisibleCells()
        tableView.reloadData()
    }
}

