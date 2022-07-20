import UIKit
import RealmSwift


class Credentials: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
}

final class LogInViewController: UIViewController {

    //MARK: -Setting properties
    let realm = try! Realm()
    var items: Results<Credentials>!

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

        loginTextField.placeholder = "Email or phone"
        loginTextField.font = UIFont.systemFont(ofSize: 16.0)
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        loginTextField.keyboardType = UIKeyboardType.default
        loginTextField.returnKeyType = UIReturnKeyType.done
       
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        loginTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        loginTextField.layer.borderColor = UIColor.lightGray.cgColor
        loginTextField.layer.borderWidth = 0.5
        
        loginTextField.backgroundColor = .systemGray6
        loginTextField.textColor = .black
        loginTextField.tintColor = UIColor(named: "ColorSet")
        loginTextField.autocapitalizationType = .none
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
        passwordTextField.delegate = self
        return passwordTextField
    }()

    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.gray, for: .disabled)
        loginButton.isEnabled = false
        loginButton.setBackgroundImage(UIImage(named: "gray_pixel_1"), for: .disabled)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel_1"), for: .normal)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel_2"), for: .focused)
        loginButton.setBackgroundImage(UIImage(named: "blue_pixel_2"), for: .highlighted)
        loginButton.layer.cornerRadius = 10.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.toAutoLayout()
        return loginButton
    }()


    private var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "blue_pixel-1")
        imageView.clipsToBounds = true
        imageView.toAutoLayout()
        return imageView
    }()

    
    //MARK: -Setting methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCredentials()
    }

    private func checkCredentials() {
        items = realm.objects(Credentials.self)
        if items.count != 0 {
            loginTextField.text = items[0].login
            passwordTextField.text = items[0].password
            let profileViewController = ProfileViewController()
            self.navigationController?.pushViewController(
                profileViewController,
                animated: true
            )
        }
    }

    private func setupUI() {
        view.backgroundColor = .red
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        logoContentView.addSubview(logoImageView)
        contentView.addSubviews(logoContentView, textFieldsContentView, loginButton)
        textFieldsContentView.addSubviews(loginTextField, passwordTextField)
        loginButton.addSubview(imageView)
        
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
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200.0),

            imageView.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: loginButton.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor)
        ])
    }

        @objc private func loginButtonTapped(_ sender: UIButton) {
            guard loginTextField.text != nil,
                    passwordTextField.text != nil else { return }

            items = realm.objects(Credentials.self)
            guard items.count != 0 else {
                let credentials = Credentials()
                credentials.login = loginTextField.text!
                credentials.password = passwordTextField.text!

                try! realm.write {
                    realm.add(credentials)
                }
                let alert = UIAlertController(title: nil, message: "Пароль и логин сохранены", preferredStyle: .alert)
                let action = UIAlertAction(
                    title: "Ок",
                    style: .default,
                    handler: { [weak self] _ in
                    let profileViewController = ProfileViewController()
                    self?.navigationController?.pushViewController(profileViewController, animated: true)

                })
                alert.addAction(action)
                present(alert, animated: true)
                return
        }
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
}


extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        items = realm.objects(Credentials.self)
        guard loginTextField.text != nil,
                passwordTextField.text != nil else { return }

        guard passwordTextField.text!.count >= 4 else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
}
