//
//  ImageMonthCalendarCell.swift
//  FSCalendarTutorial
//
//  Created by 김건우 on 12/5/23.
//

import UIKit

import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

// TODO: - Reactor 구현하기
final class ImageMonthCalendarCell: FSCalendarCell {
    // MARK: - Views
//    let highlightView = UIView().then {
//        $0.layer.masksToBounds = true
//        $0.layer.cornerRadius = 10.0
//        $0.backgroundColor = UIColor.systemGray5
//    }
    
    let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10.0
        $0.layer.borderWidth = 2.5
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    private var badgeView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 13.0 / 2.0
        $0.backgroundColor = UIColor.white
    }
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(imageUrl url: String, isCompleted: Bool) {
        if url.isEmpty { backgroundImageView.layer.borderWidth = 0.0 }
        if let url = URL(string: url) {
            badgeView.isHidden = isCompleted
            backgroundImageView.kf.setImage(with: .network(url))
        } else {
            badgeView.isHidden = true
        }
    }
    
    // MARK: - Helpers
    private func setupUI() {
        contentView.insertSubview(backgroundImageView, at: 0)
//        contentView.insertSubview(highlightView, at: 0)
        contentView.addSubview(badgeView)
    }
    
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.width.height.equalTo(contentView.snp.width).inset(6)
        }
        
//        highlightView.snp.makeConstraints {
//            $0.leading.equalTo(contentView.snp.leading)
//            $0.bottom.equalTo(contentView.snp.bottom)
//            $0.trailing.equalTo(contentView.snp.trailing)
//            $0.height.equalTo(100)
//        }
        
        badgeView.snp.makeConstraints {
            $0.top.trailing.equalTo(0)
            $0.height.width.equalTo(13)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        backgroundImageView.layer.borderWidth = 2.5
    }
}
