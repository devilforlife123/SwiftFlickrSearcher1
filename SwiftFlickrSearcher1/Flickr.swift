//
//  Flickr.swift
//  SwiftFlickrSearcher1
//
//  Created by suraj poudel on 29/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

let FLICKR_API_KEY = "978d7216fb7560fbd505ddc25c7bc264"

class Flickr{
    
    enum SearchResult{
        case Result([Photo])
        case Error
    }
    
    typealias SearchCompletion = (result:SearchResult)->()
    
    class func search(searchTerm:String,completion:SearchCompletion){
        let encodedTerm = (searchTerm as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FLICKR_API_KEY)&text=\(encodedTerm)&per_page=20&format=json&nojsoncallback=1"
        let urlRequest = NSURLRequest(URL: NSURL(string: searchURLString)!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if let error = error{
                print("Flickr error :\(error)")
                completion(result: .Error)
                return
            }
            
            let results:AnyObject!
            do{
                
                results = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            }catch let error as NSError{
                print("Encountered an error \(error)")
                completion(result: .Error)
                return
            }
            
            if results == nil{
                completion(result: .Error)
                return
            }
            
            if let json = JSONValue.fromObject(results){
                let status = json["stat"]?.string
                let photos = json["photos"]?["photo"]?.array
                
                if status != nil && status! == "ok" && photos != nil{
                    var flickrPhotos:[Photo] = []
                    flickrPhotos = photos!.map({Photo.createFromJSON($0)})
                    completion(result: .Result(flickrPhotos))
                    return 
                }
            }
            
            completion(result: .Error)
            
            
        }
        
    }
    
    
    class Photo{
        
        var farm:Int = 0
        var server:String = ""
        var secret:String = ""
        var photoID:String = ""
        
        var image:UIImage?
        var thumbnail:UIImage?
        
        class func createFromJSON(jsonValue:JSONValue)->Photo{
            
            let photo = Photo()
            if let farm = jsonValue["farm"]?.integer{
                photo.farm = farm
            }
            
            if let server = jsonValue["server"]?.string{
                photo.server = server
            }
            
            if let secret = jsonValue["secret"]?.string {
                photo.secret = secret
            }
            if let photoID = jsonValue["id"]?.string {
                photo.photoID = photoID
            }
            
            return photo
            
        }
        
        enum PhotoResult{
            case Result(UIImage)
            case Error
        }
        
        typealias PhotoCompletion = (result:PhotoResult)->()
        
        func loadImage(thumbnail:Bool,completion:PhotoCompletion){
            
            if self.image != nil && !thumbnail{
                completion(result: .Result(self.image!))
            }else if self.thumbnail != nil && thumbnail{
                completion(result: .Result(self.thumbnail!))
            }
            
            let size = thumbnail ? "m" : "b"
            
            let photoURLString = "http://farm\(self.farm).staticflickr.com/\(self.server)/\(self.photoID)_\(self.secret)_\(size).jpg"
            
            let urlRequest = NSURLRequest(URL: NSURL(string: photoURLString)!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
                if let error = error{
                    print("Image error :\(error)")
                    completion(result: .Error)
                }
                if let data = data{
                    if let image = UIImage(data: data){
                        if thumbnail{
                            self.thumbnail = image
                        }else{
                            self.image = image
                        }
                        
                        completion(result: .Result(image))
                    }else{
                        completion(result: .Error)
                    }
                }else{
                    completion(result: .Error)
                }
            }
            
        }
    }
}