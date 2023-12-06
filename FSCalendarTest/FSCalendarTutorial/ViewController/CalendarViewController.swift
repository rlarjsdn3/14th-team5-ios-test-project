//
//  ViewController.swift
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

protocol CalendarViewDelegate: AnyObject {
    func moveToDetailVC(_ date: Date)
}

// TODO: - Reactor 구현하기
final class CalendarViewController: UIViewController {
    // MARK: - Views
    private let calendarView: FSCalendar = FSCalendar()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: orthogonalLayout).then {
        $0.dataSource = self
        $0.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: "pageCell")
        $0.isScrollEnabled = false
    }
    
    private let goToCurrentDateButton = UIButton(type: .system).then {
        $0.setTitle("오늘", for: .normal)
    }
    
    // MARK: - Properties
    let today = Date()
    lazy var orthogonalLayout = createOrthogonalScrollLayout()
    
    let offset = [1, 2, 3]
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let lastIndexPath = IndexPath(item: offset.count - 1, section: 0)
        collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false )
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(goToCurrentDateButton)
    }
    
    private func setupAutoLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.systemBackground
    }
    
    private func createOrthogonalScrollLayout() -> UICollectionViewCompositionalLayout {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            guard let self = self else { return }
            let width = self.collectionView.bounds.width
            let scrollOffset = offset.x
            
            let result = Int(round(scrollOffset / width))
            
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .month, value: result+1, to: Date()) ?? Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M월"
            formatter.calendar = Calendar.current
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print(formatter.string(from: date))
            navigationItem.title = formatter.string(from: date)
        }
        // layout
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return compositionalLayout
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as! PageCollectionViewCell
        cell.delegate = self
        cell.configure(offset[indexPath.item])
        return cell
    }
}

extension CalendarViewController: CalendarViewDelegate {
    func moveToDetailVC(_ date: Date) {
        let detailVC = DetailViewController()
        detailVC.selectedDate = date
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
