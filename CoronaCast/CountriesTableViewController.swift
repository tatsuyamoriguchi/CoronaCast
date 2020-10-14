//
//  CountriesTableViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/25/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit

class CountriesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectedCountryLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var countryData = [CountryDictionary]()
    var selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
    var selectedCountryISO2: String?
    var filteredCountryData = [CountryDictionary]()
    var sortKey: String = "NewConfirmed"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let countrySelected = selectedCountry {
            selectedCountryLabel.text = "\(countrySelected) Selected"
        } else {
            selectedCountryLabel.text = "Country Not Selected"
        }

        let url = GlobalData().url
        getData(from: url)
        
        tableView.reloadData()
   }

    
    private func getData(from url: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
            }
             
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                // Create a array from downloaded JSON data
                self.countryData = result.Countries
                
  
                // Sort countryData array by Country name of dictionary
                self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in
                    return (int1).NewConfirmed > (int2).NewConfirmed
                })

                
                // Reload tableView in main thread to reflect downloaded and sorted JSON data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("Failed to convert. CountriesTableViewController \(error)")
            }
            
        })
        task.resume()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchBar.text != "" {
            return filteredCountryData.count
        } else {
            return countryData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let country: CountryDictionary
        if searchBar.text != "" {
            country = filteredCountryData[indexPath.row]
        } else {
            country = countryData[indexPath.row]
        }
        
        cell.textLabel?.text = country.Country
        
        let detailValue: String?
        
        switch sortKey {
        case "NewConfirmed":
            detailValue = Convert().decimalInLocale(input: country.NewConfirmed)
        case "TotalConfirmed":
            detailValue = Convert().decimalInLocale(input: country.TotalConfirmed)
        case "NewDeaths":
            detailValue = Convert().decimalInLocale(input: country.NewDeaths)
        case "TotalDeaths":
            detailValue = Convert().decimalInLocale(input: country.TotalDeaths)
        case "RecoveryRate":
            let recoveryRate = Convert().decimal2Percentage(numerator: country.TotalRecovered, denominator: country.TotalConfirmed)
            detailValue = recoveryRate
        default:
            detailValue = String(country.NewConfirmed)
        }

        
        cell.detailTextLabel?.text = detailValue
        
        if country.Country == selectedCountry {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let country: CountryDictionary
        if searchBar.text != "" {
            country = filteredCountryData[indexPath.row]


        } else {
            country = countryData[indexPath.row]
            print("else was called")
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = .checkmark
            selectedCountry = country.Country
            selectedCountryISO2 = country.CountryCode
            
            UserDefaults.standard.set(selectedCountry, forKey: "selectedCountry")
            UserDefaults.standard.set(selectedCountryISO2, forKey: "selectedCountryISO2")
            
        }

        if let countrySelected = selectedCountry {
            selectedCountryLabel.text = "\(countrySelected) Selected"
        } else {
            selectedCountryLabel.text = "Country Not Selected"
        }

        tableView.reloadData()
        
        self.searchBar.endEditing(true)
        
        
     }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = .none
        }
    }

}


extension CountriesTableViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        //filteredCountryData = countryData
        self.searchBar.endEditing(true)
        //tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == false {
            filteredCountryData = countryData.filter { country in
                return country.Country.lowercased().contains(searchText.lowercased())
            }
        }
        else {
            filteredCountryData = countryData
            
            
        }
        
        tableView.reloadData()
       
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in
                return (int1).NewConfirmed > (int2).NewConfirmed
            })
            
            sortKey = "NewConfirmed"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        case 1:
            self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in
                return (int1).TotalConfirmed > (int2).TotalConfirmed
            })

            sortKey = "TotalConfirmed"

            // Reload tableView in main thread to reflect downloaded and sorted JSON data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
                
        case 2:
            self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in
                return (int1).NewDeaths > (int2).NewDeaths
            })
            
            sortKey = "NewDeaths"

            // Reload tableView in main thread to reflect downloaded and sorted JSON data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case 3:
            self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in
                 return (int1).TotalDeaths > (int2).TotalDeaths
             })
             
             sortKey = "TotalDeaths"

             // Reload tableView in main thread to reflect downloaded and sorted JSON data
             DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
            
        case 4:
            self.countryData = self.countryData.sorted(by: {(int1, int2)  -> Bool in

                let recoveryRate1 = Double(int1.TotalRecovered)/Double(int1.TotalConfirmed)
                let recoveryRate2 = Double(int2.TotalRecovered)/Double(int2.TotalConfirmed)
                
//                print("   revoveryRate1 & 2   ")
//                print(int1.Country)
//                print(recoveryRate1)
//                print(int2.Country)
//                print(recoveryRate2)
//                print(" ")

                sortKey = "RecoveryRate"

                return recoveryRate1 < recoveryRate2
            })

            // Reload tableView in main thread to reflect downloaded and sorted JSON data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }


        default:
            print(selectedScope)
        }
    }


}
