import UIKit

final class PhotogridCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.layer.cornerRadius = 6.0
        image.layer.contentsGravity = .resizeAspectFill
        image.clipsToBounds = true
        return image
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    public func setup(name: String) {
        imageView.image = UIImage(named: name)
    }
}
