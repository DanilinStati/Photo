//
//  PhotoCell.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 16.02.2021.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static let identifire = "CellID"
    private let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 5
        photo.layer.masksToBounds = true
        return photo
    }()
    
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            let photoUrl = unsplashPhoto?.urls["regular"]
            guard let imageURL = photoUrl, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
