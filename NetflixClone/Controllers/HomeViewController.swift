//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Adinay on 30/10/23.
//

import UIKit


enum Sectioons: Int {
    case TrendingMovie = 0
    case TrendingTv = 1
    case Popular = 2
    case UpComing = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private lazy var homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier:CollectionViewTableViewCell.id)
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .black
        view.addSubview(homeFeedTable)
        configurNavBar()
    }
    
    private func configurNavBar() {
        if let image = UIImage(named: "netflix") {
            let originalImage = image.withRenderingMode(.alwaysOriginal)
            let leftBarButtonItem = UIBarButtonItem(image: originalImage, style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
                UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            ]
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
        
    }



// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.id, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        
        switch indexPath.section {
        case Sectioons.TrendingMovie.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case.success(let titles):
                    cell.configure(witch: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sectioons.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { retult in
                switch retult {
                case.success(let titles):
                    cell.configure(witch: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
               
            
        case Sectioons.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case.success(let titles):
                    cell.configure(witch: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sectioons.UpComing.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case.success(let titles):
                    cell.configure(witch: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sectioons.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case.success(let titles):
                    cell.configure(witch: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
