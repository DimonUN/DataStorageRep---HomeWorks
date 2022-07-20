//
//  AlertService.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 18.07.2022.
//

import Foundation
import UIKit

protocol AlertServiceProtocol {
    func setNavigationController(navController: UINavigationController?)
    func showAlertWithOneAction(titleOfAlert: String?, messageOfAllert: String?, preferredStyle: UIAlertController.Style, titleOfAction: String?, styleOfAction: UIAlertAction.Style, actionHandler: ((UIAlertAction) -> Void)?)
}

class AlertService: AlertServiceProtocol {
    private var navController: UINavigationController?

    func setNavigationController(navController: UINavigationController?) {
        self.navController = navController
    }

    func showAlertWithOneAction(titleOfAlert: String?, messageOfAllert: String?, preferredStyle: UIAlertController.Style, titleOfAction: String?, styleOfAction: UIAlertAction.Style, actionHandler: ((UIAlertAction) -> Void)?) {

        let alertController = UIAlertController(title: titleOfAlert, message: messageOfAllert, preferredStyle: preferredStyle)

        let OkAction = UIAlertAction(title: titleOfAction, style: styleOfAction, handler: actionHandler)

        alertController.addAction(OkAction)
        navController?.present(alertController, animated: true)
    }
}
