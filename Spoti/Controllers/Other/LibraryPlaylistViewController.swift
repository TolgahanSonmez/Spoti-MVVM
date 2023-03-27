//
//  LibraryPlaylistViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 11.02.2023.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    var libraryPlaylist = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let noPlaylistView = ActionLabelView()
    private let refreshPlaylist = LibraryAlbumsViewController()
    
    private let tableView : UITableView = {
        let abc = UITableView(frame : .zero, style: .grouped)
        abc.backgroundColor = .systemBackground
        abc.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        abc.isHidden = true
        return abc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        setUpNoPlaylistView()
        
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    
    @objc func didTapClose() {
        dismiss(animated: true,completion: nil)
    }
    
    private func updateUI() {
        if libraryPlaylist.isEmpty {
            // Show label
            noPlaylistView.isHidden = false
            tableView.isHidden = true
            
            
        }
        else {
            // Show table
            tableView.reloadData()
            noPlaylistView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setUpNoPlaylistView() {
        view.addSubview(noPlaylistView)
        noPlaylistView.delegate = self
        noPlaylistView.configure(
            viewModel: ActionLabelViewViewModel(
                text: "Henüz oynatma listeniz yok.",
                actionTitle: "Oluştur"
            )
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistView.center = view.center
        
    }
    
    func fetchData() {
        APICaller.shared.getUsersPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self?.libraryPlaylist = result
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Yeni Oynatma Listelesi Oluştur",
                                      message: "Oynatma listesi adını girin",
                                      preferredStyle: .alert
        )
        alert.addTextField { texfield in
            texfield.placeholder = "Çalma Listesi..."
        }
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Oluştur", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                    let text = field.text,
                    !text.trimmingCharacters(in: .whitespaces).isEmpty else { return
                
            }
            APICaller.shared.createPlaylist2(with: text) { [weak self] result in
                switch result {
                case true:
                    self?.fetchData()
                case false:
                    print("oynatma listesi oluşturulamadı")
                }
            }
            
            
        }))

            present(alert, animated: true)
        
    }
}

extension LibraryPlaylistViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryPlaylist.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = libraryPlaylist[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identfier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return  UITableViewCell()
        }
        
        let viewModel = SearchResultSubtitleTableViewCellViewModel (
            title: result.name,
            subtitle: result.owner.display_name,
            imageURL: URL(string: result.images.first?.url ?? " ")
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = libraryPlaylist[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true,completion: nil)
            return
        }
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


extension LibraryPlaylistViewController: ActionLAbelViewDelegate {
    func actionLabelDidTapButton(_ actionView: ActionLabelView) {
        showAlert()
    }
    
    
}
