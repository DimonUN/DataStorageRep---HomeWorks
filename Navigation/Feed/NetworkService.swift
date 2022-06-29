//
//  NetworkService.swift
//  Navigation
//
//  Created by Дмитрий Никоноров on 24.06.2022.
//

import Foundation

enum NetworkErrors: Error {
    case `default`
    case serverError
    case parseError
    case unknownError

}


protocol NetworkServiceProtocol {
    func request(url: URL, completion: @escaping (Result<Data, NetworkErrors>) -> Void)
}

final class NetworkService {
    private let mainQueue = DispatchQueue.main
}

extension NetworkService: NetworkServiceProtocol {
    func request(url: URL, completion: @escaping (Result<Data, NetworkErrors>) -> Void) {

        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            guard error == nil else {
                self.mainQueue.async { completion(.failure(.default)) }
                return
            }
            
            guard let data = data else {
                self.mainQueue.async { completion(.failure(.unknownError)) }
                return
            }

            self.mainQueue.async {
                completion(.success(data))
            }
        })
        task.resume()
    }
}
