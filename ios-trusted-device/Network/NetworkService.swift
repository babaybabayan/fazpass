//
//  NetworkService.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 06/01/23.
//

import Foundation

struct NetworkService {
    static let instance = NetworkService()
    func execute<C: Decodable>(c classType: C.Type, service: Services, completion: @escaping (Result<C, FazPassError>) -> Void) {
        var headers: Dictionary = [
            "Authorization": "Bearer \(String(describing: FazpassContext.shared.merchantKey ?? ""))",
            "Content-Type": "application/json"
        ]
        if let headerService = service.headers {
            for header in headerService {
                headers[header.key] = header.value
            }
        }
        var request = URLRequest(url: URL(string: Constant.baseURL+service.path)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = service.method
        request.httpBody = service.body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            guard let data = data else { return }
            switch statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(C.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.decodeError))
                }
            case 400...499:
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ErrorResponse.self, from: data)
                    completion(.failure(.softError(error: response)))
                } catch {
                    completion(.failure(.decodeError))
                }
            default:
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ErrorResponse.self, from: data)
                    completion(.failure(.softError(error: response)))
                } catch {
                    completion(.failure(.decodeError))
                }
            }
        }
        task.resume()
    }
    
    func requestObjects<C: Decodable>(c classType: C.Type, service: Services, completion: @escaping (Result<C, FazPassError>) -> Void) {
        DispatchQueue(label: "queue", attributes: .concurrent).async {
            self.execute(c: classType, service: service) { results in
                switch results {
                case .success(let data):
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
