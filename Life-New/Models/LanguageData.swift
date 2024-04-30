//
//  HomeCategoryItem.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import Foundation

struct AppLanguage: Hashable{
    let LocalName: String
    let englishName: String
    let languageCode: Language
}

let languages = [
    AppLanguage(LocalName: "العربية", englishName: "Arabic",languageCode: .Arabic),
    AppLanguage(LocalName: "中文", englishName: "Chinese",languageCode: .Chinese),
    AppLanguage(LocalName: "English", englishName: "English",languageCode: .English),
    AppLanguage(LocalName: "dansk", englishName: "Danish",languageCode: .Danish),
    AppLanguage(LocalName: "Nederlands", englishName: "Dutch",languageCode: .Dutch),
    AppLanguage(LocalName: "Français", englishName: "French",languageCode: .French),
    AppLanguage(LocalName: "Deutsch", englishName: "German",languageCode: .German),
    AppLanguage(LocalName: "Ελληνικά", englishName: "Greek",languageCode: .Greek),
    AppLanguage(LocalName: "हिंदी", englishName: "Hindi",languageCode: .Hindi),
    AppLanguage(LocalName: "bahasa Indonesia", englishName: "Indonesian",languageCode: .Indonesian),
    AppLanguage(LocalName: "Italiana", englishName: "Italian",languageCode: .Italian),
    AppLanguage(LocalName: "日本語", englishName: "Japanese",languageCode: .Japanese),
    AppLanguage(LocalName: "한국인", englishName: "korean",languageCode: .Korean),
    AppLanguage(LocalName: "norsk", englishName: "Norwegian",languageCode: .Norwegian),
    AppLanguage(LocalName: "Polski", englishName: "Polish",languageCode: .Polish),
    AppLanguage(LocalName: "Português", englishName: "Portuguese",languageCode: .Portuguese),
    AppLanguage(LocalName: "Русский", englishName: "Russian",languageCode: .Russian),
    AppLanguage(LocalName: "Española", englishName: "Spanish",languageCode: .Spanish),
    AppLanguage(LocalName: "svenska", englishName: "Swedish",languageCode: .Swedish),
    AppLanguage(LocalName: "แบบไทย", englishName: "Thai",languageCode: .Thai),
    AppLanguage(LocalName: "Türkçe", englishName: "Turkish",languageCode: .Turkish),
    AppLanguage(LocalName: "Tiếng Việt", englishName: "Vietnamese",languageCode: .Vietnamese),
]

let times = [
    60.0,
    120.0,
    300.0,
    600.0,
    1200.0,
]
