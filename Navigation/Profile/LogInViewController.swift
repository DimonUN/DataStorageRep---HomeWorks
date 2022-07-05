import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

//MARK: - Initializer
    init(delegate: LogInViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    private var delegate: LogInViewControllerDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.toAutoLayout()
        return contentView
    }()
    
    
    private lazy var logoContentView: UIView = {
        let logoContentView = UIView()
        logoContentView.toAutoLayout()
        return logoContentView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        logoImageView.layer.contents = UIImage(named: "logo")?.cgImage
        logoImageView.layer.contentsGravity = .resizeAspectFill
        logoImageView.layer.masksToBounds = true
        logoImageView.toAutoLayout()
        return logoImageView
    }()

        
    private lazy var textFieldsContentView: UIView = {
        let textFieldsContentView = UIView()
        textFieldsContentView.toAutoLayout()
        textFieldsContentView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldsContentView.layer.borderWidth = 0.5
        textFieldsContentView.layer.cornerRadius = 10.0
        textFieldsContentView.layer.masksToBounds = true
        textFieldsContentView.backgroundColor = .systemGray6
        return textFieldsContentView
    }()
    
    
    private lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.toAutoLayout()

        loginTextField.placeholder = "Email"
        loginTextField.font = UIFont.systemFont(ofSize: 16.0)
        loginTextField.autocorrectionType = .no
        loginTextField.keyboardType = .default
        loginTextField.returnKeyType = .done
       
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        loginTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        loginTextField.layer.borderColor = UIColor.lightGray.cgColor
        loginTextField.layer.borderWidth = 0.5
        
        loginTextField.backgroundColor = .systemGray6
        loginTextField.textColor = .black
        loginTextField.tintColor = UIColor(named: "ColorSet")
        loginTextField.autocapitalizationType = .none
        loginTextField.leftViewMode = .always
        loginTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        loginTextField.delegate = self
        return loginTextField
    }()
    
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.toAutoLayout()
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont.systemFont(ofSize: 16.0)
        
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.textColor = .black
        passwordTextField.tintColor = UIColor(named: "ColorSet")
        passwordTextField.autocapitalizationType = .none
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordTextField.delegate = self
        return passwordTextField
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("Log in", for: .normal)
        loginButton.toAutoLayout()
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.gray, for: .disabled)
        loginButton.isEnabled = false
        loginButton.setBackgroundImage(UIImage(named: "gray_pixel_1"), for: .disabled)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel-1"), for: .normal)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel_2"), for: .focused)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel_2"), for: .highlighted)

        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true

        loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        return loginButton
    }()

    
//MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(self.kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupUI() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(tapGesture))
        logoContentView.addGestureRecognizer(recognizer)

        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        logoContentView.addSubview(logoImageView)
        contentView.addSubviews(logoContentView, textFieldsContentView, loginButton)
        textFieldsContentView.addSubviews(loginTextField, passwordTextField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120.0),
            logoContentView.heightAnchor.constraint(equalToConstant: 100.0),
            logoContentView.widthAnchor.constraint(equalToConstant: 100.0),

            textFieldsContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            textFieldsContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            textFieldsContentView.topAnchor.constraint(equalTo: logoContentView.bottomAnchor, constant: 120.0),
            textFieldsContentView.heightAnchor.constraint(equalToConstant: 100.0),

            loginTextField.leadingAnchor.constraint(equalTo: textFieldsContentView.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: textFieldsContentView.trailingAnchor),
            loginTextField.topAnchor.constraint(equalTo: textFieldsContentView.topAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.leadingAnchor.constraint(equalTo: textFieldsContentView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: textFieldsContentView.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: textFieldsContentView.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.0),

            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            loginButton.topAnchor.constraint(equalTo: textFieldsContentView.bottomAnchor, constant: 16.0),
            loginButton.heightAnchor.constraint(equalToConstant: 50.0),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200.0)
        ])
    }

//MARK: - @objc methods
    @objc private func tapGesture(_ gesture: UITapGestureRecognizer) {
        print("Did catch action")
    }

    @objc private func kbdShow(_ notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = kbdSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }

    @objc private func kbdHide(_ notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc private func loginButtonTouched(sender: UIButton) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        guard let email = loginTextField.text,
              let password = passwordTextField.text,
                !email.isEmpty,
                !password.isEmpty else {
            print("Missing field data")
            return
        }

        delegate?.verification(
            email: email,
            password: password
        ) { result in
            switch result {
            case .success(let data):
                let profileVC = ProfileViewController()
                profileVC.onInput = {
                    return data.user.email ?? ""
                }
                self.navigationController?.pushViewController(profileVC, animated: true)

            case .failure(_):
                let alert = UIAlertController(
                    title: "Пользователя с такими данными нет",
                    message: "Зарегистировать нового пользователя?",
                    preferredStyle:  .alert
                )
                alert.addAction(UIAlertAction(
                        title: "Продолжить",
                        style: .default
                ) { [weak self] _ in
                    self?.delegate?.createUser(email: email, password: password)
                    let profileVC = ProfileViewController()
                    profileVC.onInput = {
                        return email
                    }
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                    })
                alert.addAction(UIAlertAction(
                        title: "Ввести другие данные",
                        style: .cancel
                    ))
                self.present(alert, animated: true)
            }
        }
    }
}

//MARK: - extention
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard loginTextField.text != nil, passwordTextField.text != nil else { return }
        guard passwordTextField.text!.count >= 6 else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
}
