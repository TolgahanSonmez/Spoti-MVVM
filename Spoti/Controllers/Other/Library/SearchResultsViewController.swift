//
//  SearchResultsViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 28.09.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate : AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    weak var delegate : SearchResultsViewControllerDelegate?
    
    struct SearchSection  {
        let title : String
        let results : [SearchResult]
    }
    
    private var sections: [SearchSection] = []
    
    private let tableView : UITableView = {
        let abc = UITableView(frame : .zero, style: .grouped)
        abc.backgroundColor = .systemBackground
        abc.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identfier)
        abc.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        return abc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results : [SearchResult])
    {
        let artists = results.filter({
            switch $0{
            case .artist : return true
            default : return false
            }
        })
        
        let albums = results.filter({
            switch $0{
            case .album : return true
            default : return false
            }
        })
        
        let tracks = results.filter({
            switch $0{
            case .track : return true
            default : return false
            }
        })
        
        let playlists = results.filter({
            switch $0{
            case .playlist: return true
            default : return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Playlist", results: playlists),
            SearchSection(title: "Album", results: albums),
            SearchSection(title : "Artists", results: artists)
        ]
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]

        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: album.name,
                imageURL: URL(string: album.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel (
                title: track.name,
                subtitle: track.artists.first?.name ?? "-",
                imageURL: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
            delegate?.didTapResult(result)
        }
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
   
    
   

}
