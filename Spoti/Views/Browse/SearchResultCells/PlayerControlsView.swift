//
//  PlayerControlsView.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 30.12.2022.
//
import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float )
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView)
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    
    func playerControlsViewDidTapPauseButton(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    private var isPlaying = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    
    private let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "This is MySong"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.text = "Drake (feat. Some Other Artist)"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let backButton: UIButton = {
            let button = UIButton()
            button.tintColor = .label
            let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
            button.setImage(image, for: .normal)
            return button
        }()

    private let nextButton: UIButton = {
            let button = UIButton()
            button.tintColor = .label
            let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
            button.setImage(image, for: .normal)
            return button
        }()

    private let playPauseButton: UIButton = {
            let button = UIButton()
            button.tintColor = .label
            let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
            button.setImage(image, for: .normal)
            return button
        }()
    
    private let volumeSlider: UISlider = {
          let slider = UISlider()
          slider.value = 0.5
          return slider
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitle)
        
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        addSubview(backButton)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        
        addSubview(playPauseButton)
        playPauseButton.addTarget(self, action: #selector(didTapPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    @objc func didSlideSlider(_ slide: UISlider){
        
        let value = slide.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc func didTapBack() {
        
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc func didTapForward() {
        delegate?.playerControlsViewDidTapForwardButton(self)
        
    }
    
    @objc func didTapPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPauseButton(self)
        
        let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        playPauseButton.setImage(isPlaying ? pause: play, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: -10, width: width, height: 50)
        subtitle.frame = CGRect(x: 0, y: 20, width: width, height: 50)

        volumeSlider.frame = CGRect(x: 10, y: subtitle.bottom+10, width: width-20, height: 44)

        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    func configure(viewModel: PlayerControlsViewViewModel) {
        
        nameLabel.text = viewModel.title
        subtitle.text = viewModel.subtitle
        
    }
    
    
}
