//
//  PlaceholderCalendarCell.swift
//  FSCalendarTutorial
//
//  Created by 김건우 on 12/5/23.
//

import Foundation

import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PlaceholderCalendarCell: FSCalendarCell {
    // MARK: - Views
    private let placeholderView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10.0
        $0.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    }
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.insertSubview(placeholderView, at: 0)
    }
    
    func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        
        placeholderView.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.width.height.equalTo(contentView.snp.width).inset(6)
        }
    }
}
