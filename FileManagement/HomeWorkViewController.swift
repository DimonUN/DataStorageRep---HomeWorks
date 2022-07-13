//
//  SecondViewController.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 07.07.2022.
//

import UIKit

class HomeWorkViewController: UIViewController {

//MARK: - Properties
    private enum CollectionReuseIdentifiers: String {
        case internalData
    }

    private enum Constants {
        static let imageHeight: CGFloat = 50.0
        static let spacing: CGFloat = 8.0
        static let insets: CGFloat = 8.0
    }

    private let fileManager = FileManager.default
    private lazy var arrayOfImages: [UIImage] = []
    private lazy var contentsOfDocumentsDirectory: [URL]? = []

    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.toAutoLayout()
        return collectionView
    }()


//MARK: - Methods
    private func updateContentsOfDocuments() {
        contentsOfDocumentsDirectory?.removeAll()
        let contents = try? fileManager.contentsOfDirectory(
            at: getDocumentsUrl()!,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        contentsOfDocumentsDirectory = contents
    }

    private func getDocumentsUrl() -> URL? {
        let documentsUrl: URL? = try? fileManager.url(
                for: .documentDirectory,
                in: [.userDomainMask],
                appropriateFor: nil,
                create: false
            )
        return documentsUrl
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(collectionView)
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPhoto)
        )
        updateContentsOfDocuments()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionReuseIdentifiers.internalData.rawValue)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func createPhotoForCollection() {
        let array = ImagesProviger.get()
        let documentsUrl = getDocumentsUrl()
        array.forEach {
            let dataImage = $0.jpegData(compressionQuality: 1.0)
            let imagePath = documentsUrl?.appendingPathComponent(
                dataImage?.description ?? UIImage().description
            )

            fileManager.createFile(
                    atPath: imagePath!.path,
                    contents: dataImage
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createPhotoForCollection()
        setupUI()
        setupCollectionView()
        setupConstraints()
    }

    @objc private func addPhoto(_ sender: UIButton) {
        showImagePickerController()
    }
}

//MARK: - Extensions
extension HomeWorkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsOfDocumentsDirectory?.count ?? 0
    }

    func tapToDelete(url: URL) {
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            print(error)
        }
        updateContentsOfDocuments()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionReuseIdentifiers.internalData.rawValue, for: indexPath) as! CollectionViewCell

        if let array = contentsOfDocumentsDirectory {
            let url = array[indexPath.row]

            do {
                let data = try Data(contentsOf: url)
                cell.setup(data: data)
                cell.deleteImage = { [weak self] in
                    self?.tapToDelete(url: url)
                }
            } catch let error {
                print(error)
            }
        }
        return cell
    }
}


extension HomeWorkViewController: UICollectionViewDelegateFlowLayout {
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


extension HomeWorkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        createFileFromUIImagePickerController(info: info)

        collectionView.reloadData()
        dismiss(animated: true)
    }

    private func createFileFromUIImagePickerController(info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            let documentsUrl = getDocumentsUrl()
            let dataImage = image.jpegData(compressionQuality: 1.0)
            let dataImagePath = documentsUrl?.appendingPathComponent(dataImage?.description ?? "")
            fileManager.createFile(atPath: dataImagePath!.path, contents: dataImage)
            updateContentsOfDocuments()
        }
    }
}
