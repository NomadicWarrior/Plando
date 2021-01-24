//
//  ViewController.swift
//  Plando
//
//  Created by Nomadic on 1/23/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa


class MainTaskListVC: UIViewController {
    
    // Search
    let searchArea: UISearchBar = {
       let search = UISearchBar()
        
        return search
    }()
    
    // Add new task button
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32
        button.backgroundColor = #colorLiteral(red: 0.9199072719, green: 0.01828959584, blue: 0.9984151721, alpha: 1)
        let image = UIImage(systemName: "plus")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addTaskButtonClicked), for: .touchUpInside)
        button.layer.shadowColor = #colorLiteral(red: 0.9199072719, green: 0.01828959584, blue: 0.9984151721, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    // CollectionView sections
    enum SectionKind: Int, CaseIterable {
        case category, tasks
    }
    
    private var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, AnyHashable>
    private var dataSource: DataSource!
    
    var tasks = [Tasks]()
    
    let realm = try! Realm()
    
    let bag = DisposeBag()
    
    var taskViewModel = TaskViewModel()
    
    var categories = [Categories]()
    var removalTaskIndex: Int = 0
    
}

// MARK: - ViewController Life Cycle
extension MainTaskListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories.append(Categories(title: "Business", count: "18"))
        categories.append(Categories(title: "Personal", count: "9"))
        categories.append(Categories(title: "Family", count: "4"))
        setupConstraints()
        loadAllTasks()
        setupRefreshControl(with: collectionView)
    }
    
    private func setupRefreshControl(with collectionView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        collectionView.refreshControl = refreshControl
//        loadAllTasks()
    }
    
    @objc private func handleRefresh() {
        loadAllTasks()
    }
    
    private func loadAllTasks() {
        let task = realm.objects(Tasks.self)
        tasks.removeAll()
        tasks.append(contentsOf: task)
        DispatchQueue.main.async {
            self.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadFilteredTasks(filter: String) {
        RealmService.shared.filterTask(category: filter) { (result) in
            switch result {
            case .success(let filteredTasks):
                self.tasks.removeAll()
                self.tasks = filteredTasks
                DispatchQueue.main.async {
                    self.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func removeTask() {
        print(removalTaskIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2034135759, green: 0.3145888448, blue: 0.6326703429, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2034135759, green: 0.3145888448, blue: 0.6326703429, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}


// MARK: - UI Actions
extension MainTaskListVC {
    @objc func leftButtonAction() {
        let vc = ProfileVC()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func searchBarButtonClicked() {
        print("search")
        navigationItem.titleView = searchArea
    }
    
    @objc private func bellButtonClicked() {
        print("bell")
        
    }
    
    @objc private func addTaskButtonClicked() {
        
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        
        var taskInput = UITextField()
        
        alertController.addTextField { (input) in
            taskInput = input
            taskInput.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControl.Event.editingChanged)
        }
        
        let business = UIAlertAction(title: "Business", style: .default) { (action) in
            self.addTask(text: taskInput.text!, category: action.title!)
        }
        business.isEnabled = false
        
        let personal = UIAlertAction(title: "Personal", style: .default) { (action) in
            self.addTask(text: taskInput.text!, category: action.title!)
        }
        personal.isEnabled = false
        
        let family = UIAlertAction(title: "Family", style: .default) { (action) in
            self.addTask(text: taskInput.text!, category: action.title!)
        }
        family.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(business)
        alertController.addAction(personal)
        alertController.addAction(family)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(field: UITextField){
        let alertController: UIAlertController = self.presentedViewController as! UIAlertController
        
        let textField :UITextField  = alertController.textFields![0]
        
        for i in 0...2 {
            alertController.actions[i].isEnabled = (textField.text?.count)! >= 3
        }
    }
    
     func addTask(text: String, category: String) {
        let newTask = Tasks()
        newTask.name = text
        newTask.categories = category
        newTask.isDone = false
        
        RealmService.shared.createNewTask(task: newTask) { (result) in
            switch result {
            case .success(let task):
                self.tasks.append(task)
                DispatchQueue.main.async {
                    self.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription) // We can add alert
            }
        }
    }
}

// MARK: - Setup constraints
extension MainTaskListVC {
    private func setupConstraints() {
        view.backgroundColor = #colorLiteral(red: 0.2034135759, green: 0.3145888448, blue: 0.6326703429, alpha: 1)
        
        // Navigation view
        let leftBarButtonImage = UIImage(systemName: "list.dash")?.withTintColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        let searchButtonImage = UIImage(systemName: "magnifyingglass")?.withTintColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        let bellButtonImage = UIImage(systemName: "bell")?.withTintColor(#colorLiteral(red: 0.470497191, green: 0.675825417, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        
        let leftNavButton = UIBarButtonItem(image: leftBarButtonImage, style: .done, target: self, action: #selector(leftButtonAction))
        let searchButton = UIBarButtonItem(image: searchButtonImage, style: .done, target: self, action: #selector(searchBarButtonClicked))
        let bellButton = UIBarButtonItem(image: bellButtonImage, style: .done, target: self, action: #selector(bellButtonClicked))
        
        navigationItem.leftBarButtonItem = leftNavButton
        navigationItem.rightBarButtonItems = [bellButton, searchButton]
        
        // Collection view
        let collectionViewSize = CGRect(x: 0, y: 0, width: self.view.frame.size.width,
                                        height: self.view.frame.size.height / 1.14)
        
        collectionView = UICollectionView(frame: collectionViewSize, collectionViewLayout: createLayout())
        
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseId)
        collectionView.register(TasksCell.self, forCellWithReuseIdentifier: TasksCell.reuseId)
        
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.2034135759, green: 0.3145888448, blue: 0.6326703429, alpha: 1)
        view.addSubview(collectionView)
        configureDataSource()
        reloadData()
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 64),
            addButton.widthAnchor.constraint(equalToConstant: 64),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
}

// MARK: - CollectionView Delegate
extension MainTaskListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
             let filterText = categories[indexPath.item].title
            loadFilteredTasks(filter: filterText)
        }
        else {
            print(indexPath.item)
        }
    }
}

// MARK: - Data Source
extension MainTaskListVC {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseId, for: indexPath) as? CategoryCell else { fatalError("Could not dequeue a CategoryCell")}
                cell.configure(with: item)
                return cell
            }
            else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TasksCell.reuseId, for: indexPath) as? TasksCell else { fatalError("Could not dequeue a CategoryCell")}
                cell.configure(with: item)
                let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.removeTask))
                swipe.direction = UISwipeGestureRecognizer.Direction.left
                cell.addGestureRecognizer(swipe)
                self.removalTaskIndex = indexPath.row
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as?
                HeaderView else { fatalError("Can not create new section header") }
            guard let section = SectionKind(rawValue: indexPath.section) else { fatalError("Uknown section kind") }
            switch section {
            case .category:
                sectionHeader.configure(text: "CATEGORIES")
            case .tasks:
                sectionHeader.configure(text: "TODAY'S TASKS")
            }
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, AnyHashable>()
        
        snapshot.appendSections([.category, .tasks])
        snapshot.appendItems(categories, toSection: .category)
        snapshot.appendItems(tasks, toSection: .tasks)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Compositional Layout
extension MainTaskListVC {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = SectionKind(rawValue: sectionIndex) else { fatalError("Wnknown section kind")}
            
            switch section {
            case .category:
                return self.createCategory()
            case .tasks:
                return self.createTasks()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createCategory() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 17, leading: 40, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createTasks() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 7, leading: 40, bottom: 0, trailing: 40)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize:sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

// MARK: - Content View
import SwiftUI

struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContentView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContentView: UIViewControllerRepresentable {
        let vc = MainTaskListVC()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContentView>) -> MainTaskListVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContentView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContentView>) {
            
        }
    }
}

