//
//  PopoverViewController.swift
//  MyTreat
//
//  Created by GMSW on 10/21/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
import Charts

class PopoverViewController: UIViewController {

    var meals: [Meal]?
    var name: String?
    
    @IBOutlet var pieChartView: PieChartView!
    
    override func viewWillAppear(animated: Bool) {
        
        showGraph(name!)
        
        pieChartView.notifyDataSetChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showGraph(name: String){
        //Load Data
        
        var popoverPieDataPoints: [String] = []
        var popoverPieValues: [Double] = []
        
        for meal in meals! {
            if meal.whoPaid == name{
                if popoverPieDataPoints.contains(meal.restaurantName){
                    let index = popoverPieDataPoints.indexOf(meal.restaurantName)
                    popoverPieValues[index!] += meal.amount
                }else{
                    popoverPieDataPoints.append(meal.restaurantName)
                    popoverPieValues.append(meal.amount)
                }
            }
        }
        
        //Create Graph
        pieChartView.notifyDataSetChanged()

        pieChartView.descriptionText = ""
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<popoverPieDataPoints.count {
            let dataEntry = ChartDataEntry(value: popoverPieValues[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: popoverPieDataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData


        pieChartDataSet.colors = ChartColorTemplates.joyful()
        pieChartView.legend.position = .BelowChartLeft
        pieChartView.legend.wordWrapEnabled = true
        pieChartView.legend.font = UIFont(name: "HelveticaNeue", size: 14)!
        
        pieChartView.centerText = "\(name)'s Spending"
        
//        pieChartView.cent
        pieChartView.drawSliceTextEnabled = false
        
        pieChartView.animate(xAxisDuration: 1.0)
        

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
