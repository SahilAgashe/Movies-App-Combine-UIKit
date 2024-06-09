//
//  MovieListViewModel.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 08/06/24.
//

import Foundation
import Combine

class MovieListViewModel {
    
    @Published private(set) var movies = [Movie]()
    @Published var loadingCompleted = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let httpClient: HTTPClient
    
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadMovies(search: String) {
        
        httpClient.fetchMovies(search: search)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingCompleted = true
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
    }
}

