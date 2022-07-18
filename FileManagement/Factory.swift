//
//  Factory.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 15.07.2022.
//

import Foundation
import UIKit

protocol FactoryProtocol {
    func createCredentials() -> ModelCredentials
    func createKeyChainService() -> KeyChainServiceProtocol
    func createAlertService() -> AlertServiceProtocol

    func createImageCollectionController() -> ImagesCollectionViewController

    func createLoginViewController(
        keyChainService: KeyChainServiceProtocol,
        model: ModelCredentials,
        factory: FactoryProtocol,
        alertService: AlertServiceProtocol,
        state: LoginViewController.LoginViewState?
    ) -> LoginViewController
}

class Factory: FactoryProtocol {
    func createKeyChainService() -> KeyChainServiceProtocol {
        let keyChain = KeyChainService()
        return keyChain
    }

    func createAlertService() -> AlertServiceProtocol {
        let alertService = AlertService()
        return alertService
    }

    func createCredentials() -> ModelCredentials {
        let credentials = ModelCredentials()
        return credentials
    }

    func createLoginViewController(
        keyChainService: KeyChainServiceProtocol,
        model: ModelCredentials,
        factory: FactoryProtocol,
        alertService: AlertServiceProtocol,
        state: LoginViewController.LoginViewState?
    ) -> LoginViewController {

        let loginViewController = LoginViewController(keyChain: keyChainService, model: model, factory: factory, alertService: alertService, state: state)
        loginViewController.tabBarItem = UITabBarItem(
            title: "Collection",
            image: UIImage(systemName: "table.fill"),
            tag: 0
        )
        return loginViewController
    }

    func createImageCollectionController() -> ImagesCollectionViewController {
        let imageCollectionViewController = ImagesCollectionViewController()
        return imageCollectionViewController
    }

    func createSettingViewController(
        factory: FactoryProtocol
    ) -> SettingsViewController {
        let settingsViewController = SettingsViewController(factory: factory)
        settingsViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        return settingsViewController
    }

    func createMainNavigationController(viewConroller: UIViewController) -> UINavigationController {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemGray6

        let mainNavigationController = UINavigationController(rootViewController: viewConroller)
        mainNavigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
        return mainNavigationController
    }

    func createSettingsNavigationController(viewConroller: UIViewController) -> UINavigationController {

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemGray6

        let settingsNavigationController = UINavigationController(rootViewController: viewConroller)
        settingsNavigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
        return settingsNavigationController
    }

    func createTabBarController(_ navControllers: UINavigationController...) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.setViewControllers(navControllers, animated: false)
        return tabBarController
    }

    func createFactoryForViewController() -> FactoryProtocol {
        return self
    }
}
