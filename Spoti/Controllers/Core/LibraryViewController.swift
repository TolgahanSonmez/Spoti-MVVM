//
//  LibraryViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 16.09.2022.
//

import UIKit

class LibraryViewController: UIViewController {
    
   
    
    private let playlistVC = LibraryPlaylistViewController()
    
    private let albumsVC = LibraryAlbumsViewController()
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let libraryView = LibraryToggleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Kütüp"
        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        view.addSubview(libraryView)
        libraryView.delegate = self
        scrollView.contentSize = CGSize(width: view.width, height: scrollView.height)
        scrollView.delegate = self
        updateBarButtons()
        addChildren()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+55,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        )
        libraryView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55
        )
        libraryView.backgroundColor = .white
    }
    
    
    private func updateBarButtons() {
        switch libraryView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func addChildren() {
            addChild(playlistVC)
            scrollView.addSubview(playlistVC.view)
            playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
            playlistVC.didMove(toParent: self)

            addChild(albumsVC)
            scrollView.addSubview(albumsVC.view)
            albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
            albumsVC.didMove(toParent: self)
        }
    
    @objc private func didTapAdd() {
        playlistVC.showAlert()
    }
    
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-200) {
            libraryView.update(for: .album)
            updateBarButtons()
        }
        else {
            libraryView.update(for: .playlist)
            updateBarButtons()
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
    
    
}
