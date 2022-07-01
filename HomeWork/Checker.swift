//
//  Checker.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 06.04.2022.
//

import Foundation

//MARK: -Выполнение условий ДЗ

// MARK: Singleton
final class Checker {
    static var shared: Checker { Checker() }
    
    private let login = "login"
    private let pswd = "password"
    
    func getData() -> (Int, Int) {
        let data: (Int, Int) = (login.hash, pswd.hash)
        return data
    }
}
