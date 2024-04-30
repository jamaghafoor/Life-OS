//
//  AAPlayerManager.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import SwiftUI
import CoreMedia

import AVFoundation
import MediaPlayer

public final class AQPlayerManager: NSObject {
    @Published var dummy = false
    @AppStorage(SessionKeys.isPro) var isPro = false
    
    static public let shared = AQPlayerManager()
    
    public enum PlayerMode {
        case none, repeate, repeatAll
    }
    
    @Published var playerMode: PlayerMode = PlayerMode.repeatAll
    
    public var delegate: AQPlayerDelegate?
    
    fileprivate let commandCenter = MPRemoteCommandCenter.shared()
    fileprivate var qPlayer: AVPlayer?
    var qPlayerItems: [AQPlayerItemInfo] = []
    fileprivate var timer: Timer?
    fileprivate var isSessionSetup = false
    
    public var playerStatus: AQPlayerStatus {
        return self.status
    }
    
    
    public var playbackRates: [Float] = D.playbackRates
    public var rate: Float = 1
    public var skipIntervalInSeconds = D.skipIntervalInSeconds {
        didSet {
            self.commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: self.skipIntervalInSeconds)]
            self.commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: self.skipIntervalInSeconds)]
        }
    }
    
    fileprivate var status: AQPlayerStatus = .none {
        didSet {
            self.delegate?.aQPlayerManager(self, statusDidChange: status)
        }
    }
    
    public var currentItemInfo: AQPlayerItemInfo? {
        if qPlayerItems.count <= currentIndex {
            return nil
        }
        return qPlayerItems[currentIndex]
    }
    
    public var currentItemIndex: Int {
        return (self.qPlayer?.currentItem as? AQPlayerItem)?.index ?? -1
    }
    
    public var currentTime: TimeInterval {
        return self.qPlayer?.currentItem?.currentTime().seconds ?? 0
    }
    
    public var duration: TimeInterval {
        return self.qPlayer?.currentItem?.asset.duration.seconds ?? 0
    }
    
    public var percentage: Double {
        guard let duration = qPlayer?.currentItem?.asset.duration else {
            return 0.0
        }
        
        let currentTime = self.qPlayer?.currentTime() ?? .zero
        return currentTime.seconds / duration.seconds
    }
    
    public var isSuffle = false
    public var currentIndex = 0
    
    public override init() {
        super.init()
        self.setupAudioSession()
        self.setupRemoteControl()
    }
    
    deinit {
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.clean()
    }
    
    public func clean() {
        qPlayer?.pause()
        qPlayer = nil
        qPlayerItems.removeAll()
    }
    
    public func resetModeAndShuffle() {
        isSuffle = false
    }
    
    public func setup(with items: [AQPlayerItemInfo], startFrom: Int = 0, playAfterSetup: Bool = false) {
        self.clean()
        self.qPlayerItems = items
        self.status = .loading
        goTo(startFrom,shouldPlay: true)
    }
    
    public func setCommandCenterMode(mode: AQRemoteControlMode) {
        commandCenter.skipBackwardCommand.isEnabled = mode == .skip
        commandCenter.skipForwardCommand.isEnabled = mode == .skip
        
        commandCenter.nextTrackCommand.isEnabled = mode == .nextprev
        commandCenter.previousTrackCommand.isEnabled = mode == .nextprev
        
        commandCenter.seekForwardCommand.isEnabled = false
        commandCenter.seekBackwardCommand.isEnabled = false
        commandCenter.changePlaybackRateCommand.isEnabled = false
    }
    
    fileprivate func setupAudioSession() {
        // activate audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            isSessionSetup = true
        } catch {
            print("Activate AVAudioSession failed.")
        }
    }
    
    @objc fileprivate func updateProgress() {

        guard let delegate = self.delegate else {
            return
        }
        
        guard let duration = qPlayer?.currentItem?.asset.duration else {
            return
        }
        
        if self.status != .playing, qPlayer?.status == .readyToPlay, qPlayer?.rate ?? 0 > 0 {
            self.status = .playing
        }
        
        let currentTime = self.qPlayer?.currentTime() ?? .zero
        let percentage = currentTime.seconds / duration.seconds
        delegate.aQPlayerManager(self, progressDidUpdate: percentage)
        updateNowPlaying()
    }
//    

    fileprivate func updateNowPlaying(time: TimeInterval? = nil) {
        guard self.duration > 0.0 else {
            return
        }
        
        var nowPlayingInfo:[String: Any]? = MPNowPlayingInfoCenter.default().nowPlayingInfo
        if nowPlayingInfo == nil {
            nowPlayingInfo = [String: Any]()
        }
        
        guard let item = self.currentItemInfo else {
            return
        }
        
        // init metadata
        nowPlayingInfo?[MPMediaItemPropertyTitle] = item.title
        nowPlayingInfo?[MPMediaItemPropertyArtist] = item.albumTitle
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = (time == nil) ? self.qPlayer?.currentTime().seconds ?? 0 : time
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = self.duration
        nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = self.qPlayer?.rate ?? 0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        self.updateMediaItemArtwork()
    }
    
    var mpMediaItemArtowork : MPMediaItemArtwork?
    
    fileprivate func updateMediaItemArtwork() {
        // set cover image
        if let item = self.currentItemInfo, let image = item.coverImage {
            if mpMediaItemArtowork == nil {
                mpMediaItemArtowork = MPMediaItemArtwork(boundsSize: image.size) { size in return image }
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = mpMediaItemArtowork
            }
        } else {
            self.delegate?.getCoverImage(self, { (coverImage) in
                if let image = coverImage {
                    MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in return image }
                }
            })
        }
    }
}

// MARK: Audio control methods
extension AQPlayerManager {
    public func playOrPause() -> AQPlayerStatus {
        guard qPlayer != nil, qPlayer?.currentItem != nil else {
            return .none
        }
        switch self.status {
        case .loading, .none:
            return .loading
        case .failed:
            return .failed
            
        case .readyToPlay, .paused:
            self.play()
            return .playing
        case .playing:
            self.pause()
            return.paused
        }
    }
    
    public func play() {
        if !isSessionSetup {
            setupAudioSession()
        }
        
        self.qPlayer?.playImmediately(atRate: self.rate)
        self.status = .playing
        self.updateProgress()
        
        if self.timer == nil {
            self.timer = Timer(timeInterval: D.progressTimerInterval, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .common)
        }
    }
    
    public func pause() {
        guard qPlayer != nil else {
            return
        }
        
        qPlayer?.pause()
        self.status = .paused
        timer?.invalidate()
        timer = nil
        
        updateProgress()
                
    }
    
    public func seek(toPercent: Double) {
        let duration = qPlayer?.currentItem?.duration ?? .zero
        let jumpToSec = duration.seconds * toPercent
        self.seek(toTime: jumpToSec)
    }
    
    public func seek(toTime: TimeInterval) {
        //        var playAfterSeek = false
        //        if self.status == .playing {
        //            self.pause()
        //            playAfterSeek = true
        //        }
        self.status = .loading
        
        self.qPlayer?.seek(to: CMTime(seconds: toTime, preferredTimescale: D.preferredTimescale) , completionHandler: { (value) in
            
            self.play()
      
        })
    }
    
        public func next(shouldMinus: Bool = false) {
            guard qPlayer != nil else {
                return
            }
            self.status = .loading
            let index = currentIndex
            let newIndex = (index + 1) % self.qPlayerItems.count
            if self.qPlayerItems[newIndex].type == 1 && !isPro {
                currentIndex = newIndex
                next()
                return
            }
            goTo(newIndex)
        }
    
        public func previous() {
            guard qPlayer != nil else {
                return
            }
            let index = currentIndex
            var  newIndex = index - 1
            if newIndex == -1 {
                newIndex = self.qPlayerItems.count - 1
            }
            if self.qPlayerItems[newIndex].type == 1 && !isPro {
                currentIndex = newIndex
                previous()
                return
            }
            self.goTo(newIndex)
        }
    
    
    public func goTo(_ index: Int, shouldPlay: Bool = false) {
        guard index >= 0, index < self.qPlayerItems.count else {
            return
        }
        self.status = .loading
        self.qPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: D.preferredTimescale) , completionHandler: { (value) in
        })
        self.pause()
        self.updateProgress()
        self.status = .loading
        currentIndex = index
        self.delegate?.aQPlayerManager(self, itemDidChange: index)
        mpMediaItemArtowork = nil
        if let url = qPlayerItems[index].url {
            let asset = AVURLAsset(url: url)
            asset.loadValuesAsynchronously(forKeys: ["playable"]) { [self] in
                qPlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                qPlayer?.automaticallyWaitsToMinimizeStalling = false
                self.play()
                NotificationCenter.default.addObserver(self, selector: #selector(onPlayerEnd),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: qPlayer?.currentItem)
            }
        }
    }
    
    @objc func onPlayerEnd() {
        NotificationCenter.default.removeObserver(self)
        //        next()
        if playerMode == .none{
            if currentIndex != qPlayerItems.count - 1 {
                next()
            } else {
                self.pause()
            }
            
        } else if playerMode == .repeate {
            
            self.goTo(currentIndex)
            
        } else {
            next()
        }
    }
    
    public func skipForward() {
        self.pause()
        let currentTime = self.qPlayer?.currentTime() ?? .zero
        var jumpToSec = currentTime + CMTime(seconds: self.skipIntervalInSeconds, preferredTimescale: D.preferredTimescale) // dalta
        let duration = qPlayer?.currentItem?.duration ?? .zero
        
        if jumpToSec > duration {
            jumpToSec = duration
        }
        
        guard jumpToSec >= .zero else {
            return
        }
        
        self.qPlayer?.seek(to: jumpToSec, completionHandler: { (value) in
            self.play()
        })
    }
    
    public func skipBackward() {
        self.pause()
        let currentTime = self.qPlayer?.currentTime() ?? .zero
        var jumpToSec = currentTime - CMTime(seconds: self.skipIntervalInSeconds, preferredTimescale: D.preferredTimescale) // dalta
        let duration = qPlayer?.currentItem?.duration ?? .zero
        
        if jumpToSec < .zero {
            jumpToSec = duration
        }
        
        guard jumpToSec >= .zero else {
            return
        }
        
        self.qPlayer?.seek(to: jumpToSec, completionHandler: { (value) in
            self.play()
        })
    }
    
    public func changeToNextRate() -> Float {
        guard let index = self.playbackRates.lastIndex(of: self.rate) else {
            self.rate = 1.0
            return 1.0
        }
        
        var newRateIndex = index + 1
        if newRateIndex == playbackRates.count {
            newRateIndex = 0
        }
        
        self.rate = self.playbackRates[newRateIndex]
        self.qPlayer?.rate = self.rate
        
        return self.rate
    }
    
    public func changeToNextRepeatMode() {
        //        repeatMode = repeatMode.next()
    }
}

// Remote Control Setup
extension AQPlayerManager {
    fileprivate func setupRemoteControl() {
        
        self.setCommandCenterMode(mode: D.commandCenterMode)
        
        // MARK: Remote Commands handlers
        
        // play , pause , stop
        commandCenter.togglePlayPauseCommand.addTarget(handler: {[weak self]  (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("togglePlayPauseCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            if strongSelf.playOrPause() != .none {
                return .success
            } else {
                return .commandFailed
            }
        })
        commandCenter.playCommand.addTarget { [weak self] event in
            //debugPrint("playCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.play()
            return checkSatatus(strongSelf)
        }
        commandCenter.pauseCommand.addTarget { [weak self] event in
            //debugPrint("pauseCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.pause()
            return checkSatatus(strongSelf)
        }
        commandCenter.stopCommand.addTarget(handler: {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("stopCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.pause()
            return checkSatatus(strongSelf)
        })
        
        // next , prev
        commandCenter.nextTrackCommand.addTarget( handler: {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("nextTrackCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.next()
            return checkSatatus(strongSelf)
        })
        commandCenter.previousTrackCommand.addTarget( handler: {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("previousTrackCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.previous()
            return checkSatatus(strongSelf)
        })
        
        // seek fwd , seek bwd
        commandCenter.seekForwardCommand.addTarget(handler: { (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("seekForwardCommand")
            //            guard let strongSelf = self else {return .commandFailed}
            
//            debugPrint("Seek forward ")
            return .commandFailed
        })
        commandCenter.seekBackwardCommand.addTarget(handler: { (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("seekBackwardCommand")
            //            guard let strongSelf = self else {return .commandFailed}
            
//            debugPrint("Seek backward ")
//            print("dfgwfgwe")
            return .commandFailed
        })
        
        // skip fwd , skip bwd
        commandCenter.skipForwardCommand.addTarget(handler: {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("skipForwardCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.skipForward()
            return checkSatatus(strongSelf)
        })
        commandCenter.skipBackwardCommand.addTarget(handler: {[weak self] (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("skipBackwardCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            strongSelf.skipBackward()
            return checkSatatus(strongSelf)
        })
        
        // playback rate
        commandCenter.changePlaybackRateCommand.addTarget(handler: { (_) -> MPRemoteCommandHandlerStatus in
            //debugPrint("changePlaybackRateCommand")
            //            guard let strongSelf = self else {return .commandFailed}
            
            //debugPrint("Change Rate ")
            return .commandFailed
        })
        
        // seek to position
        commandCenter.changePlaybackPositionCommand.addTarget(handler: {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            //debugPrint("changePlaybackPositionCommand")
            guard let strongSelf = self else {return .commandFailed}
            
            //   var playAfterSeek = strongSelf.status == .playing
            // strongSelf.pause()
            let e = event as! MPChangePlaybackPositionCommandEvent
            strongSelf.updateNowPlaying(time: e.positionTime)
            strongSelf.seek(toTime: e.positionTime)
            
            print("change")
            return checkSatatus(strongSelf)

        })
        
        // check status and return MPRemoteCommandHandlerStatus
        func checkSatatus(_ strongSelf: AQPlayerManager) -> MPRemoteCommandHandlerStatus {
            if strongSelf.status != .none {
                return .success
            } else {
                return .commandFailed
            }
        }
        
        // Enters Background
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil, using: {[weak self] (_) in
            //debugPrint("willResignActiveNotification")
            guard let strongSelf = self else {return}
            
            strongSelf.updateNowPlaying()
        })
    }
}

public enum AQRemoteControlMode {
    case skip
    case nextprev
}

// default config values

final class D {
    static let progressTimerInterval: TimeInterval = 0.1
    static let preferredTimescale: CMTimeScale = 1000
    static let skipIntervalInSeconds: TimeInterval = 15.0
    static let playbackRates: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
    static let commandCenterMode = AQRemoteControlMode.skip
}


