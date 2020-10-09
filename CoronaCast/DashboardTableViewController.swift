//
//  DashboardTableViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/27/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    // Properties
    
    @IBOutlet weak var GlobalDataDateLabel: UILabel!
    @IBOutlet weak var GlobalNewConfirmedDataLabel: UILabel!
    @IBOutlet weak var GlobalTotalConfirmedDataLabel: UILabel!
    @IBOutlet weak var GlobalDeathsDataLabel: UILabel!
    @IBOutlet weak var GlobalTotalDeathsDataLabel: UILabel!
    @IBOutlet weak var GlobalDeathRateDataLabel: UILabel!
    @IBOutlet weak var GlobalNewRecoveredDataLabel: UILabel!
    @IBOutlet weak var GlobalTotalRecoveredDataLabel: UILabel!
    @IBOutlet weak var GlobalRecoveredRateDataLabel: UILabel!
    
    
    //@IBOutlet weak var CountryNameLabel: UILabel!
    @IBOutlet weak var CountryDataDateLabel: UILabel!
    @IBOutlet weak var CountryNewConfirmedDataLabel: UILabel!
    @IBOutlet weak var CountryTotalConfirmedDataLabel: UILabel!
    @IBOutlet weak var CountryDeathsDataLabel: UILabel!
    @IBOutlet weak var CountryTotalDeathsDataLabel: UILabel!
    @IBOutlet weak var CountryDeathRateDataLabel: UILabel!
    @IBOutlet weak var CountryNewRecoveredDataLabel: UILabel!
    @IBOutlet weak var CountryTotalRecoveredDataLabel: UILabel!
    @IBOutlet weak var CountryRecoveredRateDataLabel: UILabel!
    
    
    private var countryData = [Countries]()
    var selectedCountry: String = "Select Country"
    var selectedCountryISO2: String?
    
    let baseUrl = CoronaStatsData().url
    var globalDataDateIntFormatted: String?
    
    // For global stats
              
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let globalUrl = baseUrl + "global/"
         getData(from: globalUrl)

        selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry") ?? "Select a country"
        if ((UserDefaults.standard.string(forKey: "selectedCountryISO2")) != nil) {
            selectedCountryISO2 = UserDefaults.standard.string(forKey: "selectedCountryISO2")
            let countryUrl = baseUrl + selectedCountryISO2! + "/"
            getCountryData(from: countryUrl)
            print("")
            print("selectedCountryISO2")
            print(selectedCountryISO2 as Any)

        } else {}



        
        tableView.reloadData()
    }
    
    private func getData(from url: String) {
        
        
        // To access rapidapi site's Smartable.ai stat data
        let headers = [
            "x-rapidapi-host": "coronavirus-smartable.p.rapidapi.com",
            "x-rapidapi-key": "951fa88c89mshba15f133217e822p13c0eejsn7d6f6962e3bf"
        ]
        
        

        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        
        //let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
            }
            
            // Get and decode data
            var result: CoronaResponse?
            
            
            do {
                result = try JSONDecoder().decode(CoronaResponse.self, from: data)
                
                DispatchQueue.main.async {
                    
                    if let globalDataDate = result?.updatedDateTime {
                        print("")
                        print("globalDataDate")
                        print(globalDataDate)
                        
                        self.globalDataDateIntFormatted = Convert().convertDateFormatter(date: globalDataDate)
                        self.GlobalDataDateLabel.text = self.globalDataDateIntFormatted
                        
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalNewConfirmedInt = result?.stats?.newlyConfirmedCases {
                        
                        let globalNewConfirmedIntFormatted = Convert().decimalInLocale(input: globalNewConfirmedInt)
                        self.GlobalNewConfirmedDataLabel.text = globalNewConfirmedIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalTotalConfirmedInt = result?.stats?.totalConfirmedCases {
                        let globalTotalConfirmedIntFormatted = Convert().decimalInLocale(input: globalTotalConfirmedInt)
                        self.GlobalTotalConfirmedDataLabel.text = globalTotalConfirmedIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalNewDeathsInt = result?.stats?.newDeaths {
                        let globalNewDeathsIntFormatted = Convert().decimalInLocale(input: globalNewDeathsInt)
                        self.GlobalDeathsDataLabel.text = globalNewDeathsIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalTotalDeathsInt = result?.stats?.totalDeaths {
                        let globalTotalDeathsIntFormatted = Convert().decimalInLocale(input: globalTotalDeathsInt)
                        self.GlobalTotalDeathsDataLabel.text = globalTotalDeathsIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalTotalDeathsInt = result?.stats?.totalDeaths, let globalTotalConfirmedInt = result?.stats?.totalConfirmedCases {
                        let globalDeathRateString = Convert().decimal2Percentage(numerator: globalTotalDeathsInt, denominator: globalTotalConfirmedInt)
                        self.GlobalDeathRateDataLabel.text = globalDeathRateString
                    }
                    
                    if let globalNewRecoveredInt = result?.stats?.newlyRecoveredCases {
                        let globalNewRecoveredIntFormatted = Convert().decimalInLocale(input: globalNewRecoveredInt)
                        self.GlobalNewRecoveredDataLabel.text = globalNewRecoveredIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalTotalRecoveredInt = result?.stats?.totalRecoveredCases {
                        let globalTotalRecoveredIntFormatted = Convert().decimalInLocale(input: globalTotalRecoveredInt)
                        self.GlobalTotalRecoveredDataLabel.text = globalTotalRecoveredIntFormatted
                    } else { print("Unable to convert Int to String")}
                    
                    if let globalTotalRecoveredInt = result?.stats?.totalRecoveredCases, let globalTotalConfirmedInt = result?.stats?.totalConfirmedCases {
                        let globalRecoveredRateString = Convert().decimal2Percentage(numerator: globalTotalRecoveredInt, denominator: globalTotalConfirmedInt)
                        self.GlobalRecoveredRateDataLabel.text = globalRecoveredRateString
                        
                    } else { print("Unable to cnvert Int to String")}
                    
                } //DispatchQueue.main.async {
                
            } catch {
                print("Failed to convert. DashboardTableViewController \(error)")
            } //do {
            
        }) // let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
        task.resume()
    }
    
    func getCountryData(from url: String) {
        
        // To access rapidapi site's Smartable.ai stat data
        let headers = [
            "x-rapidapi-host": "coronavirus-smartable.p.rapidapi.com",
            "x-rapidapi-key": "951fa88c89mshba15f133217e822p13c0eejsn7d6f6962e3bf"
        ]
               
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let taskCountry = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

//        let taskCountry = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
            }
            

            // To test the connection to REST API
//            let httpResponse = response as? HTTPURLResponse
//                 print(httpResponse as Any)

            // Get and decode data
            var result: CoronaResponse?
            
            do {
                result = try JSONDecoder().decode(CoronaResponse.self, from: data)
                
                DispatchQueue.main.async {
     

                    // Unwrap Optional Array
                    if let countryStats = result?.stats, let locationData = result?.location {
                        print("")
                        print("locationData.isoCode")
                        print(locationData.isoCode as Any)
                        print("locationData.countryOrRegion")
                        print(locationData.countryOrRegion as Any)
                        print("self.selectedCountry")
                        print(self.selectedCountry)
                        print("self.selectedCountryISO2")
                        print(self.selectedCountryISO2 as Any)
                        
                        if locationData.isoCode == self.selectedCountryISO2 {
                            print("I got you")
                            
                            print(locationData.countryOrRegion as Any)
                            //self.CountryNameLabel.text = country.Country
                            self.CountryDataDateLabel.text = self.globalDataDateIntFormatted
                            self.CountryDeathsDataLabel.text = Convert().decimalInLocale(input: countryStats.newDeaths)
                            self.CountryTotalDeathsDataLabel.text = Convert().decimalInLocale(input: countryStats.totalDeaths)
                            self.CountryDeathRateDataLabel.text = Convert().decimal2Percentage(numerator: countryStats.totalDeaths, denominator: countryStats.totalConfirmedCases)
                            self.CountryNewConfirmedDataLabel.text = Convert().decimalInLocale(input: countryStats.newlyConfirmedCases)
                            self.CountryTotalConfirmedDataLabel.text = Convert().decimalInLocale(input: countryStats.totalConfirmedCases)
                            self.CountryNewRecoveredDataLabel.text = Convert().decimalInLocale(input: countryStats.newlyRecoveredCases)
                            self.CountryTotalRecoveredDataLabel.text = Convert().decimalInLocale(input: countryStats.totalRecoveredCases)
                            self.CountryRecoveredRateDataLabel.text = Convert().decimal2Percentage(numerator: countryStats.totalRecoveredCases, denominator: countryStats.totalConfirmedCases)
                        }
                        
                    }
                    
                } //DispatchQueue.main.async {
                
            } catch {
                print("Failed to convert. DashboardTableViewController \(error)")
            } //do {
            
        }) // let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
        taskCountry.resume()
        
    }
    
    //    private func getData(from url: String) {
    //
    //
    //        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
    //
    //            guard let data = data, error == nil else {
    //                print("Something went wrong.")
    //                return
    //            }
    //
    //            // Get and decode data
    //            var result: Response?
    //
    //            do {
    //                result = try JSONDecoder().decode(Response.self, from: data)
    //
    //                DispatchQueue.main.async {
    //
    //                    if let globalDataDate = result?.Date {
    //
    //                        let globalDataDateIntFormatted = Convert().convertDateFormatter(date: globalDataDate)
    //                        self.GlobalDataDateLabel.text = globalDataDateIntFormatted
    //
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalNewConfirmedInt = result?.Global.NewConfirmed {
    //
    //                        let globalNewConfirmedIntFormatted = Convert().decimalInLocale(input: globalNewConfirmedInt)
    //                        self.GlobalNewConfirmedDataLabel.text = globalNewConfirmedIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalTotalConfirmedInt = result?.Global.TotalConfirmed {
    //                        let globalTotalConfirmedIntFormatted = Convert().decimalInLocale(input: globalTotalConfirmedInt)
    //                        self.GlobalTotalConfirmedDataLabel.text = globalTotalConfirmedIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalNewDeathsInt = result?.Global.NewDeaths {
    //                        let globalNewDeathsIntFormatted = Convert().decimalInLocale(input: globalNewDeathsInt)
    //                        self.GlobalDeathsDataLabel.text = globalNewDeathsIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalTotalDeathsInt = result?.Global.TotalDeaths {
    //                        let globalTotalDeathsIntFormatted = Convert().decimalInLocale(input: globalTotalDeathsInt)
    //                    self.GlobalTotalDeathsDataLabel.text = globalTotalDeathsIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalTotalDeathsInt = result?.Global.TotalDeaths, let globalTotalConfirmedInt = result?.Global.TotalConfirmed {
    //                        let globalDeathRateString = Convert().decimal2Percentage(numerator: globalTotalDeathsInt, denominator: globalTotalConfirmedInt)
    //                        self.GlobalDeathRateDataLabel.text = globalDeathRateString
    //                    }
    //
    //
    //                    if let globalNewRecoveredInt = result?.Global.NewRecovered {
    //                        let globalNewRecoveredIntFormatted = Convert().decimalInLocale(input: globalNewRecoveredInt)
    //                        self.GlobalNewRecoveredDataLabel.text = globalNewRecoveredIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalTotalRecoveredInt = result?.Global.TotalRecovered {
    //                        let globalTotalRecoveredIntFormatted = Convert().decimalInLocale(input: globalTotalRecoveredInt)
    //                        self.GlobalTotalRecoveredDataLabel.text = globalTotalRecoveredIntFormatted
    //                    } else { print("Unable to convert Int to String")}
    //
    //                    if let globalTotalRecoveredInt = result?.Global.TotalRecovered, let globalTotalConfirmedInt = result?.Global.TotalConfirmed {
    //                        let globalRecoveredRateString = Convert().decimal2Percentage(numerator: globalTotalRecoveredInt, denominator: globalTotalConfirmedInt)
    //                        self.GlobalRecoveredRateDataLabel.text = globalRecoveredRateString
    //
    //                    } else { print("Unable to cnvert Int to String")}
    //
    //
    //                    // Unwrap Optional Array
    //                    if let countries = result?.Countries {
    //                        for country in countries {
    //                            if country.Country == self.selectedCountry {
    //                                print("I got you")
    //                                print(country.Country)
    //                                //self.CountryNameLabel.text = country.Country
    //                                self.CountryDataDateLabel.text = Convert().convertDateFormatter(date: country.Date)
    //                                self.CountryDeathsDataLabel.text = Convert().decimalInLocale(input: country.NewDeaths)
    //                                self.CountryTotalDeathsDataLabel.text = Convert().decimalInLocale(input: country.TotalDeaths)
    //                                self.CountryDeathRateDataLabel.text = Convert().decimal2Percentage(numerator: country.TotalDeaths, denominator: country.TotalConfirmed)
    //                                self.CountryNewConfirmedDataLabel.text = Convert().decimalInLocale(input: country.NewConfirmed)
    //                                self.CountryTotalConfirmedDataLabel.text = Convert().decimalInLocale(input: country.TotalConfirmed)
    //                                self.CountryNewRecoveredDataLabel.text = Convert().decimalInLocale(input: country.NewRecovered)
    //                                self.CountryTotalRecoveredDataLabel.text = Convert().decimalInLocale(input: country.TotalRecovered)
    //                                self.CountryRecoveredRateDataLabel.text = Convert().decimal2Percentage(numerator: country.TotalRecovered, denominator: country.TotalConfirmed)
    //                            }
    //                        }
    //                    }
    //
    //                } //DispatchQueue.main.async {
    //
    //            } catch {
    //                print("Failed to convert. DashboardTableViewController \(error)")
    //            } //do {
    //
    //        }) // let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
    //        task.resume()
    //
    //    }
    //
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName: String
        switch section {
        case 0:
            sectionName = NSLocalizedString("Global Stats", comment: "")
        case 1:
            sectionName = NSLocalizedString(selectedCountry, comment: "")
            
        // ...
        default:
            sectionName = ""
        }
        return sectionName
    }
}
