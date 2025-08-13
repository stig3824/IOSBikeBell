import AVFoundation
import UIKit

enum BellType: String, CaseIterable {
    case regular = "Regular Bell"
    case cow = "Cow Bell"
    
    var soundFileName: String {
        switch self {
        case .regular: return "bike_bell"
        case .cow: return "cowbell"
        }
    }
    
    var fileExtension: String {
        return "m4a"
    }
}

enum SoundManagerError: Error, LocalizedError {
    case audioSessionSetupFailed
    case soundFileNotFound
    case playerCreationFailed
    case playbackFailed
    
    var errorDescription: String? {
        switch self {
        case .audioSessionSetupFailed:
            return "Failed to set up audio session"
        case .soundFileNotFound:
            return "Sound file not found"
        case .playerCreationFailed:
            return "Failed to create audio player"
        case .playbackFailed:
            return "Failed to play sound"
        }
    }
}

class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var soundURLs: [BellType: URL] = [:]
    private var activePlayers: [AVAudioPlayer] = []
    @Published var currentBellType: BellType = .regular
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        setupAudio()
        setupSoundURLs()
    }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            errorMessage = "Failed to set up audio session: \(error.localizedDescription)"
        }
    }
    
    private func setupSoundURLs() {
        for bellType in BellType.allCases {
            if let url = Bundle.main.url(forResource: bellType.soundFileName, withExtension: bellType.fileExtension) {
                soundURLs[bellType] = url
            } else {
                errorMessage = "Could not find sound file for \(bellType.rawValue)"
            }
        }
    }
    
    func playBell(intensity: Double) throws {
        try playCustomBell(intensity: intensity)
    }
    
    private func playCustomBell(intensity: Double) throws {
        guard let url = soundURLs[currentBellType] else {
            throw SoundManagerError.soundFileNotFound
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = Float(min(intensity * 2, 1.0))
            player.delegate = self
            
            // Clean up finished players before adding new one
            cleanupFinishedPlayers()
            
            // Add to active players before playing
            activePlayers.append(player)
            
            if !player.play() {
                throw SoundManagerError.playbackFailed
            }
        } catch {
            if error is SoundManagerError {
                throw error
            } else {
                throw SoundManagerError.playerCreationFailed
            }
        }
    }
    
    private func cleanupFinishedPlayers() {
        activePlayers.removeAll { !$0.isPlaying }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        cleanupFinishedPlayers()
    }
} 