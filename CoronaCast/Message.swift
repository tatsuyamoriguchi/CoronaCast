//
//  Message.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 8/3/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit
import CloudKit

class Message: NSObject {

    var recordID: CKRecord.ID!
    var content: String!
    var creationDate: Date!
    var url: String?
}
