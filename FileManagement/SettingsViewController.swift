//
//  SettingsViewController.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 14.07.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - Properties
    private let defaults = UserDefaults.standard
    private var isFirstLoad: Bool?
    private let factory: FactoryProtocol

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(didSwitch), for: .touchUpInside)
        switcher.toAutoLayout()
        return switcher
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let changePasswordButton = UIButton(type: .system)
        changePasswordButton.setTitleColor(.black, for: .normal)
        changePasswordButton.setTitle("Изменить пароль", for: .normal)
        changePasswordButton.layer.borderColor = UIColor.systemGray.cgColor
        changePasswordButton.layer.borderWidth = 1.0
        changePasswordButton.layer.cornerRadius = 20.0
        changePasswordButton.backgroundColor = .systemGray6
        changePasswordButton.addTarget(
            self,
            action: #selector(openLoginViewController),
            for: .touchUpInside
        )
        changePasswordButton.toAutoLayout()
        return changePasswordButton
    }()

    private lazy var switcherLabel: UILabel = {
        let switcherLabel = UILabel()
        switcherLabel.text = "Сортировать"
        switcherLabel.toAutoLayout()
        return switcherLabel
    }()

    private lazy var leftSortingLabel: UILabel = {
        let leftSortingLabel = UILabel()
        leftSortingLabel.text = "от Я до А"
        leftSortingLabel.font = .systemFont(ofSize: 14.0)
        leftSortingLabel.toAutoLayout()
        return leftSortingLabel
    }()

    private lazy var rightSortingLabel: UILabel = {
        let rightSortingLabel = UILabel()
        rightSortingLabel.text = "от А до Я"
        rightSortingLabel.font = .systemFont(ofSize: 14.0)
        rightSortingLabel.toAutoLayout()
        return rightSortingLabel
    }()

    //MARK: - Initializer
    init(factory: FactoryProtocol) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    private func fitstLoadSetup() {
        let isHaveInfoAboutFirstLoad = defaults.bool(forKey: "isHaveInfoAboutFirstLoad")
        if isHaveInfoAboutFirstLoad == false {
            isFirstLoad = true
        } else if isHaveInfoAboutFirstLoad == true {
            isFirstLoad = false
        }
    }

    private func switcherSetup() {
        if isFirstLoad == true {
            switcher.isOn = true
        } else if isFirstLoad == false {
            let savedValue = UserDefaults.standard.bool(forKey: "isOn")
            if savedValue == true {
                switcher.isOn = true
            } else if savedValue == false {
                switcher.isOn = false
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(changePasswordButton, switcher, switcherLabel, leftSortingLabel, rightSortingLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50.0),
            changePasswordButton.widthAnchor.constraint(equalToConstant: 150.0),
            changePasswordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            changePasswordButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250.0),

            switcher.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switcher.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 80.0),

            switcherLabel.centerXAnchor.constraint(equalTo: switcher.centerXAnchor),
            switcherLabel.bottomAnchor.constraint(equalTo: switcher.topAnchor, constant: -20.0),

            leftSortingLabel.heightAnchor.constraint(equalTo: switcher.heightAnchor),
            leftSortingLabel.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -20.0),
            leftSortingLabel.centerYAnchor.constraint(equalTo: switcher.centerYAnchor),

            rightSortingLabel.heightAnchor.constraint(equalTo: switcher.heightAnchor),
            rightSortingLabel.leadingAnchor.constraint(equalTo: switcher.trailingAnchor, constant: 20.0),
            rightSortingLabel.centerYAnchor.constraint(equalTo: switcher.centerYAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fitstLoadSetup()
        switcherSetup()
        setupUI()
        setupConstraints()
    }

    //MARK: - @objc Methods
    @objc private func openLoginViewController(_ sender: UIButton) {
        let loginViewController = factory.createLoginViewController(
            keyChainService: factory.createKeyChainService(),
            model: factory.createCredentials(),
            factory: factory,
            alertService: factory.createAlertService(),
            state: .changePassword
        )
        let navContr = UINavigationController(rootViewController: loginViewController)
        show(navContr, sender: nil)
    }

    @objc private func didSwitch(_ sender: UISwitch) {
        switch switcher.isOn {
        case true:
            isFirstLoad = false
            defaults.set(true, forKey: "isHaveInfoAboutFirstLoad")
            defaults.set(true, forKey: "isOn")
        case false:
            isFirstLoad = false
            defaults.set(true, forKey: "isHaveInfoAboutFirstLoad")
            defaults.set(false, forKey: "isOn")
        }
    }
}

extension UserDefaults {
    @objc dynamic var isOn: Bool {
        return bool(forKey: "isOn")
    }
}
