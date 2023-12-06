//
//  PageCollectionViewCell.swift
//  FSCalendarTutorial
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PageCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let calendarView: FSCalendar = FSCalendar()
    
    private let scoreView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20.0
        $0.backgroundColor = UIColor.systemGray5
    }
    
    // MARK: - Properties
    weak var delegate: CalendarViewDelegate?
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        contentView.addSubview(calendarView)
        contentView.addSubview(scoreView)
    }
    
    private func setupAutoLayout() {
        scoreView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(12)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.height.equalTo(300)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
//            $0.top.equalTo(scoreView.snp.bottom).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(0)
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.9)
        }
        
    }
    
    private func setupAttributes() {
        contentView.backgroundColor = UIColor.systemPink
        setupCalendarAttributes()
    }
    
    private func setupCalendarAttributes() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.register(ImageMonthCalendarCell.self, forCellReuseIdentifier: "calendarCell")
        calendarView.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: "placeholderCell")
        calendarView.backgroundColor = UIColor.black
        
        calendarView.today = nil
        calendarView.placeholderType = .fillSixRows
        calendarView.rowHeight = 50.0
        
        calendarView.scrollEnabled = false
        
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.adjustsBoundingRectWhenChangingMonths = false
        
        calendarView.appearance.headerTitleColor = UIColor.clear
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.headerHeight = 0.0
        
        calendarView.weekdayHeight = 40.0
        
        calendarView.appearance.selectionColor = UIColor.clear
        calendarView.appearance.titleSelectionColor = UIColor.white
        
        calendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 20)
        calendarView.appearance.titleDefaultColor = UIColor.white
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
        calendarView.appearance.weekdayTextColor = UIColor.white
        
        calendarView.appearance.caseOptions = .weekdayUsesSingleUpperCase
    }
    
    func configure(_ offset: Int) {
        calendarView.setCurrentPage(Date().addingTimeInterval(Double(86400 * 30 * offset)), animated: false)
    }
}

extension PageCollectionViewCell: FSCalendarDelegate { 
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.moveToDetailVC(date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if calendar.currentPage.month == date.month {
            return true
        } else { return false }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
       
    }
}

extension PageCollectionViewCell: FSCalendarDataSource {
    // TODO: - Reactor로 주입하기
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        if calendar.currentPage.month == date.month {
            let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! ImageMonthCalendarCell
            let randomBool = Bool.random()
            let randomImageUrl = [
                "https://cdn.pixabay.com/photo/2016/03/08/20/03/flag-1244648_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/19/10/19/sheet-music-8398449_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/09/29/11/19/sunrays-8283601_1280.jpg",
                "",
                "",
            ].randomElement()
            cell.configure(imageUrl: randomImageUrl ?? "", isCompleted: randomBool)
            return cell
        } else {
            let cell = calendar.dequeueReusableCell(withIdentifier: "placeholderCell", for: date, at: position) as! PlaceholderCalendarCell
            return cell
        }
    }
}

extension Date {
    var month: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.month], from: self)
        return comp.month ?? 0
    }
}
