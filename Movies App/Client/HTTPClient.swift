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

enum NetworkError: Error {
    case badUrl
}

class HTTPClient {
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        
        guard let encodedSearch = search.urlEncoded,
              let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&apikey=\(API_KEY)")
        else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
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
        

        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // can also written as => .map(\(data: Data, response: URLResponse).data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - MyDataTaskPublisher Similar To => URLSession.DataTaskPublisher
private struct MyDataTaskPublisher: Publisher {
    typealias Output = (data: Data, response: URLResponse)
    typealias Failure = URLError
    
    func receive<S>(subscriber: S) where S : Subscriber, URLError == S.Failure, (data: Data, response: URLResponse) == S.Input {
        
    }
}
