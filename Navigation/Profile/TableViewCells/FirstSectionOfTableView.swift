import Foundation
import UIKit

final class FirstSectionOfTableView: UITableViewCell {
    
    private lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.toAutoLayout()
        headerTitleLabel.numberOfLines = 1
        headerTitleLabel.text = "Photos"
        headerTitleLabel.textColor = .black
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return headerTitleLabel
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        arrowImageView.toAutoLayout()
        arrowImageView.tintColor = .black
        return arrowImageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray5
        contentView.addSubviews(headerTitleLabel, arrowImageView)

        NSLayoutConstraint.activate([
            headerTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            headerTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            headerTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: headerTitleLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24.0),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24.0)
        ])
    }
}
