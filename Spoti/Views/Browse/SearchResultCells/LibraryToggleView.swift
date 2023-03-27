//
//  LibraryToggleView.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 11.02.2023.
//

import UIKit


protocol LibraryToggleViewDelegate: AnyObject {
    
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}



class LibraryToggleView: UIView {

    weak var delegate: LibraryToggleViewDelegate?
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)// UIViewden türemiş olan bu classın UIView'in constructorına gelen parametreyi göndermek anlamına gelir.

        addSubview(playlistButton)
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        addSubview(albumsButton)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
        addSubview(indicatorView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    @objc private func didTapPlaylist() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        
        state = .album
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIndicator()
        })
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
   
    
    func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: playlistButton.bottom, width: 100, height: 3)
        }
    }
    
    func update(for state: State)
    {
        self.state = state
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIndicator()
        })
    }
    
}
