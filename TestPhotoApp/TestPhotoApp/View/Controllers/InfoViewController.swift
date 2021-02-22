//
//  InfoViewController.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 17.02.2021.
//

import UIKit
import SDWebImage

class InfoViewController: UIViewController {
    
    private var photos = [UnsplashPhoto]()
    
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
        photo.layer.cornerRadius = 10
        photo.layer.masksToBounds = true
        photo.clipsToBounds = true
        return photo
    }()
    
    var widthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = UIColor(cgColor: CGColor(gray: 0.9, alpha: 0.4))
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = UIColor(cgColor: CGColor(gray: 1, alpha: 0.5))
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var createdAt: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = UIColor(cgColor: CGColor(gray: 0.8, alpha: 0.3))
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var descript: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = UIColor(cgColor: CGColor(gray: 0.7, alpha: 0.2))
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descript, createdAt, widthLabel, heightLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        setupImageView()
        setupVerticalStackView()
        setupGestureInImageView()
    }
    
// MARK: Setup UI elements
    
    private func setupGestureInImageView() {
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
    }
    
    @objc private func tapImage() {
        let photoVC = PhotoViewController()
        photoVC.unsplashPhoto = unsplashPhoto
        self.present(photoVC, animated: true)
    }
    
    private func setupImageView() {
        view.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
    }

}
