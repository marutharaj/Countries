# Countries

<b>Development Information:</b><br>
 XCode version: 10.1<br>
 Swift version: 4.2<br>
 Design Pattern : Model View Presenter(MVP)<br>
 UI Design: Storyboard and Autolayout<br>
 Unit Testing framework: Quick and Nimble<br>
 UI Testing framework: XCTest<br>
 Dependency Manager: Cocoapod<br>
 Persistence framework: CoreData<br>
 <b>Thirdparty Library:</b><br>
    SwiftLint: To enforce swift style and conventions<br>
    Alamofire: To communicate restcountries server<br>
    ReachabilitySwift: To find network reachability<br>
    OHHTTPStubs: To create mock web service call for unit testing<br>
    SVGKit: To render svg file on UIImageView<br>
 
 <b>Architecture:</b><br>
    <b>Presentation Layer:</b><br>
        CountryTableViewCell.swift<br>
        CountryDetailTableViewCell.swift<br>
        CountryCurrenciesTableViewCell.swift<br>
        CountryLanguagesTableViewCell.swift<br>
        CountryViewController.swift<br>
        CountryDetailViewController.swift<br>
    <b>Business Layer:</b><br>
        Countries.swift<br>
        CountryPresenter.swift<br>
    <b>Data Access Layer:</b><br>
        CoreDataManager.swift<br>
        CountryService.swift<br>
  
 <b>Screenshots:</b><br>
![alt text](CountryList.png "Home Screen")
![alt text](CountryDetail1.png "Country Detail Screen")
![alt text](CountryDetail2.png "Country Detail Screen Contd.")
