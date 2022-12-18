//
//  HighDefinitionPictureViewController.swift
//  
//
//  Created by Grinch on 18/12/2022.
//

import UIKit
import DesignSystem
import Domain
import Combine

public class HighDefinitionPictureViewController: UIViewController {

    public typealias Dependencies = HasImageLoader

    private enum K {
        static let minimumZoomScale: CGFloat = 1
        static let maximumZoomScale: CGFloat = 3
        static let thumbnailImageName = "photo"
        static let closeImageName = "xmark"
    }

    // MARK: UI
    private lazy var closeItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(closeViewer))
        buttonItem.image = UIImage(systemName: K.closeImageName)
        return buttonItem
    }()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = K.minimumZoomScale
        scrollView.maximumZoomScale = K.maximumZoomScale
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var hdImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: K.thumbnailImageName))
        imageView.tintColor = Color.secondary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    // MARK: Private properties
    private let imageLoader: ImageLoading
    private let hdURL: URL
    private weak var flow: HighDefinitionFlow?
    private var loaderCancelalable: AnyCancellable?

    // MARK: Init
    public init(dependencies: Dependencies, flow: HighDefinitionFlow?, pictureURL url: URL) {
        imageLoader = dependencies.imageLoader
        self.flow = flow
        hdURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        configureBarItem()
        configureScrollView()
        applyConstraints()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImage()
    }

    // MARK: Private methods
    private func configureBarItem() {
        navigationItem.setRightBarButton(closeItem, animated: true)
    }

    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.addGestureRecognizer(doubleTapGesture)
    }

    private func applyConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(hdImageView)

        NSLayoutConstraint.activate([
            //ScrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //hdImageView
            hdImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hdImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            hdImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            hdImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    private func loadImage() {

        loaderCancelalable = imageLoader.loadImage(for: hdURL)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.showError()
                }
        } receiveValue: { [weak self] hdImage in
            self?.hdImageView.image = hdImage
        }

    }

    @objc private func doubleTapped() {

        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(2, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }

    }

    @objc private func closeViewer() {
        flow?.closeViewer()
    }
}

extension HighDefinitionPictureViewController: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        hdImageView
    }

}

// MARK: error management
extension HighDefinitionPictureViewController {

    private func showError() {
        let alertVC = UIAlertController(title: "😅 Oop's",
                                        message: "Une erreur est survenue, merci de reessayer plus tard",
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.closeViewer()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }

}
