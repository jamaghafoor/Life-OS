//
//  PlayerViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import UIKit
import SwiftUI
import AVFAudio
import Alamofire

class PlayerViewModel : BaseViewModel {
    
    @AppStorage(SessionKeys.isPro) var isPros = false
    @AppStorage(SessionKeys.selectedTime) var selectedTime = 0.0
    @AppStorage(SessionKeys.isTimerOn) var isTimerOn = false
    @Published var timerTime : Double = 0.0
    let playerManager = AQPlayerManager.shared
    //    var playeritems: [AQPlayerItemInfo] = []
    var isPlaying = false
    var currentItem : AQPlayerItemInfo?
    var currentTime = "00:00"
    var duration = "00:00"
    var skipInterval = 10
    var show = false
    @Published var isFav = false
    var isQueueListOn = false
    var isInApi = false
    @Published var percentage = 0.0
    @Published var isEditing = false
    @Published var isPlayerView = false
    @Published var isIncreasePlay = 0
    @Published var isShowPlayerTime = false
    @Published var isAlreadyStartTimer = false
    var timer: Timer?
    
    static public let shared = PlayerViewModel()
    
    override init() {
        super.init()
        playerManager.delegate = self
        playerManager.setCommandCenterMode(mode: .nextprev)
        playerManager.skipIntervalInSeconds = Double(skipInterval)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func startTimer() {
        //        if !self.isPlayerView {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isPlaying && self.isTimerOn && !self.isEditing {
                self.isShowPlayerTime = true
                self.isAlreadyStartTimer = true
                if self.timerTime > 0.0 {
                    if self.isTimerOn {
                        self.timerTime -= 1
                    }
                    print(self.timerTime)
                } else {
                    self.pause()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isShowPlayerTime = false
                        self.timerTime = self.selectedTime
                    }
                }
            }
        }
        timer?.fire()
        //        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.isAlreadyStartTimer = false
    }
    
    @objc func timerFired() {
        print("Timer fired!")
    }
    
    func setSongs(sounds: [Sound], index: Int) {
        if !isPros {
            if sounds[index].type == 1 {
                SplashScreenViewModel.shared.isShowSubscriptionDialog = true
                return
            }
        }
        
        if playerManager.currentItemInfo != nil {
            if playerManager.currentItemInfo?.id == sounds[index].id {
                return
            }
        }
        
        let songs = sounds.map({$0.toAQPlayerItem()})
        playerManager.setup(with: songs,startFrom: index)
        currentItem = playerManager.currentItemInfo
        duration = stringFromTimeInterval(interval: playerManager.duration)
        play()
    }
    
    func play() {
        isPlaying = true
        show = true
        playerManager.play()
    }
    
    func pause() {
        show = true
        isPlaying = false
        playerManager.pause()
    }
    
    func playPause() {
        isPlaying ? pause() : play()
        reset()
    }
    
    func skipForward() {
        playerManager.skipForward()
    }
    
    func skipBackward() {
        playerManager.skipBackward()
    }
    
    func previous() {
        withAnimation {
            playerManager.previous()
        }
    }
    
    func next() {
        withAnimation {
            playerManager.next()
        }
    }
    
    func playSeek() {
        playerManager.seek(toPercent: self.percentage)
        reset()
    }
    
    func changePlaybackRate(rate: Float) {
        playerManager.rate = rate
        playerManager.play()
    }
    
    func shuffleToggle() {
        dummy.toggle()
        playerManager.isSuffle.toggle()
    }
    
    func stringFromTimeInterval(interval: TimeInterval,timer: Bool = false) -> String {
        
        if interval.isNaN {
            return ""
        }
        
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if !timer {
            if hours > 0 {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            }
        } else {
            if hours > 0 {
                return String("\(hours)h \(minutes)m \(seconds)s")
            } else {
                return String("\(minutes)m \(seconds)s")
            }
        }
    }
    
    func sliderScroll() {
        if isEditing {
            currentTime = stringFromTimeInterval(interval: playerManager.duration * percentage)
            reset()
        }
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            // Interruption began, take appropriate actions (save state, update user interface)
            self.pause()
        } else if type == .ended {
            guard let optionsValue =
                    info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption Ended - playback should resume
                self.play()
            }
        }
    }
    
}

extension PlayerViewModel : AQPlayerDelegate {
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, progressDidUpdate percentage: Double) {
        if self.isPlayerView {
            if !isEditing {
                DispatchQueue.main.async {
                    self.percentage = percentage
                }
            }
        }
        let current = playerManager.currentTime
        self.duration = stringFromTimeInterval(interval: playerManager.duration)
        if !isEditing {
            self.currentTime = stringFromTimeInterval(interval: current)
        }
        if current > 1 {
            self.increasePlaysSound()
        }
        
        DispatchQueue.main.async {
            
        }
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, itemDidChange itemIndex: Int) {
        isIncreasePlay = 0
        isPlaying = true
        self.currentItem = playerManager.currentItemInfo
        checkIsFav()
        self.reset()
    }
    
    func aQPlayerManager(_ playerManager: AQPlayerManager, statusDidChange status: AQPlayerStatus) {
        switch status {
        case .none:
            isPlaying = false
        case .loading:
            isLoading = true
            isPlaying = false
        case .failed:
            isPlaying = false
        case .readyToPlay:
            isPlaying = false
        case .playing:
            DispatchQueue.main.async {
                self.isLoading = false
            }
            isPlaying = true
        case .paused:
            isPlaying = false
        }
    }
    
    func getCoverImage(_ player: AQPlayerManager, _ callBack: @escaping (UIImage?) -> Void) {
    }
}

extension PlayerViewModel {
    
    func checkIsFav()  {
        isFav = SessionManager.shared.separateMusicId().contains(where: {$0 == currentItem?.id})
    }
    
    func favouriteToggle(soundId: Int?) {
        isFav ? makeUnfavourite(soundId: soundId) : makeFavourite(soundId: soundId)
    }
    
    func makeFavourite(soundId: Int?) {
        
        var ids = SessionManager.shared.separateMusicId()
        ids.append(soundId ?? 0)
        editFavData(soundIds: ids)
        checkIsFav()
        dummy.toggle()
    }
    
    func makeUnfavourite(soundId: Int?) {
        var ids = SessionManager.shared.separateMusicId()
        ids.removeAll(where: { $0 ==  soundId})
        editFavData(soundIds: ids)
        checkIsFav()
        dummy.toggle()
    }
    
    func editFavData(soundIds: [Int]) {
        startLoading()
        let idsInSring = soundIds.map({ "\($0)" }).joined(separator: ",")
        var user = SessionManager.shared.getUser()
        user.likedMusicIDS = idsInSring
        SessionManager.shared.setUser(datum: user)
        
        NetworkManager.callWebServiceWithFiles(url: .editprofile,params: [.user_id: SessionManager.shared.getUser().id ?? 0, .liked_music_ids : idsInSring]) {(obj: RegisterUserModel) in
            self.stopLoading()
            if let data = obj.data{
                SessionManager.shared.setUser(datum: data)
            }
        }
    }
}

extension PlayerViewModel {
    
    func increasePlaysSound() {
      
        if isIncreasePlay == 0 {
            isIncreasePlay += 1
            NetworkManager.callWebService(url: .playSound,params: [.musicId: currentItem?.id ?? 0]) { (obj: SoundModel) in
                if let data = obj.data {
                    if let index = SplashScreenViewModel.shared.allSounds.firstIndex(where: { $0.id == self.currentItem?.id }) {
                        SplashScreenViewModel.shared.allSounds[index].plays = data.plays
                    }
                }
            }
        }
    }
}
