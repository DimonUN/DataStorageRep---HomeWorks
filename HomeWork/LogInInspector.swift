//
//  LogInInspector.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 06.04.2022.
//

import Foundation

//MARK: -Выполнение условий ДЗ



//MARK: Delegate
protocol LogInViewControllerDelegate: AnyObject {
    func verification(lgn: Int, pswd: Int) -> Bool
}

class LogInInspector: LogInViewControllerDelegate {
    private let data = Checker.shared.getData()
    
    func verification(lgn: Int, pswd: Int) -> Bool {
        if data.0 == lgn && data.1 == pswd {
            return true
        } else {
            return false
        }
    }
}



//MARK: Factory
protocol LoginFactory {
    func createInspector() -> LogInInspector
}

class MyLoginFactory: LoginFactory {
    func createInspector() -> LogInInspector {
        return LogInInspector()
    }
}
