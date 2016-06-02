//
//  OrderedDictionary.swift
//  SwiftFlickrSearcher1
//
//  Created by suraj poudel on 29/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

struct OrderedDictionary<KeyType:Hashable,ValueType>{

    typealias ArrayType = [KeyType]
    var array = ArrayType()
    
    typealias DictionaryType = [KeyType:ValueType]
    var dictionary = DictionaryType()
    
    subscript(index:Int)->(KeyType,ValueType){
        get{
            precondition(index < self.array.count , "Out of bounds!")
            let key = self.array[index]
            let value = self.dictionary[key]
            return (key,value!)
            
        }set{
            precondition(index < self.array.count, "Out of bounds!")
            let originalKey = self.array[index]
            self.dictionary[originalKey] = nil
            
            let (key,value) = newValue
            self.array[index] = key
            self.dictionary[key] = value    
            
        }
    }
    
    mutating func removeAtIndex(index:Int){
        precondition(index<self.array.count, "Out of bounds!")
        let key = self.array.removeAtIndex(index)
        self.dictionary.removeValueForKey(key)
    }
    
    mutating func insert(photos:ValueType,forKey key:KeyType,atIndex index:Int){
        //
        
        let existingValue = self.dictionary[key]
        
        if let _ = existingValue{
            if let existingIndex = self.array.indexOf(key){
                self.array.removeAtIndex(existingIndex)
            }
        }
        
        self.array.insert(key, atIndex: index)
        self.dictionary[key] = photos
    }



}