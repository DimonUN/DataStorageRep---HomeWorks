//
//  LoginViewController.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 13.07.2022.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    private let alertService: AlertServiceProtocol
    private let keyChain: KeyChainServiceProtocol
    private var credentials: ModelCredentials
    private let factory: FactoryProtocol
    private var loginViewState: LoginViewState?
    private var temporaryPassword: String?

    enum LoginViewState {
        case haveSavedPassword
        case noSavedPassword
        case reEntryPassword
        case changePassword
        case wrongPassword
    }

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

    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.layer.cornerRadius = 20.0
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.tintColor = UIColor(named: "ColorSet")
        passwordTextField.placeholder = "Введите пароль"
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 5, height: 0)
        )
        passwordTextField.autocorrectionType = .no
        passwordTextField.keyboardType = .default
        passwordTextField.returnKeyType = .done
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.textColor = .black
        passwordTextField.autocapitalizationType = .none
        passwordTextField.delegate = self
        passwordTextField.toAutoLayout()
        return passwordTextField
    }()

    private lazy var verifyButton: UIButton = {
        let verifyButton = UIButton(type: .system)
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.setTitleColor(.gray, for: .disabled)
        verifyButton.setBackgroundImage(UIImage(named: "blue_pixel_1"), for: .normal)
        verifyButton.setBackgroundImage(UIImage(named: "blue_pixel_1"), for: .focused)
        verifyButton.setBackgroundImage(UIImage(named: "blue_pixel_1"), for: .highlighted)
        verifyButton.setBackgroundImage(UIImage(named: "gray_pixel_1"), for: .disabled)
        verifyButton.layer.cornerRadius = 20.0
        verifyButton.isEnabled = false
        verifyButton.clipsToBounds = true
        verifyButton.addTarget(self, action: #selector(enteredPasswordChecking), for: .touchUpInside)
        verifyButton.toAutoLayout()
        return verifyButton
    }()

    //MARK: - Initializer
    init(keyChain: KeyChainServiceProtocol, model: ModelCredentials, factory: FactoryProtocol, alertService: AlertServiceProtocol) {
        self.credentials = model
        self.keyChain = keyChain
        self.factory = factory
        self.alertService = alertService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(keyChain: KeyChainServiceProtocol, model: ModelCredentials, factory: FactoryProtocol, alertService: AlertServiceProtocol, state: LoginViewState?) {
        self.init(keyChain: keyChain, model: model, factory: factory, alertService: alertService)
        self.loginViewState = state
     }

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupAlertService()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - Private Methods
    private func setupAlertService() {
        alertService.setNavigationController(navController: navigationController)
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true

        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(passwordTextField, verifyButton)
        
        if loginViewState == .changePassword {
            toogleUI()
        } else {
            let result = keyChain.checkAvailabilityPassword(
                accountName: credentials.accountName,
                serviceName: credentials.serviceName
            )
            guard result != nil, result != false else {
                loginViewState = .noSavedPassword
                toogleUI()
                return
            }
            loginViewState = .haveSavedPassword
            toogleUI()
        }
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

            passwordTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 400.0),
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56.0),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),

            verifyButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20.0),
            verifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            verifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            verifyButton.heightAnchor.constraint(equalToConstant: 56.0),
            verifyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ])
    }

    private func toogleUI() {
        switch loginViewState {
        case .haveSavedPassword:
            passwordTextField.text = nil
            verifyButton.setTitle("Введите пароль", for: .normal)
            passwordTextField.placeholder = "Введите пароль"
        case .noSavedPassword:
            passwordTextField.text = nil
            verifyButton.setTitle("Создать пароль", for: .normal)
            passwordTextField.placeholder = "Создайте пароль"
        case .reEntryPassword:
            passwordTextField.text = nil
            verifyButton.setTitle("Повторите пароль", for: .normal)
            passwordTextField.placeholder = "Повторите пароль"
        case .changePassword:
            passwordTextField.text = nil
            verifyButton.setTitle("Изменить пароль", for: .normal)
            passwordTextField.placeholder = "Измените пароль"
        case .wrongPassword:
            passwordTextField.text = nil
            verifyButton.setTitle("Введите пароль", for: .normal)
            passwordTextField.placeholder = "Введите пароль"
        default:
            print("Ошибка")
            return
        }
    }

    private func prepareToSave(with credentials: ModelCredentials, secureValue: String?) {
        guard secureValue != nil else { return }
            temporaryPassword = secureValue
    }

    private func checkPasswordToEnter() {
        let result = keyChain.verifyPassword(accountName: credentials.accountName, serviceName: credentials.serviceName, secureValue: passwordTextField.text)
        if result == true {
            loginViewState = .haveSavedPassword
            toogleUI()
            let imageCollectionViewController = factory.createImageCollectionController()
            navigationController?.pushViewController(imageCollectionViewController, animated: true)
        } else if result == false {
            loginViewState = .wrongPassword
            toogleUI()
            alertService.showAlertWithOneAction(
                titleOfAlert: "Ошибка",
                messageOfAllert: "Пароль введен неверно",
                preferredStyle: .alert,
                titleOfAction: "Ввести корректный пароль",
                styleOfAction: .default,
                actionHandler: nil
            )
        }
    }

    private func prepareToSavePassword() {
        let result = keyChain.checkAvailabilityPassword(
            accountName: credentials.accountName,
            serviceName: credentials.serviceName
        )
        guard result == false else {
            print("Some error")
            return
        }
        prepareToSave(with: credentials, secureValue: passwordTextField.text)
        loginViewState = .reEntryPassword
        toogleUI()
    }

    private func checkReEntryPassword() {
        guard passwordTextField.text != nil else { return }
        if temporaryPassword == passwordTextField.text {
            let _ = keyChain.save(
                accountName: credentials.accountName,
                serviceName: credentials.serviceName,
                secureValue: passwordTextField.text
            )
            loginViewState = .haveSavedPassword
            toogleUI()
            alertService.showAlertWithOneAction(
                titleOfAlert: "Отлично",
                messageOfAllert: "Пароль успешно сохранен",
                preferredStyle: .actionSheet,
                titleOfAction: "Далее",
                styleOfAction: .default,
                actionHandler: { [weak self] _ in
                guard let imageCollectionViewController =
                        self?.factory.createImageCollectionController() else { return }
                self?.navigationController?.pushViewController(imageCollectionViewController, animated: true)
            })
        } else {
            loginViewState = .noSavedPassword
            toogleUI()
            temporaryPassword = nil
            alertService.showAlertWithOneAction(
                titleOfAlert: nil,
                messageOfAllert: "Повтор пароля не верный",
                preferredStyle: .alert,
                titleOfAction: "Создать пароль заново",
                styleOfAction: .default,
                actionHandler: nil
            )
        }
    }

    private func changePassword() {
        let result = keyChain.changePassword(
            accountName: credentials.accountName,
            serviceName: credentials.serviceName,
            secureValue: passwordTextField.text
        )
        guard result == true else { return }

        alertService.setNavigationController(navController: navigationController)
        alertService.showAlertWithOneAction(
            titleOfAlert: nil,
            messageOfAllert: "Пароль успешно изменен",
            preferredStyle: .actionSheet,
            titleOfAction: "Ок",
            styleOfAction: .default,
            actionHandler: {[weak self] _ in
                self?.dismiss(animated: true)
            })
    }

    //MARK: - @objc Methods
    @objc private func enteredPasswordChecking(_ sender: UIButton) {
        switch loginViewState {
        case .haveSavedPassword:
            checkPasswordToEnter()
        case .noSavedPassword:
            prepareToSavePassword()
        case .reEntryPassword:
            checkReEntryPassword()
        case .changePassword:
            changePassword()
        case .wrongPassword:
            checkPasswordToEnter()
        default:
            break
        }
    }

    @objc private func showKeyboard(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height + 60
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
        }
    }

    @objc private func hideKeyboard(_ notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

    //MARK: - Extension
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard passwordTextField.text != nil else { return }
        guard passwordTextField.text!.count >= 4 else {
            verifyButton.isEnabled = false
            return
        }
        verifyButton.isEnabled = true
    }
}
