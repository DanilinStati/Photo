//
//  PhotosCollectionViewController.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 13.02.2021.
//

import UIKit

class PhotosCollectionViewController: UIViewController {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let searchController = UISearchController(searchResultsController: nil)
    private let networkDataFetcher = NetworkDataFetcher()
    private var timer = Timer()
    private var photos = [UnsplashPhoto]()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        setupCollectionView()
        setupCollectionViewItemSize()
        setupSearchBar()
        setupSpinner()
        setupRefreshControl()
        downloadStartImage()
        
    }
    
    private func downloadStartImage() {
        networkDataFetcher.fetchImages(searchTerm: "Photo") { [weak self] (searchResults) in
            guard let fetchPhotos = searchResults else { return }
            self?.photos = fetchPhotos.results
            self?.collectionView.reloadData()
        }
    }

//MARK: - Setup UI elements

    private func setupCollectionView() {
        setCollectionViewDelegate()
        view.addSubview(collectionView)
        title = "Photos"
        collectionView.backgroundColor = .systemBackground
        collectionView.frame = view.bounds
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifire)
    }

    private func setCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupSearchBar() {
        setSearchBarDelegate()
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func setSearchBarDelegate() {
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionViewItemSize() {
      let customLayout = WaterfallLayout()
      customLayout.delegate = self
      collectionView.collectionViewLayout = customLayout
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Wait a second")
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        networkDataFetcher.fetchImages(searchTerm: "Photo") { [weak self] (searchResults) in
            guard let fetchPhotos = searchResults else { return }
            self?.photos = fetchPhotos.results
            self?.collectionView.reloadData()
        }
        sender.endRefreshing()
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifire, for: indexPath) as! PhotoCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = InfoViewController()
        let data = photos[indexPath.row]
        info.unsplashPhoto = photos[indexPath.item]
        info.widthLabel.text = "Wight picture: \(data.width / 100) cm"
        info.heightLabel.text = "Height picture: \(data.height / 100) cm"
        info.descript.text = "Description: \(data.description ?? "N/A")"
        info.createdAt.text = "Create: \(data.created_at ?? "N/A")"
        present(info, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.spinner.startAnimating()
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchPhotos = searchResults else { return }
                self?.spinner.stopAnimating()
                self?.photos = fetchPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}

extension PhotosCollectionViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
}



