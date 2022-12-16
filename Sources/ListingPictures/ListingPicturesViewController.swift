//
//  ListingPicturesViewController.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import UIKit
import Combine
import Domain

public class ListingPicturesViewController: UIViewController {

    public typealias Dependencies = HasPicturesRepository & HasImageLoader
    public typealias NavigationFlow = String

    // MARK: Enum
    enum TableViewSection: Hashable {
        case main
    }

    enum K {
        static let cellIdentifier = "PictureThumbnailTableViewCell"
    }

    // MARK: UI
    private var tableView = UITableView(frame: CGRect.zero, style: .plain)
    private lazy var tableViewDataSource: UITableViewDiffableDataSource< TableViewSection, PictureThumbnail> = {
        UITableViewDiffableDataSource<TableViewSection, PictureThumbnail>.init(tableView: tableView) {
            [weak self] tableView, indexPath, pictureThumbnail in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as? PictureThumbnailTableViewCell else {
                return UITableViewCell()
            }
            cell.imageLoader = self?.imageLoader
            cell.configure(for: pictureThumbnail)
            return cell
        }
    }()

    // MARK: Private properties
    private let viewModel: ListingPicturesViewModeling
//    private weak var flow: MYFlow?
    private var subscriptions = Set<AnyCancellable>()
    private var fetchCancellable: AnyCancellable?
    private let imageLoader: ImageLoading

    // MARK: Init
    public init(dependencies: Dependencies, flow: NavigationFlow?) {
        self.viewModel = ListingPicturesViewModel(dependencies: dependencies)
        self.imageLoader = dependencies.imageLoader
//        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "APOD"
        view.backgroundColor = .systemGray5

        registerHandlers()

        configureTableView()

        fetchItems()
    }

    // MARK: Private methods
    private func registerHandlers() {
        viewModel.picturesListPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] adItems in
                self?.reloadItems(adItems)
            }.store(in: &subscriptions)

        viewModel.fetchStatePublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .error: self?.showError()
                default: break
                }
            }.store(in: &subscriptions)
    }

    private func fetchItems() {
        viewModel.fetchPictures()
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.register(PictureThumbnailTableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .label
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func reloadItems(_ pictures: [PictureThumbnail]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, PictureThumbnail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pictures, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }

}

// MARK: error management
extension ListingPicturesViewController {
    private func showError() {
        let alertVC = UIAlertController(title: "😅 Oop's",
                                        message: "Une erreur est survenue, merci de reessayer plus tard",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
}

extension ListingPicturesViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pictureId = tableViewDataSource.itemIdentifier(for: indexPath)?.id else { return }
//        flow?.showAdDetails(itemIdentifier)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
