//
//  AlbumViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 10.10.2022.
//

import UIKit

class AlbumViewController: UIViewController {


    private let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )

                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    ),
                    subitem: item,
                    count: 1
                )

                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalWidth(1)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            })
        )
    
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    
    private var tracks = [AudioTrack]()
    
    private let album : Album
    //albumviewcontroller yüklenirken constructorına album objesi geliyor
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
            super.viewDidLoad()
            title = album.name
            view.backgroundColor = .systemBackground
            view.addSubview(collectionView)
            collectionView.register(
                AlbumTrackCollectionViewCell.self,
                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier
            )
        
        //collectionView.register(
           // PlaylistHeaderCollectionReusableView.self,
         //   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
          //  withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
      //  )
            collectionView.backgroundColor = .systemBackground
           // collectionView.delegate = self
           // collectionView.dataSource = self
            
        
        //AlbumDetailsVerileriniÇekme
        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(name: $0.name,
                                                         artistName: $0.artists.first?.name ?? " ")
                    })
                    self?.collectionView.reloadData()
                    
                    
                case .failure(let error): print(error.localizedDescription)
                    
                }
                
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                    target: self,
                                                                    action: #selector(didTapActions))
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    @objc func didTapActions() {
            let actionSheet = UIAlertController(title: album.name, message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
            
            }))

            present(actionSheet, animated: true)
        }
    
}


