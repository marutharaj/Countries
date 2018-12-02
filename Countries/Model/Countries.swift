//
//  Countries.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/27/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Foundation

struct Currencies: Codable {
    var code: String?
    var name: String?
    var symbol: String?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case name
        case symbol
    }
}

struct Languages: Codable {
    var iso6391: String?
    var iso6392: String?
    var name: String?
    var nativeName: String?
    
    private enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name
        case nativeName
    }
}

struct Translations: Codable {
    var translationde: String?
    var translationes: String?
    var translationfr: String?
    var translationja: String?
    var translationit: String?
    var translationbr: String?
    var translationpt: String?
    var translationnl: String?
    var translationhr: String?
    var translationfa: String?
    
    private enum CodingKeys: String, CodingKey {
        case translationde = "de"
        case translationes = "es"
        case translationfr = "fr"
        case translationja = "ja"
        case translationit = "it"
        case translationbr = "br"
        case translationpt = "pt"
        case translationnl = "nl"
        case translationhr = "hr"
        case translationfa = "fa"
    }
}

struct RegionalBlocs: Codable {
    var acronym: String?
    var name: String?
    var otherAcronyms: [String]?
    var otherNames: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case acronym
        case name
        case otherAcronyms
        case otherNames
    }
}

struct Countries: Codable {
    var name: String?
    var topLevelDomain: [String]?
    var alpha2Code: String?
    var alpha3Code: String?
    var callingCodes: [String]?
    var capital: String?
    var altSpellings: [String]?
    var region: String?
    var subregion: String?
    var population: Int64?
    var latlng: [Float]?
    var demonym: String?
    var area: Double?
    var gini: Float?
    var timezones: [String]?
    var borders: [String]?
    var nativeName: String?
    var numericCode: String?
    var currencies: [Currencies]?
    var languages: [Languages]?
    var translations: Translations?
    var flag: String?
    var flagData: Data?
    var regionalBlocs: [RegionalBlocs]?
    var cioc: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case topLevelDomain
        case alpha2Code
        case alpha3Code
        case callingCodes
        case capital
        case altSpellings
        case region
        case subregion
        case population
        case latlng
        case demonym
        case area
        case gini
        case timezones
        case borders
        case nativeName
        case numericCode
        case currencies
        case languages
        case translations
        case flag
        case regionalBlocs
        case cioc
    }
    
    init() {
        
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try? values.decode(String.self, forKey: .name)
        topLevelDomain = try? values.decode([String].self, forKey: .topLevelDomain)
        alpha2Code = try? values.decode(String.self, forKey: .alpha2Code)
        alpha3Code = try? values.decode(String.self, forKey: .alpha3Code)
        callingCodes = try? values.decode([String].self, forKey: .callingCodes)
        capital = try? values.decode(String.self, forKey: .capital)
        altSpellings = try? values.decode([String].self, forKey: .altSpellings)
        region = try? values.decode(String.self, forKey: .region)
        subregion = try? values.decode(String.self, forKey: .subregion)
        population = try? values.decode(Int64.self, forKey: .population)
        latlng = try? values.decode([Float].self, forKey: .latlng)
        demonym = try? values.decode(String.self, forKey: .demonym)
        area = try? values.decode(Double.self, forKey: .area)
        timezones = try? values.decode([String].self, forKey: .timezones)
        nativeName = try? values.decode(String.self, forKey: .nativeName)
        numericCode = try? values.decode(String.self, forKey: .numericCode)
        flag = try? values.decode(String.self, forKey: .flag)
        cioc = try? values.decode(String.self, forKey: .cioc)
        
        if let decodeGini = try? values.decode(Float.self, forKey: .gini) {
            gini = decodeGini
        } else {
            gini = 0.0
        }
        
        if let decodeBorders = try? values.decode([String].self, forKey: .borders) {
            borders = decodeBorders
        } else {
            borders = []
        }
        
        if let decodeCurrencies = try? values.decode([Currencies].self, forKey: .currencies) {
            currencies = decodeCurrencies
        } else {
            currencies = []
        }
        
        if let decodeLanguages = try? values.decode([Languages].self, forKey: .languages) {
            languages = decodeLanguages
        } else {
            languages = []
        }
        
        if let decodeTranslations = try? values.decode(Translations.self, forKey: .translations) {
            translations = decodeTranslations
        } else {
            translations = Translations()
        }
        
        if let decodeRegionalBlocs = try? values.decode([RegionalBlocs].self, forKey: .regionalBlocs) {
            regionalBlocs = decodeRegionalBlocs
        } else {
            regionalBlocs = []
        }
    }
}
