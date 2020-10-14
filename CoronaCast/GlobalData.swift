//
//  GlobalData.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/19/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

// No longer using this data map since changed REST API to rapidAPI
// replaced with CoronaStatsData.swift

import Foundation

class GlobalData {

    let url = "https://api.covid19api.com/summary"
    // Subscription info: https://covid19api.com

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

