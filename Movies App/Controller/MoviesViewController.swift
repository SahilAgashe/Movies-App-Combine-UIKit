//
//  MoviesViewController.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 05/06/24.
//

import UIKit
import SwiftUI
import Combine

private let kDebugMoviesViewController = "DEBUG MoviesViewController:"
class MoviesViewController: UIViewController {
    
    // MARK: - Properties

    private let viewModel: MovieListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
        
    lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.$loadingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                if completed {
                    self?.moviesTableView.reloadData()
                }
            }.store(in: &cancellables)
    }
        
    // MARK: - Helpers
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        // register cells
        moviesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(moviesTableView)
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = viewModel.movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = movie.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print()
        viewModel.setSearchText(searchText)
    }
}

// MARK: - SwiftUI

struct MoviesViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MoviesViewController
    
    func updateUIViewController(_ uiViewController: MoviesViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> MoviesViewController {
        MoviesViewController(viewModel: MovieListViewModel(httpClient: HTTPClient()))
    }
}

#Preview {
    MoviesViewControllerRepresentable()
}



