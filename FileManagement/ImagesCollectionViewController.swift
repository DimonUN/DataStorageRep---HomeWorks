//
//  SecondViewController.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 07.07.2022.
//

import UIKit

class ImagesCollectionViewController: UIViewController {

    //MARK: - Properties
    private enum CollectionReuseIdentifiers: String {
        case internalData
    }

    private let defaults = UserDefaults.standard
    private var observer: NSKeyValueObservation?

    private enum Constants {
        static let imageHeight: CGFloat = 50.0
        static let spacing: CGFloat = 8.0
        static let insets: CGFloat = 8.0
    }

    private let fileManager = FileManager.default
    private lazy var arrayOfImagesInString: [String] = ImagesProviger.get()

    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.toAutoLayout()
        return collectionView
    }()

    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        view.addSubviews(collectionView)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionReuseIdentifiers.internalData.rawValue
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

    private func sortedImagesAfterLoadingController() {
        let result = defaults.bool(forKey: "isOn")
        if result == true {
            arrayOfImagesInString = arrayOfImagesInString.sorted { $0 < $1 }
        } else {
            arrayOfImagesInString = arrayOfImagesInString.sorted { $0 > $1 }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sortedImagesAfterLoadingController()
        setupObserverForUserDefaults()
        setupCollectionView()
        setupUI()
        setupConstraints()
    }

    private func setupObserverForUserDefaults() {
        observer = UserDefaults.standard.observe(\.isOn, options: [.new]) { [self] defaults, value in
            switch value.newValue {
            case true:
                arrayOfImagesInString = arrayOfImagesInString.sorted(by: { [weak self] (item1, item2) -> Bool in
                    let result = item1 < item2
                    self?.collectionView.reloadData()
                    return result
                })
            case false:
                arrayOfImagesInString = arrayOfImagesInString.sorted(by: { [weak self] (item1, item2) -> Bool in
                    let result = item1 > item2
                    self?.collectionView.reloadData()
                    return result
                })
            default:
                break
            }
        }
    }
}

    //MARK: - Extensions
extension ImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImagesInString.count
    }

    func tapToDelete(index: Int) {
        arrayOfImagesInString.remove(at: index)
        collectionView.reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionReuseIdentifiers.internalData.rawValue, for: indexPath) as! CollectionViewCell
            let string = arrayOfImagesInString[indexPath.row]
            cell.setup(imageFrom: string)
            cell.deleteImage = { [weak self] in
                self?.tapToDelete(index: indexPath.row)
            }
        return cell
    }
}


extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemInRow: CGFloat = 3
        let totalSpacing: CGFloat = 3 * spacing + (itemInRow - 2) * spacing
        let finalWidth = (width - totalSpacing) / itemInRow
        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = itemWidth(for: view.frame.width, spacing: Constants.spacing)
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.insets, left: Constants.insets, bottom: Constants.insets, right: Constants.insets)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
}

