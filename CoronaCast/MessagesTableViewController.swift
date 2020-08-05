//
//  MessagesTableViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 8/3/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit
import CloudKit


class MessagesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var messages = [Message]()
    var badgeNumber: Int?
    
    var refreshControl = UIRefreshControl()
    
    @IBAction func refreshPressedOn(_ sender: UIButton) {

        badgeNumber = 0
        //tableView.reloadData()
        resetBadgeCounter()
        DispatchQueue.main.async {
            self.loadMessages()
            print("Did refresh")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        badgeNumber = UIApplication.shared.applicationIconBadgeNumber

        self.loadMessages()
      
        self.tableView.reloadData()
               
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    

    @objc func refresh(_ sender: UIButton) {
        //self.resetBadgeCounter()
        badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        loadMessages()
        //self.tableView.reloadData()
        print("Did refresh @objc")
        refreshControl.endRefreshing()
    }
    
    
    func resetBadgeCounter() {
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            
            
            if error != nil {
                print("Error resetting badge: \(String(describing: error))")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    //UIApplication.shared.applicationIconBadgeNumber -= 1
                    //self.badgeNumber = 0
                    print("resetBadgeConunter() called")
                }
            }
        }
        CKContainer.default().add(badgeResetOperation)
    }

    
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        if subtitle.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
            titleString.append(subtitleString)
        }
        return titleString
    }
    
    
    func loadMessages() {
        
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Notification", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["content", "url"]
        operation.resultsLimit = 10
        
        
        var newMessages = [Message]()
        
        operation.recordFetchedBlock = { record in
        
            let message = Message()
            message.recordID = record.recordID
            message.content = record["content"]
            message.creationDate = record.creationDate
            message.url = record["url"]
            newMessages.append(message)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.messages = newMessages
                   
                    print("loadMessage() called")
                    self.tableView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch Failed", message: "There was a problem fetching the list of messages. Please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
  

    // MARK: - Table view data source



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.messages.count
    }

    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let messageElement = messages[indexPath.row]
        
        let creationDateString: String?
        if let creationDate = messageElement.creationDate {
         
            creationDateString = Convert().convertDate2LocalDateString(input: creationDate)
        } else {
            creationDateString = "No date data available"
        }

        cell.textLabel?.attributedText = makeAttributedString(title: messageElement.content, subtitle: creationDateString!)
        cell.textLabel?.numberOfLines = 0


        if indexPath.row < badgeNumber! {
            cell.backgroundColor = .white

        } else {
            cell.backgroundColor = .systemGray4
        }
                
        if  messageElement.url != nil {
            cell.accessoryType = .detailButton
           
        } else {
            cell.accessoryType = .none
            
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .detailButton {
                cell.backgroundColor = .none
               
                if let urlString = messages[indexPath.row].url {
                    let url = URL(string: urlString)
                    if url != nil { UIApplication.shared.open(url!, options: [:], completionHandler: nil)}
                }
                
            }

        }
    }

    
}
