//
//  SearchViewController.swift
//  GDONG
//
//  Created by JoSoJeong on 2021/04/29.
//

import UIKit

class SearchViewController: UIViewController {
    let searchController = UISearchController()

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
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("SearchViewController")
        initSearchController()
        
        view.addSubview(scrollView)
        //scrollView.addSubview(contentView)
        layout()
    }
    

    func initSearchController(){
        //searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색어 입력"
        //searchController.delegate = self
        //searchController.obscuresBackgroundDuringPresentation = false
        
        
        //ser presentation context
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        //searchController.searchBar.delegate = self
    }
    
    func layout(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryView)
        
        categoryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        categoryView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        
        //scrollView에 의해 크기가 좌지우지되지 않는다.
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

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate{

    func updateSearchResults(for searchController: UISearchController) {
    }

    func filterForSearchTextAndScopeButton(searchText: String){
       
        
    }
}

//extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    
//    
//}

