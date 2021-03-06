//
//  HypeController.swift
//  Hype
//
//  Created by theevo on 3/30/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import CloudKit

class HypeController {
    
    // MARK: - Source of Truth and Shared Instance
    
    static let shared = HypeController()
    var hypes: [Hype] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK: - CRUD
    
    func saveHype(body: String, completion: @escaping (Bool) -> Void) {
        
        let hype = Hype(body: body)
        
        let record = CKRecord(hype: hype)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let record = record,
                let hype = Hype(ckRecord: record) else
            { return completion(false) }
            
            //            self.hypes.append(hype) // Alternative
            self.hypes.insert(hype, at: 0)
            return completion(true)
        }
    } // end saveHype
    
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        
        
        let predicate = NSPredicate(value: true) // return all records
        
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            // error handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let records = records else { return completion(false) }
            
            let hypes: [Hype] = records.compactMap(Hype.init(ckRecord: )) // you're passing a closure
//            let hypes: [Hype] = records.compactMap { Hype(ckRecord: $0) } // alternative: in-line closure. you're writing your own instructions.
            
            self.hypes = hypes
            return completion(true)
        }
        
        
        
        
    }
}
