//
//  NewsFeedViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/28/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let news = newsData[indexPath.row]
        
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = news.provider?.name
        
        if let heatValue = news.heat {
            
            switch heatValue {
            case 0..<150 :
                cell.textLabel?.textColor = .none
            case 150... :
                cell.textLabel?.textColor = .red
            default:
                print("out of switch case ranges")
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewsDetails", sender: nil)

    }
    
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsFeedButtonLabel: UIButton!
    
    var newsData = [Feed]()
    var selectedCountryISO2 = UserDefaults.standard.string(forKey: "selectedCountryISO2")
    var selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
    var selectedCountry4News: String?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Initialize newsData to refresh news feed
        newsData = [Feed]()
        
        // When returning to this view from other view,
        // Check UserDefaults for selectedCountryISO2 & selectedCountry if previously assigned
        selectedCountryISO2 = UserDefaults.standard.string(forKey: "selectedCountryISO2")
        selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
        
        if selectedCountry == nil {
            // if selectedCountry4News returns nil, no country is assigned since its first launch.
            // Show global news
            newsFeedButtonLabel.setTitle("Refresh Global News", for: .normal)
            newsTitleLabel.text = "COVID19 Global News"

            selectedCountry4News = "global"
            
        } else if selectedCountry != nil && selectedCountry4News == "global" {
            let selectedCountryISO2 = UserDefaults.standard.string(forKey: "selectedCountryISO2")
            let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
            newsFeedButtonLabel.setTitle("Show Global News", for: .normal)
            newsTitleLabel.text = "COVID19 News: " + selectedCountry!
            
            // Re-Assign selectedCountry to selectedCountry4News to change button text
            selectedCountry4News = selectedCountryISO2!
        
        } else {
            // if selectedCountry4News returns a value, a country has been assigned.
            // Initial viewWillAppear shows that country's region news here.
                        
            // Change the button's and label's titles
            let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
            newsFeedButtonLabel.setTitle("Show Global News", for: .normal)
            newsTitleLabel.text = "COVID19 News: " + selectedCountry!
            
            selectedCountry4News = selectedCountryISO2
        }
        
        // nil found in selectedCountry4News
        let url = NewsData().baseUrl + selectedCountry4News! + NewsData().subscription
        newsData = [Feed]()
        getData(from: url)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // To display COVID-19 global news
    @IBAction func refreshFeed(_ sender: Any) {
        
        if selectedCountry == nil {
            // if selectedCountry returns nil, no country is assigned since its first launch.
            // Show global news

            newsTitleLabel.text = "COVID19 Global News"
            newsFeedButtonLabel.setTitle("Refresh Global News", for: .normal)
            selectedCountry4News = "global"
        
        } else if selectedCountry != nil && selectedCountry4News == "global" {
            // if selecetedCountry4News returns "global", view shows global news
            // Pressing this button gets selectedCountry regional news
            let selectedCountryISO2 = UserDefaults.standard.string(forKey: "selectedCountryISO2")
            let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
            newsTitleLabel.text = "COVID19 News: " + selectedCountry!
            newsFeedButtonLabel.setTitle("Show Global News", for: .normal)

            // Re-Assign selectedCountry to selectedCountry4News to change button text
            selectedCountry4News = selectedCountryISO2!
            
        } else {
            // if selectedCountry returns a value, a country has been assigned.
            // Initial viewWillAppear shows that country's region news here.
            // So when this button is pressed, the user wants to see global news
               
            // Change the button's and label's titles
            let selectedCountry = UserDefaults.standard.string(forKey: "selectedCountry")
            newsFeedButtonLabel.setTitle("Show News: " + selectedCountry!, for: .normal)
            newsTitleLabel.text = "COVID19 Global News"
            
            selectedCountry4News = "global"
        }

        let url = NewsData().baseUrl + selectedCountry4News! + NewsData().subscription
        newsData = [Feed]()
        getData(from: url)
     
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getData(from url: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
            }
            
            // Get and decode data
            do {
                let result = try JSONDecoder().decode(News.self, from: data)
                if let newsResult = result.news {
                    
                    // Create a array from downloaded JSON data
                    for item in newsResult {
                        self.newsData.append(item)
                        
                    }
                } else {
                    print("let newsResult = result.news failed.")
                }
                
                
                // Reload tableView in main thread to reflect downloaded and sorted JSON data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("tableview was reloaded")
                }
                
            } catch {
                print("Failed to convert. NewsFeedViewController \(error)")
            }
            
        })
        task.resume()
    }
    
    // Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        
        if segue.identifier == "NewsDetails" {
            
            if let target = segue.destination as? NewsViewController {
                
                let news = newsData[selectedPath.row]
                target.selectedCountry = selectedCountry
                target.newsTitle = news.title
                target.excerpt = news.excerpt
                target.heat = news.heat
                target.webUrl = news.webUrl
                target.publishedDateTime = news.publishedDateTime
                target.providerName = news.provider?.name
                target.images = news.images
            }
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
}
