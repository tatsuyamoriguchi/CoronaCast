//
//  CountriesData.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/25/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import Foundation

class CountriesData {

    let url = "https://api.covid19api.com/countries"
    

}


struct Countries: Codable {

    let Country: String
    let Slug: String
    let ISO2: String

}



/*

 https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest
 
 [{"Country":"Viet Nam","Slug":"vietnam","ISO2":"VN"},{"Country":"France","Slug":"france","ISO2":"FR"}]
 
 
 */
