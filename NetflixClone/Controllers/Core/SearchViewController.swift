//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Adinay on 30/10/23.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private lazy var discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search a movie or a Tv show"
        search.searchBar.searchBarStyle = .minimal
        search.searchResultsUpdater = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        setupViews()
        setupConstrains()
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies {[ weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
      private func setupViews() {
          view.addSubview(discoverTableView)
    }
    
    private func setupConstrains() {
        discoverTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {
            return  UITableViewCell()
        }
        
        let title =  titles[indexPath.row]
        let model = TitleViewModel(titleName: title.orginal_name ?? title.original_title ?? "Search", posterUrl: title.poster_path ?? "")
        cell.configure(with: model )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tittle = titles[indexPath.row]
        
        guard let titleName = tittle.original_title ?? tittle.orginal_name else { return  }
        
        APICaller.shared.getMovie(witch: titleName) { [weak self] retult in
            switch retult {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youTubeView: videoElement, titleOverView:tittle.overview ?? "" ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegete = self
        
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    }

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc =  TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
