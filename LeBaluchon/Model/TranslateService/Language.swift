//
//  Language.swift
//  LeBaluchon
//
//  Created by Yann Rouzaud on 20/04/2022.
//

import Foundation

enum Language: String, CaseIterable {
    case af
    case ga
    case sq
    case it
    case ar
    case ja
    case az
    case kn
    case eu
    case ko
    case bn
    case la
    case be
    case lv
    case bg
    case lt
    case ca
    case mk
    case zhCN = "zh-CN"
    case ms
    case zhTW = "zh-TW"
    case mt
    case hr
    case no
    case cs
    case fa
    case da
    case pl
    case nl
    case pt
    case en
    case ro
    case eo
    case ru
    case et
    case sr
    case tl
    case sk
    case fi
    case sl
    case fr
    case es
    case gl
    case sw
    case ka
    case sv
    case de
    case ta
    case el
    case te
    case gu
    case th
    case ht
    case tr
    case iw
    case uk
    case hi
    case ur
    case hu
    case vi
    case `is`
    case cy
    case id
    case yi
    
    var name: String {
        switch self {
        case .af: return "Afrikaans"
        case .ga: return "Irish"
        case .sq: return "Albanian"
        case .it: return "Italian"
        case .ar: return "Arabic"
        case .ja: return "Japanese"
        case .az: return "Azerbaijani"
        case .kn: return "Kannada"
        case .eu: return "Basque"
        case .ko: return "Korean"
        case .bn: return "Bengali"
        case .la: return "Latin"
        case .be: return "Belarusian"
        case .lv: return "Latvian"
        case .bg: return "Bulgarian"
        case .lt: return "Lithuanian"
        case .ca: return "Catalan"
        case .mk: return "Macedonian"
        case .zhCN: return "Chinese Simplified"
        case .ms: return "Malay"
        case .zhTW: return "Chinese Traditional"
        case .mt: return "Maltese"
        case .hr: return "Croatian"
        case .no: return "Norwegian"
        case .cs: return "Czech"
        case .fa: return "Persian"
        case .da: return "Danish"
        case .pl: return "Polish"
        case .nl: return "Dutch"
        case .pt: return "Portuguese"
        case .en: return "English"
        case .ro: return "Romanian"
        case .eo: return "Esperanto"
        case .ru: return "Russian"
        case .et: return "Estonian"
        case .sr: return "Serbian"
        case .tl: return "Filipino"
        case .sk: return "Slovak"
        case .fi: return "Finnish"
        case .sl: return "Slovenian"
        case .fr: return "French"
        case .es: return "Spanish"
        case .gl: return "Galician"
        case .sw: return "Swahili"
        case .ka: return "Georgian"
        case .sv: return "Swedish"
        case .de: return "German"
        case .ta: return "Tamil"
        case .el: return "Greek"
        case .te: return "Telugu"
        case .gu: return "Gujarati"
        case .th: return "Thai"
        case .ht: return "Haitian Creole"
        case .tr: return "Turkish"
        case .iw: return "Hebrew"
        case .uk: return "Ukrainian"
        case .hi: return "Hindi"
        case .ur: return "Urdu"
        case .hu: return "Hungarian"
        case .vi: return "Vietnamese"
        case .is: return "Icelandic"
        case .cy: return "Welsh"
        case .id: return "Indonesian"
        case .yi: return "Yiddish"
        }
    }
}
