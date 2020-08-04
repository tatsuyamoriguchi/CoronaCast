//
//  MessagesTableViewController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 8/3/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit
import CloudKit


class MessagesTableViewController: UITableViewController {

    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        //if MessagesTableViewController.isDirty {
            loadMessages()
        //}
        resetBadgeCounter()

        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func resetBadgeCounter() {
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            
            if error != nil {
                print("Error resetting badge: \(String(describing: error))")
            } else {
                DispatchQueue.main.async {
                    //UIApplication.shared.applicationIconBadgeNumber -= 1
                    self.badgeNumber = 0
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
        operation.desiredKeys = ["content"]
        operation.resultsLimit = 10
        
        var newMessages = [Message]()
        
        operation.recordFetchedBlock = { record in
        
            let message = Message()
            message.recordID = record.recordID
            message.content = record["content"]
            message.creationDate = record.creationDate
            message.url = record["url"]
            
            
           // message.createdAt = record["createdAt"]
            newMessages.append(message)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    //MessagesTableViewController.isDirty = false
                    self.messages = newMessages
                    
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



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.messages.count
    }

    
    var badgeNumber = UIApplication.shared.applicationIconBadgeNumber

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let creationDateString: String?
        if let creationDate = messages[indexPath.row].creationDate {
         
            creationDateString = Convert().convertDate2LocalDateString(input: creationDate)
        } else {
            creationDateString = "No date data available"
        }

        cell.textLabel?.attributedText = makeAttributedString(title: messages[indexPath.row].content, subtitle: creationDateString!)
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row < badgeNumber {
            //cell.accessoryType = .none
            cell.isHighlighted = true
        } else {
            //cell.accessoryType = .checkmark
            cell.isHighlighted = false
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if cell.isHighlighted == true { //if cell.accessoryType == .none {
//                //resetBadgeCounter()
//                UIApplication.shared.applicationIconBadgeNumber -= 1
//                //cell.accessoryType = .checkmark
//                cell.isHighlighted = false
//            }
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if cell.isHighlighted == false {
//                UIApplication.shared.applicationIconBadgeNumber += 1
//                cell.isHighlighted = true
//            }
//        }
//    }

    
}
