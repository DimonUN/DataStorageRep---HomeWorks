//
//  KeyChainService.swift
//  FileManagement
//
//  Created by Дмитрий Никоноров on 15.07.2022.
//

import Foundation
import UIKit

protocol KeyChainServiceProtocol {
    func checkAvailabilityPassword(
        accountName: String,
        serviceName: String
    ) -> Bool?

    func verifyPassword(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool?

    func save(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool?

    func changePassword(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool?
}

class KeyChainService: KeyChainServiceProtocol {
    func checkAvailabilityPassword(
        accountName: String,
        serviceName: String
    ) -> Bool? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: accountName,
            kSecReturnData: true
        ] as CFDictionary

        let status = SecItemCopyMatching(query, nil)

        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Невозможно получить пароль, ошибка: \(status)")
            return nil
        }
        guard status != errSecItemNotFound else {
            print("Пароль не найден 55")
            print(status)
            return false
        }
        return true
    }
    
    func verifyPassword(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: accountName,
            kSecReturnData: true
        ] as CFDictionary
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Невозможно получить пароль, ошибка: \(status)")
            return nil
        }
        guard status != errSecItemNotFound else {
            print("Пароль не найден 87")
            print(status)
            return nil
        }
        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("Невозможно преобразовать Data в пароль")
            return nil
        }
        if password == secureValue {
            print("Пароль совпал, открываем следующий контроллер")
            return true
        } else {
            print("Пароль не совпал, показываем ошибку")
            return false
        }
    }
    
    func save(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool? {
        guard secureValue != nil else { return nil }
        guard let passData = secureValue!.data(using: .utf8) else {
            print("Невозможно получить Data из passwordTextField")
            return nil
        }
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrAccount: accountName,
            kSecAttrService: serviceName
        ] as CFDictionary
        let status = SecItemAdd(attributes, nil)
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Невозможно добавить пароль, ошибка: \(status)")
            return false
        }
        print("Новый пароль добавлен успешно")
        return true
    }
    
    func changePassword(
        accountName: String,
        serviceName: String,
        secureValue: String?
    ) -> Bool? {
        guard secureValue != nil else { return nil }
        guard let passData = secureValue!.data(using: .utf8) else {
            print("Невозможно получить Data из пароля")
            return nil
        }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: accountName,
            kSecReturnData: false
        ] as CFDictionary
        let attributesToUpdate = [
            kSecValueData: passData,
        ] as CFDictionary
        let status = SecItemUpdate(query, attributesToUpdate)
        guard status == errSecSuccess else {
            print("Невозможно обновить пароль, ошибка номер: \(status)")
            return false
        }
        return true
    }
}
