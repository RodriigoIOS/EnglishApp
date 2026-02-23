//
//  Language.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

struct Language: Identifiable, Equatable {
    let id: String // ex: "Ingles"
    let name: String // ex: "Ingles (English)"
    let flag: String // ex: "us"
    let nativeName: String // ex: "English"
    
    static let all: [Language] = [
         .init(id: "ingles",    name: "Inglês",    flag: "🇺🇸", nativeName: "English"),
         .init(id: "espanhol",  name: "Espanhol",  flag: "🇪🇸", nativeName: "Español"),
         .init(id: "frances",   name: "Francês",   flag: "🇫🇷", nativeName: "Français"),
         .init(id: "alemao",    name: "Alemão",    flag: "🇩🇪", nativeName: "Deutsch"),
         .init(id: "japones",   name: "Japonês",   flag: "🇯🇵", nativeName: "日本語"),
         .init(id: "italiano",  name: "Italiano",  flag: "🇮🇹", nativeName: "Italiano"),
         .init(id: "chines",    name: "Chinês",    flag: "🇨🇳", nativeName: "中文"),
         .init(id: "coreano",   name: "Coreano",   flag: "🇰🇷", nativeName: "한국어"),
     ]
    
    static var defaultLanguage: Language { all[0] }
}
