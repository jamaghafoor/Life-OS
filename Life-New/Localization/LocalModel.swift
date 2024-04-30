//
//  LocalModel.swift
//  Translate it
//
//  Created by iMac on 01/09/21.
//

import Foundation
enum Language: String {
    case Arabic = "ar"
	case Chinese = "zh-Hans"
	case English = "en"
	case Danish = "da"
	case Dutch = "nl"
	case French = "fr"
    case German = "de"
	case Greek = "el"
	case Hindi = "hi"
	case Indonesian = "id"
	case Italian = "it"
	case Japanese = "ja"
	case Korean = "ko"
	case Norwegian = "no"
	case Polish = "pl"
	case Portuguese = "pt"
	case Russian = "ru"
	case Spanish = "es"
	case Swedish = "sv"
	case Thai = "th"
	case Turkish = "tr"
	case Vietnamese = "vi"
}

extension String {
	func localized(_ language: Language) -> String {
		let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
		let bundle: Bundle
		if let path = path {
			bundle = Bundle(path: path) ?? .main
		} else {
			bundle = .main
		}
		return localized(bundle: bundle)
	}

	func localized(_ language: Language, args arguments: CVarArg...) -> String {
		let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
		let bundle: Bundle
		if let path = path {
			bundle = Bundle(path: path) ?? .main
		} else {
			bundle = .main
		}
		return String(format: localized(bundle: bundle), arguments: arguments)
	}

	private func localized(bundle: Bundle) -> String {
		return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
	}
}

class LocalizationService {

	static let shared = LocalizationService()
	static let changedLanguage = Notification.Name("changedLanguage")

	private init() {}
	
	var language: Language {
		get {
			guard let languageString = UserDefaults.standard.string(forKey: "language") else {
				return .English
			}
			return Language(rawValue: languageString) ?? .English
		} set {
			if newValue != language {
				UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
				NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
			}
		}
	}
}
