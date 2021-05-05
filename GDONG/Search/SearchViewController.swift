//
//  SearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/29.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var resultsTableController: SearchResultViewController!
    var recentController : RecentSearchViewController!

    var categoryList:[Category] = []
    static let activitySuffix = "mainRestored"
    /// Data model for the table view.
    var board = [Board]()
    var user = [User]()
    var filteredBoard = [Board]()
    
    private let tableView : UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        var label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 50))
        label.text = "카테고리"
        label.font = .boldSystemFont(ofSize: 20)
        view.addSubview(label)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let bottomMostView: UIView = {
        let view = UIView()
        var label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 50))
        label.text = "지역 주변 인기 글"
        label.font = .boldSystemFont(ofSize: 20)
        view.addSubview(label)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    let notificationCenter:NotificationCenter = NotificationCenter.default
    
      
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text?.isEmpty == false){
            let searchResult = SearchResultViewController()
            searchResult.searchWord = searchBar.text!
            self.navigationController?.pushViewController(searchResult, animated: true)
        }
        
    }


    var categoryCollectionView: UICollectionView!
    
    //var tagCollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        notificationCenter.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        initSearchController()
        let layout = UICollectionViewFlowLayout()
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tagCollectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        tagCollectionview.dataSource = self
//        tagCollectionview.delegate = self
//        tagCollectionview.register(categoryCollectionViewCell.nib(), forCellWithReuseIdentifier: categoryCollectionViewCell.identifier)
        
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.register(categoryCollectionViewCell.nib(), forCellWithReuseIdentifier: categoryCollectionViewCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        makeLayout(layout: layout)

        categoryCollectionView.backgroundColor = .clear

        categoryView.addSubview(categoryCollectionView)

        categoryCollectionView.frame = CGRect(x: 20, y: 80, width: view.width - 40, height: 300)
        
     
        categoryView.addSubview(categoryCollectionView)
        categoryCollectionView.frame = CGRect(x: 10, y: 80, width: view.width - 40, height: 400)
        categoryCollectionView.backgroundColor = .white
        
        view.addSubview(scrollView)
        auto_layout()
       
        //-- Dummy --
        self.categoryList = Dummy.shared.categoryList(model: categoryList)
        self.user = Dummy.shared.oneUser(model: user)

        layout.itemSize = CGSize(width: (categoryCollectionView.width / 3) - 10, height: (categoryCollectionView.width / 3) - 10)


    }
    

    
    
    func makeLayout(layout: UICollectionViewFlowLayout){
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
    }
    

    func initSearchController(){
        
        resultsTableController = SearchResultViewController()
        recentController = RecentSearchViewController()
        searchController = UISearchController(searchResultsController: recentController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("검색어 입력", comment: "")
        searchController.searchBar.returnKeyType = .done

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
     
        searchController.delegate = self

        // Monitor when the search button is tapped, and start/end editing.
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func setToSuggestedSearches() {
        if searchController.searchBar.searchTextField.tokens.isEmpty {
            recentController.tableView.delegate = recentController
        }
    }
    

    func auto_layout(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        categoryView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryView)
        
        categoryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        categoryView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true

        categoryView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        categoryView.heightAnchor.constraint(equalToConstant: 500).isActive = true

        bottomMostView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(bottomMostView)
        bottomMostView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        bottomMostView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 10).isActive = true
        bottomMostView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        bottomMostView.heightAnchor.constraint(equalToConstant: 500).isActive = true

        bottomMostView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        categoryCollectionViewCell.identifier, for: indexPath) as! categoryCollectionViewCell
        cell.configure(with: categoryList[indexPath.row])
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(categoryList[indexPath.row].categoryText)
        let searchResultVC = SearchResultViewController()
        searchResultVC.categoryWord = categoryList[indexPath.row].categoryText
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }

    
}

extension SearchViewController: UISearchControllerDelegate {
    
    // We are being asked to present the search controller, so from the start - show suggested searches.
    func presentSearchController(_ searchController: UISearchController) {
        print("presentSearchController")
        
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "temp"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}




