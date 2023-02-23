//
//  DictionaryExtension.swift
//  LavaSDK
//
//  Created by Ashish B on 27/06/16.
//

import Foundation

extension NSDictionary {
    
    func getJSONString() -> String {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            let str = String(data: jsonData, encoding: String.Encoding.utf8)
            return str ?? ""
        } catch let error as NSError {
            print(error)
            return ""
        }
        
    }
    
}

extension Dictionary where Key : ExpressibleByStringLiteral {
    
/*
     // Usage:
     let dict = [
     "name": "John",
     "location": "Chicago",
     ]
     
     print(dict[caseInsensitiveKey: "NAME"])      // John
     print(dict[caseInsensitiveKey: "lOcAtIoN"])  // Chicago
     
     
     let dict = [
     "name": "John",
     "NAME": "David",
     ]
     
     print(dict[caseInsensitiveKey: "name"])   // no guarantee that you will get David or John.
*/
    subscript(caseInsensitiveKey key: Key) -> Value? {
        get {
            let searchKey = String(describing: key).lowercased()
            for k in self.keys {
                let lowerK = String(describing: k).lowercased()
                if searchKey == lowerK {
                    return self[k]
                }
            }
            return nil
        }
    }
    
}
