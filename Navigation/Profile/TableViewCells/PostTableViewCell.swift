import UIKit

final class PostTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.toAutoLayout()
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private lazy var imagePostImageView: UIImageView = {
        let imagePostImageView = UIImageView()
        imagePostImageView.toAutoLayout()
        imagePostImageView.contentMode = .scaleAspectFit
        imagePostImageView.backgroundColor = .black
        return imagePostImageView
    }()
    
    private lazy var textPostLabel: UILabel = {
        let textPostLabel = UILabel()
        textPostLabel.toAutoLayout()
        textPostLabel.font = .systemFont(ofSize: 14.0)
        textPostLabel.textColor = .systemGray
        textPostLabel.numberOfLines = 0
        return textPostLabel
    }()
    
    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.font = .systemFont(ofSize: 16.0)
        likesLabel.textColor = .black
        likesLabel.toAutoLayout()
        return likesLabel
    }()
    
    private lazy var viewsLabel: UILabel = {
        let viewLabel = UILabel()
        viewLabel.font = .systemFont(ofSize: 16.0)
        viewLabel.textColor = .black
        viewLabel.toAutoLayout()
        return viewLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    fileprivate func setupUI() {
        contentView.addSubviews(
            titleLabel,
            imagePostImageView,
            textPostLabel,
            likesLabel,
            viewsLabel
        )

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: textPostLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textPostLabel.trailingAnchor),
            
            imagePostImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            imagePostImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imagePostImageView.heightAnchor.constraint(equalTo: imagePostImageView.widthAnchor),
            
            textPostLabel.topAnchor.constraint(equalTo: imagePostImageView.bottomAnchor, constant: 16.0),
            textPostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            textPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            
            likesLabel.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor, constant: 16.0),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            likesLabel.leadingAnchor.constraint(equalTo: textPostLabel.leadingAnchor),
            
            viewsLabel.topAnchor.constraint(equalTo: textPostLabel.bottomAnchor, constant: 16.0),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            viewsLabel.trailingAnchor.constraint(equalTo: textPostLabel.trailingAnchor)
        ])
    }
    
    public func update(
        title: String,
        image: String,
        description: String,
        likes: Int,
        views: Int
    ) {
        
        imagePostImageView.image = UIImage(named: image)
        textPostLabel.text = description
        likesLabel.text = "Likes: \(likes)"
        viewsLabel.text = "Views: \(views)"
        titleLabel.text = title
    }
}
