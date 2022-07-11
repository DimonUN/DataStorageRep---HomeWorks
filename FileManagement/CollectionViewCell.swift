//
//  CollectionViewCell.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 07.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.contentsGravity = .resizeAspect
        imageView.toAutoLayout()
        imageView.layer.contentsGravity = .resizeAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.tintColor = .black
        closeButton.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(processTap), for: .touchUpInside)
        closeButton.toAutoLayout()
        return closeButton
    }()

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: 15.0),
            closeButton.heightAnchor.constraint(equalToConstant: 15.0),
            closeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubviews(imageView, closeButton)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    public var onButtonTaped: (() -> Void)?

    @objc private func processTap(_ sender: UIButton) {
        onButtonTaped?()
    }
}
