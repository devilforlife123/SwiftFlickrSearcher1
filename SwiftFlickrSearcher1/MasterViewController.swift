//
//  MasterViewController.swift
//  SwiftFlickrSearcher1
//
//  Created by suraj poudel on 29/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


class MasterViewController:UIViewController{
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    //String is the keyType and [FLickrPhoto] ValueType which is an Array of  //Flickr.Photo 
    
    //Instantitate OrderedDictonary which has variables ArrayType which is [String] and Dictionary Which is [String,[Flickr.Photo]
    
    var searches = OrderedDictionary<String,[Flickr.Photo]>()
}

extension MasterViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Number of searches 
        return self.searches.array.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let (term,photos) = self.searches[indexPath.row]
        cell.textLabel?.text = "\(term) (\(photos.count))"
        return cell 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail"{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                let (_,photos) = self.searches[selectedIndexPath.row]
                (segue.destinationViewController as! DetailViewController).photos = photos 
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            self.searches.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
extension MasterViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Flickr.search(searchBar.text!) { (result) in
            switch result{
            case .Error:
                break
            case .Result(let photos):
                self.searches.insert(photos,forKey:searchBar.text!,atIndex:0)
                self.tableView.reloadData()
            }
        }
    }
}


























