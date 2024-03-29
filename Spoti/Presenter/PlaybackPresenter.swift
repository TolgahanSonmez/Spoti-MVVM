//
//  PlaybackPresenter.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 20.12.2022.
//


import AVFoundation
import Foundation
import UIKit

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            
            return track
        }
        
        else if let player = self.playerQueue , !tracks.isEmpty {
            
            return tracks[index]
            
        }
        
        return nil
    }
    
    var playerVC : PlayerViewController?
    
    var player : AVPlayer?
    
    var playerQueue : AVQueuePlayer?
    
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack) {
            
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5

        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    public func startPlayback (
        from viewController: UIViewController,
        tracks: [AudioTrack])
    {
        self.track = nil
        self.tracks = tracks
        
        let vc = PlayerViewController()
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? " ") else {
                return nil}
            
            return AVPlayerItem(url: url)
            
        }))
        
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        
        vc.title = track?.name
        vc.delegate = self
        vc.dataSource = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            
            self?.player?.play()
        }
        
        self.playerVC = vc
        
            
    }
    
    
    
}

extension PlaybackPresenter: PlayertoPresenterDelegate {
   
    func didTapPause() {
        if let player = player{
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }
        else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }
        else if let player = playerQueue {
            player.advanceToNextItem()
            if index > 0 {
                index -= 1
            }
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    /*func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    */
    
    func didSlideSlider(_ value: Float) {
        
        player?.volume = value
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
   
  
    var image: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? " ")
    }
    
    var songName: String? {
        return currentTrack?.name ?? "Unknown Track"
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    
    
}
