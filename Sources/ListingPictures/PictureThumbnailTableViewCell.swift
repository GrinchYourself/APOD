//
//  PictureThumbnailTableViewCell.swift
//  
//
//  Created by Grinch on 16/12/2022.
//

import UIKit
import Combine
import Domain
import DesignSystem

class PictureThumbnailTableViewCell: UITableViewCell {

    enum K {
        static let spacing = 16.0
        static let betweenElement = 8.0
        static let cornerRadius = 5.0
        static let pictureRatio = 3.0/4.0
    }

    let pictureImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = Color.secondary
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = K.cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let dateLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = Color.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var imageLoader: ImageLoading?
    private var imageLoadingCancellable: AnyCancellable?

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.blue
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Self
    override func prepareForReuse() {
        imageLoadingCancellable?.cancel()
        imageLoadingCancellable  = nil
        pictureImageView.image = UIImage(systemName: "photo")
        dateLabel.text = ""
    }

    // MARK: private methods
    private func applyConstraints() {
        contentView.addSubview(pictureImageView)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            //ImageView
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.spacing),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            pictureImageView.heightAnchor.constraint(equalTo: pictureImageView.widthAnchor, multiplier: K.pictureRatio),
            //Date
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.spacing),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.spacing),
            dateLabel.topAnchor.constraint(equalTo: pictureImageView.bottomAnchor, constant: K.betweenElement),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.spacing)
        ])
    }

    // MARK: Configuration
    func configure(for picture: PictureThumbnail) {
        loadImage(url: picture.url)
        dateLabel.text = picture.date
    }

    private func loadImage(url: URL?) {
        guard let imageLoader else { return }
        guard let url else { return }

        imageLoadingCancellable = imageLoader.loadImage(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] image in
                self?.pictureImageView.image = image
            }

    }

}
