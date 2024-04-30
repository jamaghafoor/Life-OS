//
//  TabBarViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import SwiftUI
import RevenueCat

class SplashScreenViewModel : BaseViewModel {
    @Published var allSounds = [Sound]()
    @Published var categories = [Category]()
    @Published var articles = [Article]()
    @Published var quotes = [Quote]()
    @Published var settings : Setting?
    @Published var searchQuery = ""
    @Published var filterdSounds = [Sound]()
    @Published var isDataLoaded = false
    @Published var showLoginSheet: Bool = false
    @Published var isShowSubscriptionDialog: Bool = false
    static var shared = SplashScreenViewModel()
    
    func fetchAllData() {
        if allSounds.isNotEmpty && categories.isNotEmpty && articles.isNotEmpty{
            return
        }
        
        startLoading()
        
        //        NetworkManager.callWebService(url: WebServices.allData) { (obj: AllDataModel) in
        //            self.stopLoading()
        //
        //            let musicsData = obj.musics ?? []
        //            let categoriesData = obj.categories ?? []
        //            let articleData = obj.articles ?? []
        //
        //            //Music
        //            var tempMusicData = [Sound]()
        //            musicsData.forEach { sound in
        //                var sound = sound
        //                sound.category = categoriesData.first(where: { $0.id == sound.categoryID })
        //                tempMusicData.append(sound)
        //            }
        //            self.allSounds = tempMusicData
        //
        //            //Article
        //            var tempArticleData = [Article]()
        //            articleData.forEach { article in
        //                var article = article
        //                article.category = categoriesData.first(where: { $0.id == article.categoryID })
        //                tempArticleData.append(article)
        //            }
        //            self.articles = tempArticleData
        //            self.categories = categoriesData
        //            if let quoteData = obj.quotes {
        //                self.quotes = quoteData
        //            }
        //
        //            if let settingData = obj.settings {
        //                self.settings = settingData
        //                SessionManager.shared.setSettingData(datum: settingData)
        //            }
        //            self.isDataLoaded = true
        //        }
        
        
        NetworkManager.callWebService(url: .fetchAllData) { (obj: AllDataModel) in
          
            if let musicsData = obj.musics,
               let categoriesData = obj.categories,
               let articleData = obj.articles,
               let settingData = obj.settings {
                self.stopLoading()
                //Music
                var tempMusicData = [Sound]()
                musicsData.forEach { sound in
                    var sound = sound
                    sound.category = categoriesData.first(where: { $0.id == sound.categoryID })
                    tempMusicData.append(sound)
                }
                self.allSounds = tempMusicData
                
                //Article
                var tempArticleData = [Article]()
                articleData.forEach { article in
                    var article = article
                    article.category = categoriesData.first(where: { $0.id == article.categoryID })
                    tempArticleData.append(article)
                }
                self.articles = tempArticleData
                self.categories = categoriesData
                if let quoteData = obj.quotes {
                    self.quotes = quoteData
                }
                
                self.settings = settingData
                SessionManager.shared.setSettingData(datum: settingData)
                
                self.isDataLoaded = true
            }
        }
    }
    
    func changOfQuery(word: String) {
        if searchQuery.isEmpty {
            if word == "" {
                self.filterdSounds = allSounds
            }
        } else {
            self.filterdSounds = allSounds.filter({ sound in
                let lowerQuery = word.lowercased()
                return sound.title?.lowercased().contains(lowerQuery) ?? false || sound.category?.title?.lowercased().contains(lowerQuery) ?? false
            })
        }
    }
    
    func getProfile() {

        
        NetworkManager.callWebService(url: .getProfile,params: [.user_id: SessionManager.shared.getUser().id ?? 0]) {(obj: RegisterUserModel) in
            if let data = obj.data {
                SessionManager.shared.setUser(datum: data)
            }
        }
    }
}

