import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

//MARK: - LayoutConstraint
    var avatarContentViewLeadingAnchor: NSLayoutConstraint?
    var avatarContentViewTrailingAnchor: NSLayoutConstraint?
    var avatarContentViewTopAnchor: NSLayoutConstraint?
    var avatarContentViewBottomAnchor: NSLayoutConstraint?

    var avatarImageViewNewWidthAnchor: NSLayoutConstraint?
    var avatarImageViewNewHeightAnchor: NSLayoutConstraint?
    var avatarImageViewCenterXAnchor: NSLayoutConstraint?
    var avatarImageViewCenterYAnchor: NSLayoutConstraint?
    
    
//MARK: - Properties
    private enum CellReuseIdentifiers: String {
        case header
        case photos
        case posts
    }

    var onInput: (() -> String)?
    
    private var recognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        return recognizer
    }()
    
    private var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator()
        return animator
    }()
    
    private lazy var arrayOfPost: [Post] = PostProvider.get()

    private enum NumbersOfCellsInTableView {
        static let zeroSection: Int = 1
        static let firstSection: Int = 1
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.toAutoLayout()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var header: ProfileHeaderView = {
        let header = ProfileHeaderView()
        header.alpha = 0
        return header
    }()

    private lazy var closeLabel: UIButton = {
        let closeLabel = UIButton()
        closeLabel.toAutoLayout()
        closeLabel.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeLabel.tintColor = .systemBackground
        closeLabel.alpha = 0
        closeLabel.addTarget(self, action: #selector(closeAvatarImage), for: .touchUpInside)
        return closeLabel
    }()
    
    
//MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupHeaderTableView()
        setupLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(tableView)
    }

    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.register(FirstSectionOfTableView.self, forCellReuseIdentifier: CellReuseIdentifiers.header.rawValue)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseIdentifiers.photos.rawValue)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseIdentifiers.posts.rawValue)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = 450
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }

    private func setupHeaderTableView() {
        header = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 220))
        header.avatarImageView.addGestureRecognizer(recognizer)
        header.setupName(name: onInput?() ?? "")
        tableView.tableHeaderView = header
        recognizer.addTarget(self, action: #selector(tapGesture(_:)))
        header.logOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        self.view.addSubview(self.closeLabel)

        avatarContentViewLeadingAnchor = self.header.avatarContentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        avatarContentViewTrailingAnchor = self.header.avatarContentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        avatarContentViewTopAnchor = self.header.avatarContentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        avatarContentViewBottomAnchor = self.header.avatarContentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)

        avatarContentViewLeadingAnchor?.isActive = true
        avatarContentViewTrailingAnchor?.isActive = true
        avatarContentViewTopAnchor?.isActive = true
        avatarContentViewBottomAnchor?.isActive = true

        let closeLabelTrailingAnchor = self.closeLabel.trailingAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0)
        let closeLabelTopAnchor = self.closeLabel.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)

        closeLabelTrailingAnchor.isActive = true
        closeLabelTopAnchor.isActive = true
    }



//MARK: - @objc methods
    @objc private func logOutTapped(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
    @objc private func tapGesture(_ gesture: UITapGestureRecognizer) {
        avatarImageViewNewWidthAnchor = header.avatarImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        avatarImageViewNewHeightAnchor = header.avatarImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor)
        avatarImageViewCenterXAnchor = header.avatarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        avatarImageViewCenterYAnchor = header.avatarImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        
        UIView.animateKeyframes(
                withDuration: 0.8,
                delay: 0,
                options: .beginFromCurrentState,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.0,
                        relativeDuration: 0.625) { [weak self] in
                            guard let self = self else { return }
                            self.header.avatarContentView.alpha = 0.5
                            self.header.avatarImageViewLeadingAnchor?.isActive = false
                            self.header.avatarImageViewTopAnchor?.isActive = false
                            self.header.avatarImageViewWidthAnchor?.isActive = false
                            self.header.avatarImageViewHeightAnchor?.isActive = false
                            self.header.avatarImageView.layer.cornerRadius = 0

                            self.avatarImageViewNewWidthAnchor?.isActive = true
                            self.avatarImageViewNewHeightAnchor?.isActive = true
                            self.avatarImageViewCenterXAnchor?.isActive = true
                            self.avatarImageViewCenterYAnchor?.isActive = true

                            self.view.layoutIfNeeded()
                        }
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.625,
                        relativeDuration: 0.375) { [weak self] in
                            guard let self = self else { return }
                            self.closeLabel.alpha = 1
                        }
                })
    }
    
    
    @objc private func closeAvatarImage() {
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        
        UIView.animateKeyframes(
            withDuration: 0.8,
            delay: 0,
            options: .beginFromCurrentState,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.375) { [weak self] in
                        guard let self = self else { return }
                        self.closeLabel.alpha = 0
                    }
                UIView.addKeyframe(
                    withRelativeStartTime: 0.375,
                    relativeDuration: 0.625) { [weak self] in
                        guard let self = self else { return }
                        self.header.avatarContentView.alpha = 0
                        self.avatarImageViewNewWidthAnchor?.isActive = false
                        self.avatarImageViewNewHeightAnchor?.isActive = false
                        self.avatarImageViewCenterXAnchor?.isActive = false
                        self.avatarImageViewCenterYAnchor?.isActive = false
                        
                        self.header.avatarImageViewLeadingAnchor?.isActive = true
                        self.header.avatarImageViewTopAnchor?.isActive = true
                        self.header.avatarImageViewWidthAnchor?.isActive = true
                        self.header.avatarImageViewHeightAnchor?.isActive = true
                        self.header.avatarImageView.layer.cornerRadius = 70
                        self.view.layoutIfNeeded()
                    }
            })
    }
}

//MARK: - Extension UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var n = 0
        switch section {
        case 0:
            n = NumbersOfCellsInTableView.zeroSection
        case 1:
            n = NumbersOfCellsInTableView.firstSection
        default:
            n = arrayOfPost.count
        }
        return n
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.header.rawValue, for: indexPath) as! FirstSectionOfTableView
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.photos.rawValue, for: indexPath) as! PhotosTableViewCell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.posts.rawValue, for: indexPath) as! PostTableViewCell
            
            let data = arrayOfPost[indexPath.row]
            cell.update(title: data.title, image: data.image, description: data.description, likes: data.likes, views: data.views)
            return cell
        }
    }
}


//MARK: - Extension UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard indexPath.section == 0 else {return}
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
}








