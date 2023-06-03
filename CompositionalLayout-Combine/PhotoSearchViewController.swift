//
//  ViewController.swift
//  CompositionalLayout-Combine
//
//  Created by Brendon Crowe on 6/2/23.
//

import UIKit


class PhotoSearchViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Int>
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    private var searchController: UISearchController!
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Photo Search"
        configureCollectionView()
        configureDataSource()
        configureSearchController()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            // item
            let itemSpacing: CGFloat = 1
            
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing + 1, bottom: itemSpacing, trailing: itemSpacing)
            
            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.30))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing + 1)
            
            // group: leading, trailing, nested
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, repeatingSubitem: leadingItem, count: 2)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, repeatingSubitem: trailingItem, count: 3)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
                fatalError("could not dequeue an ImageCell")
            }
            cell.imageView.image = UIImage(systemName: "photo")
            cell.backgroundColor = .systemYellow
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...30))
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PhotoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
