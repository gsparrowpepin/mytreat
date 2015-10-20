//
//  MealTableViewController.swift
//  MyTreat
//
//  Created by GMSW on 10/14/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
import CoreData

class MealTableViewController: UITableViewController {

    // MARK : Properties
    
    var meals = [Meal]()
    //var mealsManagedObject = [NSManagedObject]()
    
    // MARK : - Initialize

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem()
        
        loadMeals()
    }

    func loadMeals() {
        meals = [Meal]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Meal")
        
        //Sort by Date
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let mealsManagedObject = results as! [NSManagedObject]
            
            for meal in mealsManagedObject {
                let tempMeal = Meal(restaurantName: (meal.valueForKey("restaurant") as? String)!, whoPaid: (meal.valueForKey("whoPaid") as? String)!, amount: (meal.valueForKey("amount") as? Double)!, date: (meal.valueForKey("date") as? NSDate)!)!
                meals += [tempMeal]
            }
            
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .NoStyle
        let dateString = formatter.stringFromDate(meal.date)
        
        cell.labelResaurantName.text = meal.restaurantName
        cell.labelWhoPaid.text = meal.whoPaid
        cell.labelDate.text = dateString


        return cell
    }

    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Updating Existing Meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                //Save Corresponding meal to core data
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Meal")
                //Sort by Date
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                do {
                    let results = try managedContext.executeFetchRequest(fetchRequest)
                    let mealManagedObject = results[selectedIndexPath.row] as! NSManagedObject
                    
                    mealManagedObject.setValue(meal.restaurantName, forKey: "restaurant")
                    mealManagedObject.setValue(meal.amount, forKey: "amount")
                    mealManagedObject.setValue(meal.date, forKey: "date")
                    mealManagedObject.setValue(meal.whoPaid, forKey: "whoPaid")
                    
                    try managedContext.save()
                    
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                loadMeals()
                tableView.reloadData()
                
            }else{
                //Add New Meal
//                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
//                meals.append(meal)
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//                
                //Store Incoming Meal in Core Data
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let entity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: managedContext)
                let mealToCoreData = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                mealToCoreData.setValue(meal.restaurantName, forKey: "restaurant")
                mealToCoreData.setValue(meal.amount, forKey: "amount")
                mealToCoreData.setValue(meal.date, forKey: "date")
                mealToCoreData.setValue(meal.whoPaid, forKey: "whoPaid")
                
                do {
                    try managedContext.save()
                    meals.append(meal)
                    print("Data Saved to Core Data")
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                loadMeals()
                tableView.reloadData()
            }
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete Corresponding meal to core data
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "Meal")
            //Sort by Date
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                let mealManagedObject = results[indexPath.row] as! NSManagedObject
                
                managedContext.deleteObject(mealManagedObject)
                
                try managedContext.save()
                
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }

            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
            }
        }else if segue.identifier == "AddItem"{
            print("Adding new Meal")
        }
    }
}
