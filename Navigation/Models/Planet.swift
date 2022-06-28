//
//  Planet.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 28.06.2022.
//

import Foundation

struct Planet: Codable {
    let name: String
    let residents: [String]
    var linksForResidents: [URL] = []

    let orbitalPeriod: String

    enum CodingKeys: String, CodingKey {
        case name, residents
        case orbitalPeriod = "orbital_period"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.residents = try container.decode([String].self, forKey: .residents)
        self.orbitalPeriod = try container.decode(String.self, forKey: .orbitalPeriod)

        residents.forEach({
            if let url = URL(string: $0) {
                self.linksForResidents.append(url)
            } else {
                print("Can't create url from \($0)")
            }
        })
    }
}



