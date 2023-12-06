//
//  DetailViewController.swift
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

final class DetailViewController: UIViewController {
    // MARK: - Views
    let calendarView = FSCalendar()
    
    // MARK: - Properties
    var selectedDate: Date? {
        didSet {
            calendarView.select(selectedDate, scrollToDate: true)
        }
    }
    
    var previousSelectedDate: Date?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DetailVC"
        view.backgroundColor = UIColor.white
        previousSelectedDate = selectedDate
        
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    private func setupUI() {
        view.addSubview(calendarView)
    }
    
    private func setupAutoLayout() {
        calendarView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
    }
    
    private func setupAttributes() {
        setupCalendarAttributes()
    }
    
    private func setupCalendarAttributes() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(ImageMonthCalendarCell.self, forCellReuseIdentifier: "imageCell")
        
        calendarView.locale = Locale(identifier: "ko_KR")
        
        calendarView.headerHeight = 0.0
        calendarView.weekdayHeight = 30.0
        
        calendarView.backgroundColor = UIColor.black
        calendarView.setScope(.week, animated: false)
        calendarView.rowHeight = 50.0
        
        calendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 20)
        calendarView.appearance.titleDefaultColor = UIColor.white
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
        calendarView.appearance.weekdayTextColor = UIColor.white
        
        calendarView.appearance.selectionColor = UIColor.clear
        calendarView.appearance.titleSelectionColor = UIColor.white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        navigationItem.title = dateFormatter.string(from: calendarView.currentPage)
    }
    
}

extension DetailViewController: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        navigationItem.title = dateFormatter.string(from: calendar.currentPage)
    }
}

extension DetailViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "imageCell", for: date, at: position) as! ImageMonthCalendarCell
        let randomBool = Bool.random()
        let randomImageUrl = [
            "https://cdn.pixabay.com/photo/2016/03/08/20/03/flag-1244648_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/19/10/19/sheet-music-8398449_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/29/11/19/sunrays-8283601_1280.jpg",
            "",
            "",
        ].randomElement()
        cell.fs_height = 50.0
        cell.configure(imageUrl: randomImageUrl ?? "", isCompleted: randomBool)
        return cell
    }
}
