//
//  VideoManager.swift
//  FocusFlow
//
//  Created by SLC Anggrek - Kemanggisan on 31/12/25.
//

import AVKit

class VideoManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isLoading: Bool = false

    var onVideoEnd: (() -> Void)?

    func loadVideo(named fileName: String) {
        isLoading = true

        if let videoURL = Bundle.main.url(forResource: fileName, withExtension: "mp4") {
            player = AVPlayer(url: videoURL)

            if !UserDefaults.standard.bool(forKey: "soundEnabled") {
                player?.isMuted = true
            }

            isLoading = false
            setupEndObserver()
            player?.play()
        } else {
            isLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.onVideoEnd?()
            }
        }
    }

    func setupEndObserver() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.onVideoEnd?()
        }
    }

    func updateSoundSettings() {
        player?.isMuted = !UserDefaults.standard.bool(forKey: "soundEnabled")
    }

    func cleanup() {
        player?.pause()
        player = nil
    }
}
