//
//  BrandListViewController.swift
//  ankportal
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

let brandsANKPortalItemCache = NSCache<AnyObject, AnyObject>()

class BrandListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum ControllerStatus {
        case LoadError
        case Loading
        case Loaded
    }
    
    var status: ControllerStatus? {
        didSet {
            switch self.status! {
            case .Loaded:
                UIView.animate(withDuration: 0.5, animations: {
                    self.activityIndicatorView.alpha = 0
                    self.activityIndicatorLabel.alpha = 0
                    self.activityIndicator.alpha = 0
                }) { (flag) in
                    guard self.status! == .Loaded else {
                        return
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicatorLabel.text = ""
                    self.activityIndicatorView.isHidden = true
                    self.activityIndicatorButton.isHidden = true
                }
            case .LoadError:
                self.activityIndicatorView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.activityIndicatorButton.isHidden = false
            case .Loading:
                UIView.animate(withDuration: 0.5, animations: {
                    self.activityIndicatorView.alpha = 1
                    self.activityIndicatorLabel.alpha = 1
                    self.activityIndicator.alpha = 1
                }) { (flag) in
                    guard self.status! == .Loading else {
                        return
                    }
                    self.activityIndicatorView.isHidden = false
                    self.activityIndicator.startAnimating()
                    self.activityIndicatorLabel.text = "Загрузка..."
                    self.activityIndicatorButton.isHidden = true
                }
            }
        }
    }
    
    lazy var activityIndicatorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.ankPurple
        button.setTitle("Повторить", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        return indicator
    }()
    
    lazy var activityIndicatorLabel: UITextView = {
        let label = UITextView()
        label.isScrollEnabled = false
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.isEditable = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var activityIndicatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.ankPurple.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [self.activityIndicator, self.activityIndicatorLabel, self.activityIndicatorButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        return view
    }()
    
    lazy var tableView: UITableView = UITableView()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var searchTextField: UITextField? = { [weak self] in
        var textField: UITextField?
        
        self?.searchController.searchBar.subviews.forEach({ (view) in
            view.subviews.forEach({ (view) in
                if let view = view as? UITextField {
                    textField = view
                }
            })
        })
        
        return textField
    }()
    
    let brandCellId = "cellId"
    
    var data: [ANKPortalItemSelectable] = []
    var dataFiltered: [ANKPortalItemSelectable] = []
    var dataSelected: [ANKPortalItemSelectable] = []
    
    var onDoneCallback: (([ANKPortalItemSelectable]) -> ())?
    
    var dataFilter: ([ANKPortalItemSelectable]) -> [ANKPortalItemSelectable] = { $0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupTableView()
        setupView()
        registerCells()
        setupSearchViewController()
        registerKeyboardObservers()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    func setupController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem?.title = "test"
        title = "Список брендов"
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.separatorStyle = .none
    }
    
    func setupView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
    func registerCells() {
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: brandCellId)
    }
    
    func setupSearchViewController() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.placeholder = "Поиск"
        
        if let bg = searchTextField?.subviews.first {
            bg.backgroundColor = .white
            bg.layer.cornerRadius = 10
            bg.clipsToBounds = true
        }
        
        searchController.searchBar.sizeToFit()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        navigationItem.searchController = searchController
    }
    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    private func adjustingHeight(_ show: Bool, notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let k: CGFloat = show ? 1 : 0
        let changeHeight = (keyboardFrame.height) * k
        let bottomInset = (tabBarController?.tabBar.frame.height ?? 0) * k
        
        tableView.contentInset.bottom = changeHeight - bottomInset
        tableView.scrollIndicatorInsets.bottom = changeHeight - bottomInset
    }
    
    @objc func fetchData() {
        status = .Loading
        ANKPortalCatalogs.brands.getAll {[weak self] (items, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.status = .LoadError
                    self?.activityIndicatorLabel.text = error.localizedDescription
                }
                return
            }
            
            self?.updateData(withFetched: self?.dataFilter(items) ?? items)
        }
    }
    
    func updateData(withFetched fetchedData: [ANKPortalItemSelectable]) {
        let selectedId = dataSelected.map({ return $0.id! })
        data = fetchedData.filter({ (item) -> Bool in
            return !selectedId.contains(item.id!)
        })
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.status = .Loaded
        }
    }
    
    @objc func submit() {
        navigationController?.popViewController(animated: true)
        onDoneCallback?(dataSelected)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSelected.count
        case 1:
            return searchController.isActive ? dataFiltered.count : data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.ankPurple.withAlphaComponent(0.8)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.text = getTitlle(forSection: section)
        label.textAlignment = .center
        label.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        label.isScrollEnabled = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: brandCellId, for: indexPath) as! BrandTableViewCell
        let brand = getBrand(forIndexPath: indexPath)
        cell.configure(forBrand: brand)
        cell.delegate = self
        return cell
    }
    
    private func heightForHeader(inSection section: Int) -> CGFloat {
        return dataSelected.count > 0 ? 50 : 0
    }
    
    private func getTitlle(forSection section: Int) -> String {
        switch section {
        case 0:
            return "Выбранные"
        case 1:
            return searchController.isActive ? "Результаты поиска" : "Список"
        default:
            return ""
        }
    }
    
    private func getBrand(forIndexPath indexPath: IndexPath) -> ANKPortalItemSelectable {
        switch indexPath.section {
        case 0:
            return dataSelected[indexPath.row]
        case 1:
            return searchController.isActive ? dataFiltered[indexPath.row] : data[indexPath.row]
        default:
            return searchController.isActive ? dataFiltered[indexPath.row] : data[indexPath.row]
        }
    }
}

extension BrandListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dataFiltered.removeAll()
        guard let searchText = searchController.searchBar.text else {
            return
        }
        dataFiltered = data.filter({ (brand) -> Bool in
            if let name = brand.name?.lowercased() {
                return name.contains(searchText.lowercased()) && !brand.isSelected
            }
            return false
        })
        tableView.reloadData()
    }
}

extension BrandListTableViewController: BrandTableViewCellDelegate {
    func didSelect(brand: ANKPortalItemSelectable) {
        brand.isSelected = !brand.isSelected
        if (brand.isSelected) {
            select(brand: brand)
        } else {
            deselect(brand: brand)
        }
    }
    
    func select(brand: ANKPortalItemSelectable) {
        guard let index = data.firstIndex(where: { $0.id == brand.id }) else {
            return
        }
        
        let newIndex = dataSelected.count
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        
        dataSelected.append(data.remove(at: index))
        
        if (searchController.isActive) {
            if let indexInFiltered = dataFiltered.firstIndex(where: { $0.id == brand.id }) {
                dataFiltered.remove(at: indexInFiltered)
                let oldIndexPath = IndexPath(row: indexInFiltered, section: 1)
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
                tableView.reloadRows(at: [newIndexPath], with: .fade)
            }
        } else {
            let oldIndexPath = IndexPath(row: index, section: 1)
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        }
    }
    
    func deselect(brand: ANKPortalItemSelectable) {
        guard let index = dataSelected.firstIndex(where: { $0.id == brand.id }) else {
            return
        }
        
        let newIndexPath = IndexPath(row: 0, section: 1)
        let oldIndexPath = IndexPath(row: index, section: 0)
        
        let brand = dataSelected.remove(at: index)
        data.insert(brand, at: 0)
        
        if (searchController.isActive) {
            if let searchText = searchController.searchBar.text?.lowercased() {
                if let name = brand.name {
                    if (name.lowercased().contains(searchText)) {
                        dataFiltered.insert(brand, at: 0)
                        tableView.moveRow(at: oldIndexPath, to: newIndexPath)
                        tableView.reloadRows(at: [newIndexPath], with: .fade)
                        return
                    }
                }
            }
            tableView.deleteRows(at: [oldIndexPath], with: .fade)
        } else {
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        }
    }
    
}
