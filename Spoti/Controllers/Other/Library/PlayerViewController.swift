//
//  PlayerViewController.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 30.12.2022.
//
import SDWebImage
import UIKit

protocol PlayerDataSource: AnyObject {
    
    var songName: String? {get}
    var subTitle: String? {get}
    var image: URL? {get}
}

protocol PlayertoPresenterDelegate: AnyObject {
    
    func didSlideSlider(_ value:Float)
    
    func didTapBackward()
    
    func didTapForward()
    
    func didTapPause()
}

//classlar ref tipinde, structlar ve enumlar değer tipinde, değer türlerinin referansı yoktur.

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    
    weak var delegate: PlayertoPresenterDelegate?
    
    
    private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            return imageView
        }()
    
    private let controlsView = PlayerControlsView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        //iki sayfanın birbiriyle haberleşmesini sağlayan delgate yapısı
        controlsView.delegate = self
        configure()
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(
                  x: 10,
                  y: imageView.bottom+10,
                  width: view.width-20,
                  height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
              )
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.image,completed: nil)
        controlsView.configure(viewModel: PlayerControlsViewViewModel(
            title: dataSource?.songName,
            subtitle: dataSource?.subTitle))
    }
    
    func refreshUI() {
        configure()
    }

}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    
    func playerControlsViewDidTapPauseButton(_ playerControlsView: PlayerControlsView) {
        
        delegate?.didTapPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        
        delegate?.didTapForward()
    }
    
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        
        delegate?.didTapBackward()
        
        
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
       
        delegate?.didSlideSlider(value)
        
    }
    
    
    
}
