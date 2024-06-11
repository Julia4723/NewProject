//
//  NetworkManager.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import Foundation
import Alamofire
import Kingfisher

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum PokemonAPI: String {
    case url = "https://pokeapi.co/api/v2/pokemon"
        }


enum Link {
    
    case postRequest
    
    var url: URL {
        switch self{
        case .postRequest:
            return URL (string: "https://jsonplaceholder.typicode.com/posts")!
        }
    }
}



final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetch<T: Decodable>(dataType: T.Type, url: String, completion: @escaping(T) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(type)
                }
            } catch {
                print(error)
            }
        }.resume()
    
    }
    
    
    func fetchImage(from url: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                print("Ошибка декодирования")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    
    func postNewPokemon(to url: URL, with parameters: Pokemon, completion: @escaping (Result<Pokemon, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(encoder: JSONEncoder()))
            .validate()
            .responseDecodable(of: Pokemon.self) { dataResponse in
                switch dataResponse.result {
                case .success(let course):
                    completion(.success(course))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    private init() {}
    
}
        
