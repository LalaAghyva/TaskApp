//
//  StatsSheetViewController.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import UIKit

final class StatsSheetViewController: UIViewController {
    
    // MARK: - UI
    private let titleLabel = UILabel()
    private let selectedLabel = UILabel()
    private let countsLabel = UILabel()
    private let topCharsLabel = UILabel()
    
    // MARK: - Data
    private let selectedText: String
    private let countsText: String
    private let topCharsText: String
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Init
    init(selectedText: String, countsText: String, topCharsText: String) {
        self.selectedText = selectedText
        self.countsText = countsText
        self.topCharsText = topCharsText
        super.init(nibName: nil, bundle: nil)


        modalPresentationStyle = .pageSheet
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLabels()
        setupLayout()
        bindData()
    }

    // MARK: - Setup
    private func setupLabels() {
        titleLabel.text = "Statistics"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)

        [selectedLabel, countsLabel, topCharsLabel].forEach {
            $0.font = .systemFont(ofSize: 20)
            $0.numberOfLines = 0
            $0.textColor = .label
        }
    }

    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(selectedLabel)
        stackView.addArrangedSubview(countsLabel)
        stackView.addArrangedSubview(topCharsLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Bind
    private func bindData() {
        selectedLabel.text = selectedText
        countsLabel.text = countsText
        topCharsLabel.text = topCharsText
    }
}
