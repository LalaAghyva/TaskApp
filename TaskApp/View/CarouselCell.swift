//
//  CarouselCell.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import UIKit

final class CarouselCell: UICollectionViewCell {
    
    static let reuseId = "CarouselCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Setup
    private func setUpImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    //Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func setImage(named name: String) {
        imageView.image = UIImage(named: name)
    }
}
