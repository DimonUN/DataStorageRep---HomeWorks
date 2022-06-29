//
//  Residents.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 28.06.2022.
//

import Foundation

struct Residents: Codable {
    let name: String
//    let height: String
//    let mass: String
//    let hairColor: String
//    let skinColor: String
//    let eyeColor: String
//    let birthYear: String
//    let gender: String

    enum CodingKeys: String, CodingKey {
        case name
    }

//    enum CodingKeys: String, CodingKey {
//        case name, height, mass, gender
//        case hairColor = "hair_color"
//        case skinColor = "skin_color"
//        case eyeColor = "eye_color"
//        case birthYear = "birth_year"
//    }
}
