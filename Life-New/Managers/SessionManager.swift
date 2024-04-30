//
//  SessionManager.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 06/01/24.
//

import Foundation

class SessionManager {
    static var shared = SessionManager()
    
    func setSettingData(datum: Setting) {
        do {
            let data = try JSONEncoder().encode(datum)
            let dataString = String(decoding: data, as: UTF8.self)
            setStringValue(value: dataString, key: "setting_data")
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func getSettingData() -> Setting {
        let dataString = getStringValueForKey(key: "setting_data")
        let data = Data(dataString.utf8)
        if let loaded = try? JSONDecoder().decode(Setting.self, from: data) {
            return loaded
        }
        return Setting(id: 0, appName: "", bannerIDAndroid: "", intersialIDAndroid: "", nativeIDAndroid: "", bannerIDIos: "", intersialIDIos: "", nativeIDIos: "", createdAt: "", updatedAt: "")
    }
    
    
    
    
    func separateMusicId() -> [Int] {
        let favs = getUser().likedMusicIDS ?? ""
        guard !favs.isEmpty else {
            return []
        }
        
        let separateMusicIdString = favs.components(separatedBy: ",")
        var separateMusicIdInt = separateMusicIdString.map { Int($0) ?? 0 }
        separateMusicIdInt = separateMusicIdInt.filter(){$0 != 0}
        return separateMusicIdInt
    }
    
    
//    func removeFromFav(idToRemove: String) {
//        
//        var favs = getFavData().likedMusicIDS ?? ""
//
//
//        var filterId = favs.components(separatedBy: ",")
//        
//        if let indexToRemove = filterId.firstIndex(of: idToRemove) {
//            filterId.remove(at: indexToRemove)
//        }
//        
//        favs = filterId.joined(separator: ",")
//
//        setFavData(datum: favs)
//    }
//    func removeFromFav(id: Int) {
//        var favs = getFavs()
//        favs.removeAll(where: { $0 == id })
//        setFavs(datum: favs)
//    }

//    func addFav(id: String) {
//        var favs = getFavData()
//        var result = favs + "," + id
//        setFavData(datum: favs)
//    }
//    
    func setUser(datum: User){
        do {
            let data = try JSONEncoder().encode(datum)
            let dataString = String(decoding: data, as: UTF8.self)
            setStringValue(value: dataString, key: "user_data")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getUser() -> User {
        let dataString = getStringValueForKey(key: "user_data")
        let data = Data(dataString.utf8)
        if let loaded = try? JSONDecoder().decode(User.self, from: data){
            return loaded
        }
        return User(id: 0, loginType: 0, deviceType: 0, identity: "", fullname: "", image: "", likedMusicIDS: "", deviceToken: "", createdAt: "", updatedAt: "")
    }
    
    func getBooleanValueForKey(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setBooleanValue(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:  String
    func getStringValueForKey(key: String) -> String {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value
        }
        return ""
    }
    
    func setStringValue(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Int
    func getIntegerValueForKey(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func setIntegerValue(value: Int, key: String) {
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Float
    func getFloatValueForKey(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    func setFloatValue(value: Float, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func clear() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
    
}
