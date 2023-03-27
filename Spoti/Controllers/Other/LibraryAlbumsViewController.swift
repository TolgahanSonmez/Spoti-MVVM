//
//  LibraryAlbumsViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 11.02.2023.
//

import UIKit


class LibraryAlbumsViewController: UIViewController {
    
    var libraryAlbums = [Album]()
    
    private var observer: NSObjectProtocol?
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView : UITableView = {
        let abc = UITableView(frame : .zero, style: .grouped)
        abc.backgroundColor = .systemBackground
        abc.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        abc.isHidden = true
        return abc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        fetchData()
        setUpNoAlbumsView()
        
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()
            }
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    func setUpNoAlbumsView() {
        
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(viewModel: ActionLabelViewViewModel(
            text: "Henüz herhangi bir albüm kaydetmediniz.",
            actionTitle: "Gözat"))
        
        
    }
    private func fetchData() {
        
        APICaller.shared.getCurrentUsersAlbum { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.libraryAlbums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
   
    private func updateUI() {
        if libraryAlbums.isEmpty {
            // Show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // Show table
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }

}

extension LibraryAlbumsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryAlbums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = libraryAlbums[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                                                       for: indexPath) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
        
        let viewModel = SearchResultSubtitleTableViewCellViewModel(title: result.name,
                                                                   subtitle: result.artists.first?.name ?? " ",
                                                                   imageURL: URL(string: result.images.first?.url ?? " "))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let albums = libraryAlbums[indexPath.row]
        let vc = AlbumViewController(album: albums)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            self.libraryAlbums.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()

            }
    }
}

extension LibraryAlbumsViewController: ActionLAbelViewDelegate {
    func actionLabelDidTapButton(_ actionView: ActionLabelView) {
            
        tabBarController?.selectedIndex = 1
        }
    
    
    
}
