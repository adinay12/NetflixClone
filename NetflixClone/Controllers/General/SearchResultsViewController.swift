//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Adinay on 2/11/23.
//

import UIKit
import SnapKit


protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel:TitlePreviewViewModel )
}


class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public weak var delegete: SearchResultsViewControllerDelegate?
    
    public lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 4, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(searchResultsCollectionView)
    }
    
    private func setupConstraints() {
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell  else { 
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName =  title.original_title ?? ""
        
        APICaller.shared.getMovie(witch: titleName) { [weak self] retult in
            switch retult {
            case .success(let videoElement):
                self?.delegete?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youTubeView: videoElement, titleOverView: title.overview ?? ""))
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
