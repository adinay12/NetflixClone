//
//  UpcommingViewController.swift
//  NetflixClone
//
//  Created by Adinay on 30/10/23.
//

import UIKit
import SnapKit

class UpcommingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private lazy var upComingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
//        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upComingTableView)
        fetchUpcoming()
        setupConstrains()
        upComingTableView.frame = view.bounds
    }
    
  
    private func setupConstrains() {
        upComingTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
        
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        upComingTableView.frame = view.bounds
//    }
    
    private func fetchUpcoming() {
        APICaller.shared.getPopular { [ weak self ]  result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upComingTableView.reloadData()
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension UpcommingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel (titleName: (title.original_title ?? title.orginal_name) ?? "sdfg", posterUrl: title.poster_path ?? "asd"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 204
    }
}
