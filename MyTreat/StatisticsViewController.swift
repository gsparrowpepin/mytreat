//
//  StatisticsViewController.swift
//  MyTreat
//
//  Created by GMSW on 10/19/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
import Charts
import CoreData

class StatisticsViewController: UIViewController {
    
    
    var meals = [Meal]()
    
    @IBOutlet var barChartView: HorizontalBarChartView!
    //@IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(animated: Bool) {
        loadMeals()
        
        var dataPoints:[String] = []
        var values:[Double] = []
        
        for meal in meals{
            if dataPoints.contains(meal.whoPaid){
                let index = dataPoints.indexOf(meal.whoPaid)
                values[index!] += meal.amount
            }else{
                dataPoints.append(meal.whoPaid)
                values.append(meal.amount)
            }
        }
        setChart(dataPoints, values: values, yValueLabel: "Total Paid")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double], yValueLabel: String) {
        barChartView.noDataText = "No meals have been entered"
        barChartView.noDataTextDescription = "Enter meals to see statistics"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: yValueLabel)
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        chartDataSet.colors = ChartColorTemplates.colorful()
        barChartView.animate(xAxisDuration: 0, yAxisDuration: 2.0)
    }
    
    func loadMeals() {
        meals = [Meal]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Meal")
        
        //Sort by Date
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
