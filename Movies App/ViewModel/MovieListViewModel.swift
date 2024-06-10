//
//  MovieListViewModel.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 08/06/24.
//

import Foundation
import Combine

private let kDebugMovieListViewModel = "DEBUG MovieListViewModel:"
class MovieListViewModel {
    
    // MARK: - Properties
    @Published private(set) var movies = [Movie]()
    @Published var loadingCompleted = false
    
    private var cancellables = Set<AnyCancellable>()
    private let httpClient: HTTPClient
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.loadMovies(search: searchText)
            }.store(in: &cancellables)
    }
    
    func setSearchText(_ searchText: String) {
        print(kDebugMovieListViewModel, "Sending search text")
        searchSubject.send(searchText)
    }
    
    func loadMovies(search: String) {
        httpClient.fetchMovies(search: search)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("\(kDebugMovieListViewModel) Finished")
                    self?.loadingCompleted = true
                case .failure(let error):
                    print("\(kDebugMovieListViewModel) Error => \(error.localizedDescription)")
                    print(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
    }
}

