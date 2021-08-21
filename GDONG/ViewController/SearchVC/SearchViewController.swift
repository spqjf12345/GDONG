//
//  SearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/29.
//

import UIKit
import TagListView

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    
    var searchController: UISearchController!
    var resultsTableController: SearchResultViewController!
    var recentController : RecentSearchViewController!
    

    var categoryList:[Category] = []
    var tagList: [String] = ["배달 음식", "알리 익스프레스", "정규 앨범", "복숭아"]
    /// Data model for the table view.
    var board = [Board]()
    //var user = [Users]()
    var filteredBoard = [Board]()
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var tagCollectionView: TagListView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    
//    let tagView: UIView = {
//        let view = UIView()
//        var label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 50))
//        label.text = "추천 태그"
//        label.font = .boldSystemFont(ofSize: 20)
//        view.addSubview(label)
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.systemGray.cgColor
//        return view
//    }()
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text?.isEmpty == false){
            let searchResult = SearchResultViewController()
            searchResult.searchWord = searchBar.text!
            recentController.searchHistory.append(searchBar.text!)
            recentController.tableView.reloadData()
            UserDefaults.standard.set(recentController.searchHistory, forKey: UserDefaultKey.recentHistory)
            searchBar.text = ""
            self.navigationController?.pushViewController(searchResult, animated: true)
        }
        
    }


    
    //var tagCollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetting()
        collectionViewSetting()
        initSearchController()
        tagCollectionViewSetting()
        

        //-- Dummy --
        self.categoryList = Dummy.shared.categoryList(model: categoryList)



    }
    
    func UISetting(){
        categoryView.layer.borderWidth = 2
        categoryView.layer.borderColor = UIColor.systemGray.cgColor
        categoryView.backgroundColor = .white
        
        recommendView.layer.borderWidth = 2
        recommendView.layer.borderColor = UIColor.systemGray.cgColor
        recommendView.backgroundColor = .white
    }
    
    func collectionViewSetting(){
        categoryCollectionView.register(categoryCollectionViewCell.nib(), forCellWithReuseIdentifier: categoryCollectionViewCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.backgroundColor = .blue
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        categoryCollectionView.collectionViewLayout = flowLayout
        makeLayout(layout: flowLayout)

        categoryCollectionView.backgroundColor = .clear
    }
    
    func tagCollectionViewSetting(){
        
        tagCollectionView.textFont = UIFont.systemFont(ofSize: 16)
        tagCollectionView.cornerRadius = 15
        
        tagCollectionView.textColor = .white
        tagCollectionView.tagBackgroundColor = .darkGray
        tagCollectionView.marginY = 15
        tagCollectionView.marginX = 15
        tagCollectionView.paddingX = 10
        tagCollectionView.paddingY = 10
        tagCollectionView.alignment = .center // possible values are .Left, .Center, and .Right
        tagCollectionView.addTags(tagList)
        tagCollectionView.delegate = self
        
    }

    
    func makeLayout(layout: UICollectionViewFlowLayout){
        layout.itemSize = CGSize(width: (categoryCollectionView.width / 3) - 20, height: (categoryCollectionView.width / 3) - 20)
        layout.scrollDirection = .vertical
        //layout.minimumLineSpacing = 15
        
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

        searchController.searchBar.delegate = self
        //definesPresentationContext = true
    }
    
    func setToSuggestedSearches() {
        if searchController.searchBar.searchTextField.tokens.isEmpty {
            recentController.tableView.delegate = self
            print("is empty")
        }else{
            print("not empty")
        }
    }
    
    //delegate 활용한 여기서 push navi 처리 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let text = recentController.searchHistory[indexPath.row]
        print(text)
        let searchResult = SearchResultViewController()
        searchResult.searchWord = text
        self.navigationController?.pushViewController(searchResult, animated: true)
    }
    

    func auto_layout(){
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//
//        categoryView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(categoryView)
//
//        categoryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
//        categoryView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
//
//        categoryView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
//        print("categoru height == \(categoryCollectionView.height) ==")
//        categoryView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -150).isActive = true

        
//        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        categoryCollectionView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true
//        //categoryCollectionView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true
//        categoryCollectionView.topAnchor.constraint(equalTo: categoryView.topAnchor).isActive = true
//        categoryCollectionView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor).isActive = true
//        categoryCollectionView.widthAnchor.constraint(equalTo: categoryView.widthAnchor, constant: -20).isActive = true
//        categoryCollectionView.heightAnchor.constraint(equalTo: categoryView.heightAnchor, constant: -150).isActive = true
        
        
//        tagView.translatesAutoresizingMaskIntoConstraints = false
//
//        scrollView.addSubview(tagView)
//        tagView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
//        tagView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 10).isActive = true
//        tagView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
//        tagView.heightAnchor.constraint(equalToConstant: 500).isActive = true
//
//        tagView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
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
    
    func presentSearchController(_ searchController: UISearchController) {
        print("presentSearchController")
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults : \(searchController.searchBar.text!)")
        
    }
    
}

extension SearchViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
      
        let searchResultVC = SearchResultViewController()
        searchResultVC.searchWord = title
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
}




