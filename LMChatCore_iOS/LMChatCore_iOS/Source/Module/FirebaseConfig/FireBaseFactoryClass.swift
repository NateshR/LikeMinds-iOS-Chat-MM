//
//  FireBaseFactoryClass.swift
//  CollabMates
//
//  Created by Shashank on 27/05/21.
//  Copyright © 2021 CollabMates. All rights reserved.
//


import Foundation
import UIKit
import FirebaseDatabase

enum FIRQueryType : Int {
    case order_BY_CHILD = 0
    case order_BY_KEY = 2
    case order_BY_VALUE = 3
    case start_AT = 4
    case end_AT = 5
    case equal_AT = 6
    case limit_TO_FIRST = 7
    case limit_TO_LAST = 8
    case discussion_ID = 9
    case time_TO_LIVE = 10
    case filter_ID = 11
    case dialog_ID = 12
}

@objc class FireBaseFactoryClass: NSObject {
    
    @objc public static let shared = FireBaseFactoryClass()
    
    private override init () {
    }
    
    func parseQuery(_ query: DatabaseQuery?, queryMap: [NSNumber : String]?) -> DatabaseQuery? {
        var query = query
        if queryMap == nil {
            return query
        }
        for key in queryMap ?? [:] {
            guard let key = key as? NSNumber, let value = queryMap?[key] else {
                continue
            }
            
            if key == NSNumber(value:FIRQueryType.order_BY_CHILD.rawValue) {
                query = query?.queryOrdered(byChild: value)
            }
            if key == NSNumber(value: FIRQueryType.order_BY_KEY.rawValue) {
                query = query?.queryOrderedByKey()
            }
            if key == NSNumber(value: FIRQueryType.order_BY_VALUE.rawValue) {
                query = query?.queryOrderedByValue()
            }
            if key == NSNumber(value: FIRQueryType.start_AT.rawValue) {
                query = query?.queryStarting(atValue: value)
            }
            if key == NSNumber(value: FIRQueryType.end_AT.rawValue) {
                query = query?.queryEnding(atValue: value)
            }
            if key == NSNumber(value: FIRQueryType.equal_AT.rawValue) {
                query = query?.queryEqual(toValue: value)
            }
            if key == NSNumber(value: FIRQueryType.limit_TO_FIRST.rawValue) {
                query = query?.queryLimited(toFirst: UInt(Int(value) ?? 0))
            }
            if key == NSNumber(value: FIRQueryType.limit_TO_LAST.rawValue) {
                query = query?.queryLimited(toLast: UInt(Int(value) ?? 0))
            }
        }
        return query
    }
    
    func getDataForquery(_ query: DatabaseQuery?, completion: @escaping (Data?) -> Void) {
        
//        query?.observeSingleEvent(of: .childAdded, with:{ snapshot in
//            if let theJSONData = try?  JSONSerialization.data( withJSONObject: snapshot.value, options: .prettyPrinted ) {
//                completion(theJSONData)
//            }
//        })
        query?.removeAllObservers()
        query?.observe(.childAdded, with: { snapshot in
            do {
                guard let jsonData = snapshot.value else {
                    completion(nil)
                    return
                }
                let theJSONData = try JSONSerialization.data(withJSONObject: jsonData,
                                                               options: .prettyPrinted)
                completion(theJSONData)
            } catch let error {
                //print("failed to parse firebase query json - \(error)")
            }
        })
        
        query?.observe(.childRemoved, with:{ snapshot in
            do {
                guard let jsonData = snapshot.value else {
                    completion(nil)
                    return
                }
                let theJSONData = try JSONSerialization.data(withJSONObject: jsonData,
                                                               options: .prettyPrinted)
                completion(theJSONData)
            } catch let error {
                //print("failed to parse firebase query json - \(error)")
            }
        })
        
        query?.observe(.childChanged, with:{ snapshot in
            do {
                guard let jsonData = snapshot.value else {
                    completion(nil)
                    return
                }
                let theJSONData = try JSONSerialization.data(withJSONObject: jsonData,
                                                               options: .prettyPrinted)
                completion(theJSONData)
            } catch let error {
                //print("failed to parse firebase query json - \(error)")
            }
        })
        
        query?.observe(.childMoved, with:{ snapshot in
            do {
                guard let jsonData = snapshot.value else {
                    completion(nil)
                    return
                }
                let theJSONData = try JSONSerialization.data(withJSONObject: jsonData,
                                                               options: .prettyPrinted)
                completion(theJSONData)
            } catch let error {
                //print("failed to parse firebase query json - \(error)")
            }
        })
        
    }
    
}
