//
//  CoreDataManager.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/28/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Foundation
import CoreData

enum RecordStatus {
    case saved
    case exist
    case failed
}

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Countries")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isCountryExist(countryName: String) -> Bool {
        let manageObjectContext: NSManagedObjectContext! = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDCountries")
        fetchRequest.predicate = NSPredicate(format: "name = %@", countryName)
        do {
            let res = try manageObjectContext.fetch(fetchRequest)
            return res.isEmpty ? false : true
        } catch {
            print("Could not load saved countries:  \(error.localizedDescription)")
        }
        return false
    }
    
    func createCountryDetailWith(country: Countries, flagData: Data) -> RecordStatus {
        if isCountryExist(countryName: country.name ?? "") {
            return .exist
        }
        
        let manageObjectContext: NSManagedObjectContext! = persistentContainer.viewContext
        let cdCountry = CDCountries(context: manageObjectContext)
        cdCountry.name = country.name
        cdCountry.topLevelDomain = NSKeyedArchiver.archivedData(withRootObject: country.topLevelDomain ?? []) as NSObject
        cdCountry.alpha2Code = country.alpha2Code
        cdCountry.alpha3Code = country.alpha3Code
        cdCountry.callingCodes = NSKeyedArchiver.archivedData(withRootObject: country.callingCodes ?? []) as NSObject
        cdCountry.capital = country.capital
        cdCountry.altSpellings = NSKeyedArchiver.archivedData(withRootObject: country.altSpellings ?? []) as NSObject
        cdCountry.region = country.region
        cdCountry.subregion = country.subregion
        cdCountry.population = country.population ?? 0
        cdCountry.latlng = NSKeyedArchiver.archivedData(withRootObject: country.latlng ?? []) as NSObject
        cdCountry.demonym = country.demonym
        cdCountry.area = country.area ?? 0.0
        cdCountry.gini = country.gini ?? 0.0
        cdCountry.timezones = NSKeyedArchiver.archivedData(withRootObject: country.timezones ?? []) as NSObject
        cdCountry.borders = NSKeyedArchiver.archivedData(withRootObject: country.borders ?? []) as NSObject
        cdCountry.nativeName = country.nativeName
        cdCountry.numericCode = country.numericCode
        
        for currency in country.currencies! {
            let cdCurrency = CDCurrencies(context: manageObjectContext)
            cdCurrency.code = currency.code
            cdCurrency.name = currency.name
            cdCurrency.symbol = currency.symbol
            cdCountry.addToCurrencies(cdCurrency)
        }
        
        for language in country.languages! {
            let cdLanguage = CDLanguages(context: manageObjectContext)
            cdLanguage.name = language.name
            cdLanguage.nativeName = language.nativeName
            cdLanguage.iso6391 = language.iso6391
            cdLanguage.iso6392 = language.iso6392
            cdCountry.addToLanguages(cdLanguage)
        }
        
        let cdTranslation = CDTranslations(context: manageObjectContext)
        cdTranslation.translationde = country.translations?.translationde
        cdTranslation.translationes = country.translations?.translationes
        cdTranslation.translationfr = country.translations?.translationfr
        cdTranslation.translationja = country.translations?.translationja
        cdTranslation.translationit = country.translations?.translationit
        cdTranslation.translationbr = country.translations?.translationbr
        cdTranslation.translationpt = country.translations?.translationpt
        cdTranslation.translationnl = country.translations?.translationnl
        cdTranslation.translationhr = country.translations?.translationhr
        cdTranslation.translationfa = country.translations?.translationfa
        cdCountry.translations = cdTranslation
        
        cdCountry.flag = flagData
        
        for regionalBloc in country.regionalBlocs! {
            let cdRegionalBloc = CDRegionalBlocs(context: manageObjectContext)
            cdRegionalBloc.acronym = regionalBloc.acronym
            cdRegionalBloc.name = regionalBloc.name
            cdRegionalBloc.otherNames = NSKeyedArchiver.archivedData(withRootObject: regionalBloc.otherNames ?? []) as NSObject
            cdRegionalBloc.otherAcronyms = NSKeyedArchiver.archivedData(withRootObject: regionalBloc.otherAcronyms ?? []) as NSObject
            cdCountry.addToRegionalBlocs(cdRegionalBloc)
        }
        
        cdCountry.cioc = country.cioc
        
        do {
            try manageObjectContext.save()
        } catch {
            print("Could not save country data: \(error.localizedDescription)")
            return .failed
        }
        return .saved
    }
    
    func loadSavedCountries() -> [Countries] {
        var countries =  [Countries]()
        let manageObjectContext: NSManagedObjectContext! = persistentContainer.viewContext
        var cdCountries = [CDCountries]()
        let countryRequest: NSFetchRequest<CDCountries> = CDCountries.fetchRequest()
        
        do {
            cdCountries = try manageObjectContext.fetch(countryRequest)
            for cdCountry in cdCountries {
                var country: Countries? = Countries.init()
                country?.name = cdCountry.name
                country?.topLevelDomain = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.topLevelDomain as? Data ?? Data()) as? [String]
                country?.alpha2Code = cdCountry.alpha2Code
                country?.alpha3Code = cdCountry.alpha3Code
                country?.callingCodes = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.callingCodes as? Data  ?? Data()) as? [String]
                country?.capital = cdCountry.capital
                country?.altSpellings = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.altSpellings as? Data  ?? Data()) as? [String]
                country?.region = cdCountry.region
                country?.subregion = cdCountry.subregion
                country?.population =  cdCountry.population
                country?.latlng = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.latlng as? Data  ?? Data()) as? [Float]
                country?.demonym = cdCountry.demonym
                country?.area = cdCountry.area
                country?.gini = cdCountry.gini
                country?.timezones = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.timezones as? Data  ?? Data()) as? [String]
                country?.borders = NSKeyedUnarchiver.unarchiveObject(with: cdCountry.borders as? Data  ?? Data()) as? [String]
                country?.nativeName = cdCountry.nativeName
                country?.numericCode = cdCountry.numericCode
                
                country?.currencies = [Currencies]()
                for cdCurrencies in (cdCountry.currencies?.allObjects)! {
                    let cdCurrency = cdCurrencies as? CDCurrencies
                    var currency: Currencies? = Currencies.init()
                    currency?.code = cdCurrency?.code
                    currency?.name = cdCurrency?.name
                    currency?.symbol = cdCurrency?.symbol
                    country?.currencies?.append(currency!)
                }
                
                country?.languages = [Languages]()
                for cdLanguages in (cdCountry.languages?.allObjects)! {
                    let cdLanguage = cdLanguages as? CDLanguages
                    var language: Languages? = Languages.init()
                    language?.name = cdLanguage?.name
                    language?.nativeName = cdLanguage?.nativeName
                    language?.iso6391 = cdLanguage?.iso6391
                    language?.iso6392 = cdLanguage?.iso6392
                    country?.languages?.append(language!)
                }
                
                country?.translations = Translations()
                var translation: Translations? = Translations.init()
                translation?.translationde = cdCountry.translations?.translationde
                translation?.translationes = cdCountry.translations?.translationes
                translation?.translationfr = cdCountry.translations?.translationfr
                translation?.translationja = cdCountry.translations?.translationja
                translation?.translationit = cdCountry.translations?.translationit
                translation?.translationbr = cdCountry.translations?.translationbr
                translation?.translationpt = cdCountry.translations?.translationpt
                translation?.translationnl = cdCountry.translations?.translationnl
                translation?.translationhr = cdCountry.translations?.translationhr
                translation?.translationfa = cdCountry.translations?.translationfa
                country?.translations = translation
                
                country?.flagData = cdCountry.flag
                country?.regionalBlocs = [RegionalBlocs]()
                for cdRegionalBlocs in (cdCountry.regionalBlocs?.allObjects)! {
                    let cdRegionalBloc = cdRegionalBlocs as? CDRegionalBlocs
                    var regionalBloc: RegionalBlocs? = RegionalBlocs.init()
                    regionalBloc?.acronym = cdRegionalBloc?.acronym
                    regionalBloc?.name = cdRegionalBloc?.name
                    regionalBloc?.otherNames = NSKeyedUnarchiver.unarchiveObject(with: cdRegionalBloc?.otherNames as? Data  ?? Data()) as? [String]
                    let otherAcronym = NSKeyedUnarchiver.unarchiveObject(with: cdRegionalBloc?.otherAcronyms as? Data  ?? Data()) as? [String]
                    regionalBloc?.otherAcronyms = otherAcronym
                    country?.regionalBlocs?.append(regionalBloc!)
                }
                
                country?.cioc = cdCountry.cioc
                countries.append(country!)
            }
        } catch {
            print("Could not load saved countries: \(error.localizedDescription)")
        }
        return countries
    }
}
