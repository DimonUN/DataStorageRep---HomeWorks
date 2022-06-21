import UIKit

class PhotosViewController: UIViewController {
    private lazy var arrayOfPhotos: [String] = PhotosProvider.get()
    private enum CollectionReuseIdentifiers: String {
            case photos
        }
    
    private enum Constants {
        static let imageHeight: CGFloat = 50.0
        static let spacing: CGFloat = 8.0
        static let insets: CGFloat = 8.0
    }
    
    private var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )

        collectionView.toAutoLayout()
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionReuseIdentifiers.photos.rawValue
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Photo Gallery"
        view.addSubview(collectionView)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionReuseIdentifiers.photos.rawValue,
            for: indexPath
        ) as! PhotosCollectionViewCell

        let data = arrayOfPhotos[indexPath.row]
        cell.setup(name: data)
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 3
        let totalSpacing: CGFloat = 3 * spacing + (itemsInRow - 2) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = itemWidth(for: view.frame.width, spacing: Constants.spacing)
        return CGSize(width: size, height: size)
            
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
            return UIEdgeInsets(
                top: Constants.insets,
                left: Constants.insets,
                bottom: Constants.insets,
                right: Constants.insets
            )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.spacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.insets
    }
}
