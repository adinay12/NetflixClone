//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Adinay on 2/11/23.
//

import UIKit
import SnapKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумерки"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Капитан Америка -2"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        setupViews()
        setupConstraints()
    }
    
   private func setupViews() {
       view.addSubview(webView)
       view.addSubview(titleLabel)
       view.addSubview(overViewLabel)
       view.addSubview(downloadButton)
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(56)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(298)
//            make.height.equalTo(240)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        overViewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(overViewLabel.snp.bottom).offset(22)
            make.width.equalTo(100)
            make.height.equalTo(34)
        }
    }
    
    public func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youTubeView.id.videoId)") else { return
        }
        
        webView.load(URLRequest(url: url))
    }
}
