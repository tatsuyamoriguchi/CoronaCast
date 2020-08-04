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

    
    @IBAction func refreshPressedOn(_ sender: UIButton) {
        self.resetBadgeCounter()
        badgeNumber = 0
        //loadMessages()
        self.tableView.reloadData()
        print("Did refresh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

        badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        loadMessages()
        //resetBadgeCounter()

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
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    //UIApplication.shared.applicationIconBadgeNumber -= 1
                    
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



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.messages.count
    }

    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let creationDateString: String?
        if let creationDate = messages[indexPath.row].creationDate {
         
            creationDateString = Convert().convertDate2LocalDateString(input: creationDate)
        } else {
            creationDateString = "No date data available"
        }

        cell.textLabel?.attributedText = makeAttributedString(title: messages[indexPath.row].content, subtitle: creationDateString!)
        cell.textLabel?.numberOfLines = 0

        
        //badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        print("badgeNumber")
        print(badgeNumber)
        print("indexPath.row")
        print(indexPath.row)


        if indexPath.row < badgeNumber! {
            //cell.accessoryType = .none
            cell.backgroundColor = .white

        } else {
            //cell.accessoryType = .checkmark
            cell.backgroundColor = .systemGray4
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if cell.accessoryType == .none { //if cell.accessoryType == .none {
////            if cell.backgroundColor == .white {
////                UIApplication.shared.applicationIconBadgeNumber -= 1
////                badgeNumber -= 1
//                resetBadgeCounter()
//                cell.backgroundColor = .systemGray4
//                cell.accessoryType = .checkmark
//                //tableView.reloadData()
//            }
//        }
//    }

//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if cell.accessoryType == .none {
//                UIApplication.shared.applicationIconBadgeNumber += 1
//                badgeNumber += 1
//                cell.isHighlighted = true
//                tableView.reloadData()
//
//            }
//        }
//    }

    
}
