//
//  PhotoViewController.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 18.02.2021.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {
    
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            let photoUrl = unsplashPhoto?.urls["regular"]
            guard let imageURL = photoUrl, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    var photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.backgroundColor = .systemBackground
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        return photo
    }()
    
    var imageScrollView: ImageScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .allButUpsideDown
        //setupImageView()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView ?? UIImageView())
        
        let imagePath = photoImageView.image ?? UIImage()
        self.imageScrollView?.set(image: imagePath)
    }
    
//    private func setupImageView() {
//        view.addSubview(photoImageView)
//        photoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
    
    private func setupImageScrollView() {
        imageScrollView?.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageScrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
