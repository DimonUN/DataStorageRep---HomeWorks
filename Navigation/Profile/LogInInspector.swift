//
//  LogInInspector.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 06.04.2022.
//

import Foundation
import FirebaseAuth

//MARK: - Delegate
protocol LogInViewControllerDelegate: AnyObject {
    func verification(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)

    func createUser(email: String, password: String)
}

class LogInInspector: LogInViewControllerDelegate {
    private let mainQueue = DispatchQueue.main

    func createUser(email: String, password: String) {
        FirebaseAuth.Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { result, error in
                guard error == nil else {
                    print("Account creation failed, error is: \(error)")
                    return
                }
            }
    }

    func verification(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        FirebaseAuth.Auth.auth().signIn(
                withEmail: email,
                password: password
        ) { result, error in
                guard error == nil else {
                    self.mainQueue.async {
                        completion(.failure(error!))
                    }
                    return
                }

                self.mainQueue.async {
                    completion(.success(result!))
                }
        }
    }
}

//MARK: - Factory
protocol LoginFactory {
    func createInspector() -> LogInInspector
}

class MyLoginFactory: LoginFactory {
    func createInspector() -> LogInInspector {
        return LogInInspector()
    }
}
