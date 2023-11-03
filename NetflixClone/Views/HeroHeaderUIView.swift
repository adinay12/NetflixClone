//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Adinay on 30/10/23.
//

import UIKit
import SnapKit
import SDWebImage

class HeroHeaderUIView: UIView {
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        return button
    }()
    
    private lazy var heroImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.frame = bounds
        image.image = UIImage(named: "twilight")
        return image
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(120)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(120)
        }
    }
    
    public func configure(witch model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
            return
        }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
}
