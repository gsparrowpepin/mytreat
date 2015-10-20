//
//  MealViewController.swift
//  MyTreat
//
//  Created by GMSW on 10/14/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit
import CoreData

class MealViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var textFieldRestaurantName: UITextField!
    @IBOutlet weak var textFieldWhoPaid: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    @IBOutlet weak var labelWhoPaid: UILabel!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    var meal:Meal?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBorders()
        
        // Do any additional setup after loading the view, typically from a nib.
        buttonSave.enabled = false
        
        textFieldRestaurantName.delegate = self
        textFieldWhoPaid.delegate = self
        textFieldAmount.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.restaurantName
            textFieldRestaurantName.text = meal.restaurantName
            textFieldWhoPaid.text = meal.whoPaid
            textFieldAmount.text = NSString(format: "%.2f", meal.amount) as String
            datePicker.setDate(meal.date, animated: false)
        }
        
        checkValidMealName()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func createBorders(){
        //Restaurant Name Bottom Border
        let borderR = CALayer()
        let widthR = CGFloat(0.5)
        borderR.borderColor = UIColor.lightGrayColor().CGColor
        borderR.frame = CGRect(x: 0, y: textFieldRestaurantName.frame.size.height - widthR, width: textFieldRestaurantName.frame.size.width, height: textFieldRestaurantName.frame.size.height)
        
        borderR.borderWidth = widthR
        textFieldRestaurantName.layer.addSublayer(borderR)
        textFieldRestaurantName.layer.masksToBounds = true
        
        //Amount Bottom Border
        let borderA = CALayer()
        let widthA = CGFloat(0.5)
        borderA.borderColor = UIColor.lightGrayColor().CGColor
        borderA.frame = CGRect(x: 0, y: textFieldAmount.frame.size.height - widthA, width: textFieldAmount.frame.size.width, height: textFieldAmount.frame.size.height)
        
        borderA.borderWidth = widthA
        textFieldAmount.layer.addSublayer(borderA)
        textFieldAmount.layer.masksToBounds = true
        
        
        //Name Border
        let borderN = CALayer()
        let widthN = CGFloat(0.5)
        borderN.borderColor = UIColor.lightGrayColor().CGColor
        borderN.frame = CGRect(x: 0, y: textFieldWhoPaid.frame.size.height - widthN, width: textFieldWhoPaid.frame.size.width, height: textFieldWhoPaid.frame.size.height)
        
        borderN.borderWidth = widthN
        textFieldWhoPaid.layer.addSublayer(borderN)
        textFieldWhoPaid.layer.masksToBounds = true

    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard when done editing
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        resetTextColor()
        navigationItem.title = textFieldRestaurantName.text
    }
    
    func resetTextColor() {
        labelRestaurantName.textColor = UIColor(red: 53/255, green: 43/255, blue: 63/255, alpha: 1)
        labelAmount.textColor = UIColor(red: 53/255, green: 43/255, blue: 63/255, alpha: 1)
        labelWhoPaid.textColor = UIColor(red: 53/255, green: 43/255, blue: 63/255, alpha: 1)

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField === textFieldRestaurantName{
            labelRestaurantName.textColor = UIColor(red: 159/255, green: 112/255, blue: 192/255, alpha: 1.0)
        }else if textField === textFieldAmount{
            labelAmount.textColor = UIColor(red: 159/255, green: 112/255, blue: 192/255, alpha: 1.0)
        }else if textField === textFieldWhoPaid{
            labelWhoPaid.textColor = UIColor(red: 159/255, green: 112/255, blue: 192/255, alpha: 1)
        }
    }
    
    func checkValidMealName() {
        let text = textFieldRestaurantName.text ?? ""
        let text2 = textFieldWhoPaid.text ?? ""
        let num = textFieldAmount.text ?? ""
        if !text.isEmpty && !text2.isEmpty && !num.isEmpty {
            buttonSave.enabled = true
        }
    }
    
    // MARK: - Navigation
//    
//    @IBAction func cancel(sender: AnyObject) {
//        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//        
//        if isPresentingInAddMealMode {
//            dismissViewControllerAnimated(true, completion: nil)
//        }else {
//            navigationController!.popViewControllerAnimated(true)
//        }
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if buttonSave === sender{
            let restaurantName = textFieldRestaurantName.text ?? ""
            let whoPaid = textFieldWhoPaid.text ?? ""
            let numberFormatter = NSNumberFormatter()
            let amount = numberFormatter.numberFromString(textFieldAmount.text!)?.doubleValue
            let date = datePicker.date
            
            meal = Meal(restaurantName: restaurantName, whoPaid: whoPaid, amount: amount!, date: date)
        }
    }
    
    // MARK: - Actions

}

