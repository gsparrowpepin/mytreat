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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    //@IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(animated: Bool) {
    
        loadMeals()
        
        var barDataPoints:[String] = []
        var barValues:[Double] = []
        
        var pieDataPoints:[String] = []
        var pieValues:[Double] = []
        
        let lineDataPoints:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var lineValues:[Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        let calendar = NSCalendar.currentCalendar()
        
        for meal in meals{
            //Bar Graph Data Points
            if barDataPoints.contains(meal.whoPaid){
                let index = barDataPoints.indexOf(meal.whoPaid)
                barValues[index!] += meal.amount
            }else{
                barDataPoints.append(meal.whoPaid)
                barValues.append(meal.amount)
            }
            //Pie Graph Data Points
            if pieDataPoints.contains(meal.restaurantName){
                let index = pieDataPoints.indexOf(meal.restaurantName)
                pieValues[index!] += meal.amount
            }else{
                pieDataPoints.append(meal.restaurantName)
                pieValues.append(meal.amount)
            }
            //Line Graphy Data Points
            let components = calendar.components(.Month, fromDate: meal.date)
            let month = components.month
            lineValues[month] += meal.amount
        }
        //Graph
        setBarChart(barDataPoints, values: barValues, yValueLabel: "Total Paid")
        setPieChart(pieDataPoints, values: pieValues)
        setLineChart(lineDataPoints, values: lineValues)
        
        barChartView.notifyDataSetChanged()
        pieChartView.notifyDataSetChanged()
        lineChartView.notifyDataSetChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: - Charting Functions

    func setBarChart(dataPoints: [String], values: [Double], yValueLabel: String) {
        barChartView.noDataText = "No meals have been entered"
        barChartView.noDataTextDescription = "Enter meals to see statistics"
        barChartView.descriptionText = ""
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Paid")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        barChartView.data = chartData
        
        chartDataSet.colors = ChartColorTemplates.joyful()
        barChartView.animate(xAxisDuration: 0, yAxisDuration: 1.0)
        barChartView.legend.enabled = false
        
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        pieChartView.descriptionText = ""
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        
        pieChartDataSet.colors = ChartColorTemplates.joyful()
        pieChartView.legend.position = .BelowChartLeft
        pieChartView.legend.wordWrapEnabled = true
        pieChartView.legend.font = UIFont(name: "HelveticaNeue", size: 14)!
        
        pieChartView.holeAlpha = 0.0
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.drawSliceTextEnabled = false
        
        pieChartView.animate(xAxisDuration: 1.0)
    }
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        lineChartView.descriptionText = ""
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries)
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.lineWidth = 1.8

        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)

        lineChartView.data = lineChartData
        
        
        lineChartDataSet.colors = ChartColorTemplates.joyful()
        lineChartView.legend.enabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
    }

//MARK: - Core Data

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
