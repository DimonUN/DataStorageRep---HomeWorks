import UIKit
import FirebaseAuth

class ProfileHeaderView: UIView {

//MARK: - Properties
    private lazy var statusText: String = ""

    var avatarImageViewLeadingAnchor: NSLayoutConstraint?
    var avatarImageViewTopAnchor: NSLayoutConstraint?
    var avatarImageViewWidthAnchor: NSLayoutConstraint?
    var avatarImageViewHeightAnchor: NSLayoutConstraint?

    lazy var avatarContentView: UIView = {
        let avatarContentView = UIView()
        avatarContentView.toAutoLayout()
        avatarContentView.alpha = 0
        avatarContentView.backgroundColor = .black
        return avatarContentView
    }()

     lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView(image: UIImage(named: "cat"))
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.contentsGravity = .resizeAspectFill
        avatarImageView.layer.masksToBounds = true
        avatarImageView.toAutoLayout()
        return avatarImageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.text = "Hipster cat"
        fullNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        fullNameLabel.textColor = .black
        fullNameLabel.toAutoLayout()
        return fullNameLabel
    }()

    var logOutButton: UIButton = {
        let signOutButton = UIButton(type: .system)
        signOutButton.setTitle("Log out", for: .normal)
        signOutButton.toAutoLayout()
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.backgroundColor = .systemBlue

        signOutButton.layer.cornerRadius = 10.0
        signOutButton.layer.cornerRadius = 10
        signOutButton.clipsToBounds = true

        return signOutButton
    }()
    
    private lazy var setStatusButton: UIButton = {
        let setStatusButton = UIButton()
        setStatusButton.setTitle("Show status", for: .normal)
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.layer.cornerRadius = 12.0
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowRadius = 4.0
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.addTarget(
            self,
            action: #selector(buttonPressed),
            for: .touchUpInside
        )
        setStatusButton.toAutoLayout()
        return setStatusButton
    }()

    private lazy var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.backgroundColor = .white
        statusTextField.font = UIFont.systemFont(ofSize: 15)
        statusTextField.placeholder = "Set your status"
       
        statusTextField.keyboardType = UIKeyboardType.default
        statusTextField.returnKeyType = UIReturnKeyType.done
        statusTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        statusTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        statusTextField.textColor = .black
        
        statusTextField.layer.cornerRadius = 12
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.addTarget(self,
                            action: #selector(statusTextChanged),
                            for: .editingChanged)
        statusTextField.toAutoLayout()
        return statusTextField
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Waiting for something"
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .gray
        statusLabel.toAutoLayout()
        return statusLabel
    }()

//MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(fullNameLabel, setStatusButton, statusLabel, statusTextField, avatarContentView, avatarImageView, logOutButton)
        avatarImageView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        avatarImageViewLeadingAnchor = avatarImageView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16
        )
        avatarImageViewLeadingAnchor?.isActive = true

        avatarImageViewTopAnchor = avatarImageView.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor, constant: 16
        )
        avatarImageViewTopAnchor?.isActive = true

        avatarImageViewWidthAnchor = avatarImageView.widthAnchor.constraint(
            equalToConstant: 140
        )
        avatarImageViewWidthAnchor?.isActive = true

        avatarImageViewHeightAnchor = avatarImageView.heightAnchor.constraint(
            equalToConstant: 140
        )
        avatarImageViewHeightAnchor?.isActive = true

        NSLayoutConstraint.activate([
            setStatusButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: setStatusButton.trailingAnchor,
                constant: 16
            ),
            setStatusButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -10
            ),
            setStatusButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            fullNameLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 186
            ),
            fullNameLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 27
            ),
            fullNameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: logOutButton.leadingAnchor,
                constant: -10.0
            ),
            logOutButton.widthAnchor.constraint(
                equalToConstant: 60.0
            ),
            logOutButton.heightAnchor.constraint(
                equalToConstant: 30.0
            ),
            logOutButton.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 27.0
            ),
            logOutButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16.0
            ),
            statusLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 186
            ),
            statusLabel.topAnchor.constraint(
                equalTo: fullNameLabel.bottomAnchor,
                constant: 30
            ),
            statusLabel.heightAnchor.constraint(
                equalToConstant: 15
            ),
            statusTextField.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 186
            ),
            statusTextField.topAnchor.constraint(
                equalTo: statusLabel.bottomAnchor,
                constant: 10
            ),
            statusTextField.heightAnchor.constraint(
                equalToConstant: 40
            ),
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: statusTextField.trailingAnchor,
                constant: 16
            )
        ])
    }

    func setupName(name: String) {
        fullNameLabel.text = name
    }

//MARK: - @objc methods
    @objc private func statusTextChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        statusText = text
    }

    @objc private func buttonPressed(sender: UIButton) {
        statusLabel.text = statusText
        print(statusLabel.text ?? "Unknown text")
    }
}
