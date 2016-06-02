//
//  JSON.swift
//  SwiftFlickrSearcher1
//
//  Created by suraj poudel on 29/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

enum JSONValue{
    
    case JSONObject([String:JSONValue])
    case JSONArray([JSONValue])
    case JSONNumber(NSNumber)
    case JSONBool(Bool)
    case JSONString(String)
    case JSONNull
    
    
    subscript(key:String)->JSONValue?{
        get{
            switch self{
            case .JSONObject(let value):
                return value[key]
            default:
                return nil
            }
        }
    }
    
    var array:[JSONValue]?{
        get{
            switch self{
            case .JSONArray(let value):
                return value
            default:
                return nil 
            }
        }
    }
    
    var integer:Int?{
        get{
            switch self{
            case .JSONNumber(let value):
                return value.integerValue
            default:
                return nil
            }
        }
    }
    
    var string:String?{
        get{
            switch self{
            case .JSONString(let value):
                return value
            default:
                return nil
            }
        }
    }
    
    
    
    
    
    static func fromObject(object:AnyObject)->JSONValue?{
        switch object{
        case let value as NSDictionary:
            var jsonObject:[String:JSONValue] = [:]
            for(key,value):(AnyObject,AnyObject) in value{
                if let key = key as? String{
                    if let value = JSONValue.fromObject(value){
                        jsonObject[key] = value
                    }
                }
            }
            return JSONValue.JSONObject(jsonObject)
        case let value as NSArray:
            var jsonArray:[JSONValue] = []
            for v in value{
                if let v = JSONValue.fromObject(v){
                    jsonArray.append(v)
                }
            }
            return JSONValue.JSONArray(jsonArray)
        case let value as NSNumber:
            return JSONValue.JSONNumber(value)
        case _ as NSNull:
            return JSONValue.JSONNull
        case let value as NSString:
            return JSONValue.JSONString(value as String)
        default:
            return nil
        }
    }
    
}