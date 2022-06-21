//
//  NetworkService.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 21.06.2022.
//

import Foundation

struct NetworkService {
    static func request(to url: String?) {
        guard url != nil else {
            print("No data to request")
            return
        }
            if let url = URL(string: url!) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let myDecodedString = String(data: data, encoding: .utf8)
                    print("===My decoded string is: \(String(describing: myDecodedString))")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("===StatusCode is: \(httpResponse.statusCode)")
                    print("===AllHeaderFields is: \(httpResponse.allHeaderFields)")
                   }
                if let error = error {
                    print("===Error is: \(error.localizedDescription), \n\(error)")
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
}

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
//    case error = "https://"
}

