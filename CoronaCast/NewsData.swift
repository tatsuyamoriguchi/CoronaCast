//
//  NewsData.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/29/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import Foundation

class NewsData {
    
    // See new info at https://rapidapi.com/SmartableAI/api/coronavirus-smartable?endpoint=apiendpoint_f638b6c0-b9f2-4204-bffa-1bd0107c4cc0
    
    // old one
//    let baseUrl = "https://api.smartable.ai/coronavirus/news/"
    let baseUrl = "https://coronavirus-smartable.p.rapidapi.com/news/v1/"
    // "https://coronavirus-smartable.p.rapidapi.com/news/v1/"
//    let baseUrl = "https://coronavirus-smartable.p.rapidapi.com/"
    let locationUrl: String = "global"
    // old one
    // let subscription = "?subscription-key=1b498132b75d49ebbe65e3f9cfe70c45"
    //let subscription = "?x-rapidapi-key=951fa88c89mshba15f133217e822p13c0eejsn7d6f6962e3bf"
 
    //  https://coronavirus-smartable.p.rapidapi.com/news/v1/global?x-rapidapi-key=951fa88c89mshba15f133217e822p13c0eejsn7d6f6962e3bf
    
    
}

struct News: Codable {
    var location: Location?
    let updatedDateTime: String?
    var news: [Feed]?
}

struct Location: Codable {
    let countryOrRegion: String?
    let provinceOrState: String?
    let county: String?
    let isoCode: String?
    let lat: Double?
    let long: Double?
}
/*
 {
 "location": {
   "long": 138.0,
   "countryOrRegion": "Japan",
   "provinceOrState": null,
   "county": null,
   "isoCode": "JP",
   "lat": 36.0
 },
 */



struct Feed: Codable {
    let path: String?
    let title: String?
    let excerpt: String?
    let heat: Int?
    let tags: [String]?
    let type: String?
    let webUrl: String?
    let ampWebUrl: String?
    let cdnAmpWebUrl: String?
    let publishedDateTime: String?
    let updatedDateTime: String?
    let provider: Provider?
    let images: [Image]?
    let locale: String?
    let categories: [String]?
    let topics: [String]?
}

struct Provider: Codable {
    let name: String?
    let domain: String?
}

struct Image: Codable {
    let url: String?
    let width: Int?
    let height: Int?
    let title: String?
}



/*
{
    "path": "...",
    "title": "...",
    "excerpt": "...",
    "heat": 128,
    "tags": [
        "US"
    ],
    "type": "article",
    "webUrl": "...",
    "ampWebUrl": "...",
    "cdnAmpWebUrl": "...",
    "publishedDateTime": "2020-03-16T23:56:00-07:00",
    "updatedDateTime": null,
    "provider": {
        "name": "Southwest Times Record",
        "domain": "swtimes.com",
    },
    "images": [{
        "url": "...",
        "width": 360,
        "height": 531,
        "title": "...",
    }],
    "locale": "en-us",
    "categories": [
        "news"
    ],
    "topics": [
        "Coronavirus in US",
        "Coronavirus",
        "New Cases"
    ]
},
*/


/*
 {
     "location": {...},
     "updatedDateTime": "...",
     "news": {...}
 }
 */


/*
 "location": {
     "countryOrRegion": "United States",
     "provinceOrState": null,
     "county": null,
     "isoCode": "US",
     "lat": 37.0902,
     "long": -95.7129,
 }
 */



/*
 {
 "location": {
   "long": 138.0,
   "countryOrRegion": "Japan",
   "provinceOrState": null,
   "county": null,
   "isoCode": "JP",
   "lat": 36.0
 },
 "updatedDateTime": "2020-07-29T08:03:07.4989511Z",
 "news": [
   {
     "path": "_news/2020-07-29-covid-19-impact-on-skin-care-devices-market-in-asia-pacific-business-will-grow-in-2027-prominent-players-japan-gals-coltd-loral-sa-lumenis.md",
     "title": "COVID-19 Impact on Skin Care Devices Market in Asia-Pacific, Business Will Grow in 2027, Prominent Players: Japan Gals co.ltd., LOral S.A., Lumenis",
     "excerpt": "The coronavirus epidemic (COVID-19 ... Based on region, the market is analyzed across China, Australia, India, and Japan. • The study provides an in-depth analysis of the Asia-Pacific skin care devices market, with current trends and future estimations ...",
     "webUrl": "https://www.openpr.com/news/2098676/covid-19-impact-on-skin-care-devices-market-in-asia-pacific",
     "heat": null,
     "tags": [
       "JP"
     ],
     "images": null,
     "type": "article",
     "ampWebUrl": null,
     "cdnAmpWebUrl": null,
     "publishedDateTime": "2020-07-29T00:35:00-07:00",
     "updatedDateTime": null,
     "provider": {
       "name": "openpr.com",
       "domain": "openpr.com",
       "images": null,
       "publishers": null,
       "authors": null
     },
     "locale": "en-us",
     "categories": [
       "news"
     ],
     "topics": [
       "Coronavirus in Japan",
       "Coronavirus in Asia",
       "Coronavirus"
     ]
   },
 */
