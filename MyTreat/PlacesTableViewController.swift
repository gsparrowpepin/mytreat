//
//  PlacesTableViewController.swift
//  MyTreat
//
//  Created by GMSW on 11/23/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesTableViewController: UITableViewController {

    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

        placesClient = GMSPlacesClient()
        
        placesClient!.currentPlaceWithCallback({ (placeLikelihoods: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            for likelihood in placeLikelihoods!.likelihoods {
                if let likelihood = likelihood as? GMSPlaceLikelihood {
                    let tempPlace = likelihood.place
                    print("Current Place name \(tempPlace.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(tempPlace.formattedAddress)")
                    let toArray = Place(placeName: tempPlace.name, placeAddress: tempPlace.formattedAddress!)
                    self.places.append(toArray!)
                }
            }
            
            super.tableView!.reloadData()
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    /*
    // MARK: - Navigation
    */
    @IBAction func unwindToCreate(sender: UIStoryboardSegue){
        if let destination = sender.sourceViewController as? MealViewController {
            if let placeIndex = tableView.indexPathForSelectedRow?.row{
                destination.restaurantName = self.places[placeIndex].placeName
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let placeIndex = tableView.indexPathForSelectedRow?.row{
//            let name = self.places[placeIndex].placeName
//        }
//    }
}


// MARK: - Table view data source

extension PlacesTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numRows = places.count
        return numRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PlaceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlaceTableViewCell
        
        cell.placeName.text = places[indexPath.row].placeName
        cell.address.text = places[indexPath.row].placeAddress
        
        return cell
    }
}

extension PlacesTableViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
}