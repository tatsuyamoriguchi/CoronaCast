//
//  CoronaStatsData.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 10/6/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import Foundation

// Smartable AI's REST API is not suitable to list up country data. This file is not used for now.
// MARK: - rapidapi Smartable AI stats API

class CoronaStatsData {
    let url = "https://coronavirus-smartable.p.rapidapi.com/stats/v1/"
    //let url = "https://rapidapi.p.rapidapi.com/stats/v1/"
}


/*
 {3 items
 "location":{...}6 items
 "updatedDateTime":"2020-10-07T06:00:58.7094373Z"
 "stats":{...}8 items
 }
 */


struct CoronaResponse: Codable {
    var location: CoronaLocation?
    let updatedDateTime: String?
    let stats: CoronaStats?
    
}

struct CoronaLocation: Codable {
    let long: Double?
    let lat: Double?
    let countryOrRegion: String?
    let county: String?
    let isoCode: String?
}
/*
 Failed to convert. DashboardTableViewController valueNotFound(Swift.Double, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "location", intValue: nil), CodingKeys(stringValue: "long", intValue: nil)], debugDescription: "Expected Double value but found null instead.", underlyingError: nil))
 => Added Optional ? to CoronaLocation properties
 */


struct CoronaStats: Codable {
    let totalConfirmedCases: Int
    let newlyConfirmedCases: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecoveredCases: Int
    let newlyRecoveredCases: Int
    var history: [History]
    var breakdowns: [Breakdown]
}

struct History: Codable {
    let date: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
}



struct Breakdown: Codable {
    let location: BreakdownLocation
    let totalConfirmedCases: Int
    let newlyConfirmedCases: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecoveredCases: Int
    let newlyRecoveredCases: Int
    
}



struct BreakdownLocation: Codable {
    let long: Double?
    let countryOrRegion: String?
    let provinceOrState: String?
    let county: String?
    let isoCode: String?
    let lat: Double?
}







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
