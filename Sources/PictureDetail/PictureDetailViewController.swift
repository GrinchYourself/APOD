//
//  PictureDetailViewController.swift
//  
//
//  Created by Grinch on 17/12/2022.
//

import UIKit
import Domain
import Combine
import DesignSystem

public class PictureDetailViewController: UIViewController {

    public typealias Dependencies = HasPicturesRepository & HasImageLoader

    enum K {
        static let spacing = 8.0
        static let pictureRatio = 3.0/4.0
        static let betweenElement = 16.0
        static let cornerRadius = 5.0
    }

    // MARK: UI
    private lazy var hdItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(hdButtonPressed))
        buttonItem.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        return buttonItem
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let pictureImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.backgroundColor = Color.blue
        imageView.tintColor = Color.secondary
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = K.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = Color.text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let copyrightLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = Color.text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let explanationLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = Color.text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Private properties
    private let viewModel: PictureDetailViewModeling
    private weak var flow: PictureDetailFlow?
    private let imageLoader: ImageLoading
    private var subscriptions = Set<AnyCancellable>()

    private var hdURL: URL?

    // MARK: Init
    public init(dependencies: Dependencies, flow: PictureDetailFlow?, pictureId id: String) {
        self.viewModel = PictureDetailViewModel(dependencies: dependencies, pictureId: id)
        self.imageLoader = dependencies.imageLoader
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        registerHandlers()
        configureBarItem()
        applyConstraints()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDetail()
    }

    // MARK: Private methods
    private func registerHandlers() {

        viewModel.detailPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.showError()
                }
            }, receiveValue: { [weak self] picture in
                self?.hdURL = picture.highDefinitionURL
                self?.updateInformations(of: picture)
            })
            .store(in: &subscriptions)

    }

    private func fetchDetail() {
        viewModel.fetchPictureDetail()
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func configureBarItem() {
        navigationItem.setRightBarButton(hdItem, animated: true)
    }

    @objc private func hdButtonPressed() {
        guard let hdURL else {
            showError()
            return
        }
        flow?.showHDImage(url: hdURL)
    }

    private func updateInformations(of picture: PictureDetail) {
        title = picture.date
        loadImage(url: picture.pictureURL)
        titleLabel.text = picture.title
        explanationLabel.text = picture.explantion
        if let copyright = picture.copyright {
            copyrightLabel.attributedText = makeCopyright(for: copyright)
        }
    }

    private func loadImage(url: URL?) {

        guard let url else { return }
        imageLoader.loadImage(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
        } receiveValue: { [weak self] image in
            self?.pictureImageView.image = image
        }.store(in: &subscriptions)

    }

    private func applyConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(pictureImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(explanationLabel)

        NSLayoutConstraint.activate([
            //ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //ImageView
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            pictureImageView.heightAnchor.constraint(equalTo: pictureImageView.widthAnchor, multiplier: K.pictureRatio),
            //Title
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            titleLabel.topAnchor.constraint(equalTo: pictureImageView.bottomAnchor, constant: K.betweenElement),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            //Copyright
            copyrightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            copyrightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: K.betweenElement),
            copyrightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            //Description
            explanationLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: K.betweenElement),
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing)
        ])
    }

    private func makeCopyright(for text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "c.circle")?.withTintColor(Color.text)

        let copyrightString = NSMutableAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: text)
        copyrightString.append(textString)
        return copyrightString
    }

}

// MARK: error management
extension PictureDetailViewController {

    private func showError() {
        let alertVC = UIAlertController(title: "😅 Oop's", message: "L'image n'est pas disponible", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }

}
