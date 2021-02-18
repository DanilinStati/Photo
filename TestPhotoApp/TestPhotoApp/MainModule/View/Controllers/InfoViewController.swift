//
//  InfoViewController.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 17.02.2021.
//

import UIKit
import SDWebImage

class InfoViewController: UIViewController {
    
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            let photoUrl = unsplashPhoto?.urls["regular"]
            guard let imageURL = photoUrl, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }

    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    var widthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var createdAt: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var descript: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descript, createdAt, widthLabel, heightLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 4
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupImageView()
        setupVerticalStackView()
        setupGestureInImageView()
    }
    
    private func setupGestureInImageView() {
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
    }
    
    @objc private func tapImage() {
        self.present(PhotoViewController(), animated: true)
    }
    
    private func setupImageView() {
        view.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
}
