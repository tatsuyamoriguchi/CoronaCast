//
//  GlobalData.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/19/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import Foundation

class GlobalData {

    let url = "https://api.covid19api.com/summary"

}


struct Response: Codable {
    var Countries: [CountryDictionary]
    let Date: String
    let Global: Global
}

struct Global: Codable {
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
}

struct CountryDictionary: Codable {
    let Country: String
    let CountryCode: String
    let Slug: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
    let Date: String
}

/*
 {
 "Global": {
    "NewConfirmed": 100282,
    "TotalConfirmed": 1162857,
    "NewDeaths": 5658,
    "TotalDeaths": 63263,
    "NewRecovered": 15405,
    "TotalRecovered": 230845
 },
 "Countries": [
    {
        "Country": "ALA Aland Islands",
        "CountryCode": "AX",
        "Slug": "ala-aland-islands",
        "NewConfirmed": 0,
        "TotalConfirmed": 0,
        "NewDeaths": 0,
        "TotalDeaths": 0,
        "NewRecovered": 0,
        "TotalRecovered": 0,
        "Date": "2020-04-05T06:37:00Z"
    },
    {
        "Country": "Zimbabwe",
        "CountryCode": "ZW",
        "Slug": "zimbabwe",
        "NewConfirmed": 0,
        "TotalConfirmed": 9,
        "NewDeaths": 0,
        "TotalDeaths": 1,
        "NewRecovered": 0,
        "TotalRecovered": 0,
        "Date": "2020-04-05T06:37:00Z"
    }
 ],
 "Date": "2020-04-05T06:37:00Z"
 }
 */



// MARK: - rapidapi Smartable AI stats API
/*
 struct Response: Codable {
    let location: Location
    let updatedDateTime: Date
    let stats: Stats
    
 }
 
 struct Location: Codable {
    let long: Double
    let lat: Double
    let countryOrRegion: String
    let county: String
    let isoCode: String
 }
 
 struct Stats: Codable {
 let totalConfirmedCases: Int
 let newlyConfirmedCases: Int
 let totalDeaths: Int
 let newDeaths: Int
 let totalRecoveredCases: Int
 let newlyRecoveredCases: Int
 var history: Array
 var breakdowns: Array
 }
 
 */

/*
 //
 {3 items
 "location":{6 items
    "long":-95.712891
    "countryOrRegion":"United States"
    "provinceOrState":NULL
    "county":NULL
    "isoCode":"US"
    "lat":37.09024
 }
 "updatedDateTime":"2020-10-06T06:00:42.4942778Z"
 "stats":{8 items
    "totalConfirmedCases":7569437
    "newlyConfirmedCases":63477
    "totalDeaths":221267
    "newDeaths":641
    "totalRecoveredCases":2796278
    "newlyRecoveredCases":0
    "history":258 items
        [0 - 100]
        [100 - 200]
        [200 - 258]
    "breakdowns":[...]62 items
    }
 }
 */
