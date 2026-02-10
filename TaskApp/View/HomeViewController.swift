//
//  HomeViewController.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    // MARK: - Types
    private enum Section {
        case main
    }
    
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let searchBar = UISearchBar()
    private let searchHeaderContainer = UIView()
    private let carouselHeader = CarouselHeaderView()
    private let fabButton = UIButton()
    
    // MARK: - Diffable DataSource
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
    // MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6

        Task {
            await viewModel.load()
            setupSearchHeader()
            setupTable()
            setUpDataSource()
            setupHeader()
            setupFAB()
            
            applySnapshot()
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeaderLayout()
    }
    
    // MARK: - Setup
    private func setupSearchHeader() {
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        searchHeaderContainer.backgroundColor = UIColor.systemGray6
        searchHeaderContainer.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchHeaderContainer.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: searchHeaderContainer.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: searchHeaderContainer.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: searchHeaderContainer.bottomAnchor, constant: -8)
        ])
    }

    private func setupTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.reuseId)
    }
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(
            tableView: tableView
        ) { tableView, indexPath, item in

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ListItemCell.reuseId,
                for: indexPath
            ) as? ListItemCell else {
                return UITableViewCell()
            }

            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.visibleItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func setupHeader() {
        carouselHeader.configure(
            images: viewModel.carouselImages,
            initialIndex: viewModel.selectedPageIndex
        )
        
        carouselHeader.onPageChanged = { [weak self] index in
            guard let self else { return }
            viewModel.setSelectedPage(index: index)
            self.applySnapshot()
        }

        tableView.tableHeaderView = carouselHeader
    }
    
    private func updateTableHeaderLayout() {
        guard let header = tableView.tableHeaderView as? CarouselHeaderView else { return }
        let width = tableView.bounds.width
        
        let imageHeight: CGFloat = 240
        let padding: CGFloat = 8
        let pageControl: CGFloat = 20
        let height: CGFloat = imageHeight + padding * 2 + pageControl  // 240 image + pageControl + paddings

        header.frame = CGRect(
            x: .zero,
            y: .zero,
            width: width,
            height: height
        )
        
        header.invalidateLayout()
        tableView.tableHeaderView = header
    }

    private func setupFAB() {
        view.addSubview(fabButton)
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Configure Floating Action Button appearance, transform and action
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .systemBlue
        configuration.image = UIImage(systemName: "ellipsis")
        configuration.imagePadding = 0
        fabButton.configuration = configuration
        
        fabButton.layer.shadowColor = UIColor.black.cgColor
        fabButton.layer.shadowOpacity = 0.18
        fabButton.layer.shadowRadius = 10
        fabButton.layer.shadowOffset = CGSize(width: 0, height: 6)

        fabButton.transform = CGAffineTransform(rotationAngle: .pi / 2)

        fabButton.addTarget(self, action: #selector(didTapFAB), for: .touchUpInside)
    }

    @objc private func didTapFAB() {
        let data = viewModel.prepareDataForSheet()
        
        let viewController = StatsSheetViewController(
            selectedText: data.selected,
            countsText: data.counts,
            topCharsText: data.topChars
        )
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 56 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchHeaderContainer
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchText(searchText)
        applySnapshot()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
