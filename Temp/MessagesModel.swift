//
//  MessageModel.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 8/3/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit
import CloudKit


class MessagesModel {

    private let database = CKContainer.default().publicCloudDatabase
    
    var messages = [Message]() {
        didSet  {
            self.notificationQueue.addOperation {
                self.onChange?()
                
            }
        }
    }
    
        var onChange : (() -> Void)?
        var onError : ((Error) -> Void)?
        var notificationQueue = OperationQueue.main

   
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }

    @objc func refresh() {
        let query = CKQuery(recordType: Message.recordType, predicate: NSPredicate(value: true))

        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }

            self.messages = records.map { record in Message(record: record) }
        }
    }
}


struct Message {
    fileprivate static let recordType = "Notification"
    fileprivate static let keyName = "content"
    
    var record: CKRecord
    
    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        self.record = CKRecord(recordType: Message.recordType)
    }
    
    var content: String {
        get {
            return self.record.value(forKey: Message.keyName) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Message.keyName)
        }
    }
}
