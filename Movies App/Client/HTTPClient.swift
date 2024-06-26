//
//  HTTPClient.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 06/06/24.
//

import Foundation
import Combine

// Get your API Key by sign up with your email on omdb site "https://www.omdbapi.com/" .
private let API_KEY = "6829b156"

// SAA_MVDB => Sahil Amrut Agashe Movies Database
private let SAA_MVDB_API_URL = URL(string: "http://127.0.0.1:8080/saa/mvdb/movies")
// OMDB API URL FOR BATMAN
private let OMDB_API_URL = URL(string: "https://www.omdbapi.com/?s=batman&apikey=6829b156")

enum NetworkError: Error {
    case badUrl
}

private let kDebugHTTPClient = "DEBUG HTTPClient:"
class HTTPClient {
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        
        guard let encodedSearch = search.urlEncoded,
              let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&apikey=\(API_KEY)")
                //URL(string: "http://127.0.0.1:8080/saa/mvdb/movies")
        else {
            print("\(kDebugHTTPClient) guard let error!")
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // can also written as => .map(\(data: Data, response: URLResponse).data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.search)
            .receive(on: DispatchQueue.main)
            .catch { _ in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        /*
        let dataTaskPublisher: URLSession.DataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
         
        public typealias Output = (data: Data, response: URLResponse)
        public typealias Failure = URLError
         
         here URLSession.DataTaskPublisher conforms Publisher<Output, Failure> protocol,
         so for DataTaskPublisher , Output is tuple (data: Data, response: URLResponse)
         and Failure is URLError
         
         And,
         public func map<T>(_ keyPath: KeyPath<Self.Output, T>) -> Publishers.MapKeyPath<Self, T>
         this is map method defined in Publisher protocol.
         Please observe keyPath parameter => KeyPath<Self.Output, T>)
         */
    }
}

// MARK: - MyDataTaskPublisher Similar To => URLSession.DataTaskPublisher
private struct MyDataTaskPublisher: Publisher {
    typealias Output = (data: Data, response: URLResponse)
    typealias Failure = URLError
    
    func receive<S>(subscriber: S) where S : Subscriber, URLError == S.Failure, (data: Data, response: URLResponse) == S.Input {
        
    }
}
