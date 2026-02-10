//
//  CaoruselHeaderView.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import UIKit

final class CarouselHeaderView: UIView {
    
    // MARK: - Types
    private enum Section {
        case main
    }
    
    // MARK: - Diffable DataSource
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    private var images: [String] = []
    var onPageChanged: ((Int) -> Void)?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray3
        return pageControl
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUpCollectionPageControl()
        setUpDataSource()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    // MARK: - Setup
    func setUpCollectionPageControl() {
        collectionView.delegate = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseId)

        addSubview(collectionView)
        addSubview(pageControl)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            collectionView.heightAnchor.constraint(equalToConstant: 240),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: collectionView
        ) { collectionView, indexPath, imageName in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CarouselCell.reuseId,
                for: indexPath
            ) as? CarouselCell else {
                return UICollectionViewCell()
            }
            
            cell.setImage(named: imageName)
            return cell
        }
    }

    func configure(images: [String], initialIndex: Int) {
        self.images = images
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = max(0, min(initialIndex, images.count - 1))
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: false)

        // initial scroll
        if images.indices.contains(pageControl.currentPage) {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(
                    at: IndexPath(item: self.pageControl.currentPage, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
    }
}

extension CarouselHeaderView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Paging callback
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        pageControl.currentPage = max(0, min(page, images.count - 1))
        onPageChanged?(pageControl.currentPage)
    }
    
    // MARK: - Layout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
    }
}
