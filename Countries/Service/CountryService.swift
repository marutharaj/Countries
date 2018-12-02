//
//  CountryService.swift
//  Countries
//
//  Created by Marutharaj Kuppusamy on 11/27/18.
//  Copyright © 2018 shell. All rights reserved.
//

import Foundation
import Alamofire
import SVGKit
import WebKit

extension UIImageView {
    func downloadFlagFrom(flagUrl: String, contentMode: UIView.ContentMode) {
        Alamofire.request(flagUrl).responseJSON { response in
            var countryFlagSVGImage: SVGKImage = SVGKImage()
            if let countryFlagData = response.data {
                countryFlagSVGImage = SVGKImage(data: countryFlagData)
            }
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                self.image = countryFlagSVGImage.uiImage
            }
        }
    }
}

class CountryService {
    func sendRequest(searchString: String, completionHandler:@escaping (DataResponse<Any>) -> Void) {
        let urlString = "http://restcountries.eu/rest/v2/name/" + searchString
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            completionHandler(response)
        }
    }
}
