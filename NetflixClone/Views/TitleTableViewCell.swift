//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Adinay on 1/11/23.
//

import UIKit
import SnapKit

class TitleTableViewCell: UITableViewCell {
    
    static let id = "TitleTableViewCell"
    
    private lazy var playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titlePosterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titlePosterImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(54)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.equalTo(130)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titlePosterImage.snp.trailing).offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        playTitleButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
            return
        }
        titlePosterImage.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
