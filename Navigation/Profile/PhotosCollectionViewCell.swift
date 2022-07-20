import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.layer.contentsGravity = .resizeAspectFill
        image.clipsToBounds = true
        return image
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
    }
    
    public func setup(name: String){
        imageView.image = UIImage(named: name)
    }
}
