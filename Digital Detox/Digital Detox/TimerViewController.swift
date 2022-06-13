//
//  TimerViewController.swift
//  Digital Detox
//
//  Created by Jyothi Rao on 6/11/22.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var inputSeconds: Int?
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    var secondsPassed = 0
    var moneyEarned = 0.0
    lazy var moneyPerMin = Double(dollarPerMin())
    lazy var moneyPerSec = moneyPerMin/60.0
    
    @objc func updateTimer(){
        if secondsPassed == inputSeconds || UserDefaults.standard.bool(forKey: "leftApp")
{
            if UserDefaults.standard.bool(forKey: "leftApp"){
                moneyEarned = moneyEarned/2
            }
            
            pointsLabel.text = "00:00:00"
            timer.invalidate()
            let oldMoney = UserDefaults.standard.double(forKey: "money")
            UserDefaults.standard.set(roundToTwoDecs(num: oldMoney + moneyEarned), forKey: "money")
            performSegue(withIdentifier: "showPointsSegue", sender: self)
        }
        else {
            let displayArray = secondsToTimer(sec: (inputSeconds!-secondsPassed))
            timerLabel.text = String(format: "%02d", displayArray[0] as! CVarArg) + ":" + String(format: "%02d", displayArray[1] as! CVarArg) + ":" + String(format: "%02d", displayArray[2] as! CVarArg)
            secondsPassed += 1
            
            moneyEarned += moneyPerSec
            pointsLabel.text = "You have earned $" + String(roundToTwoDecs(num: moneyEarned))
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "If you cancel detox midway, you will lose half of the money gained!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            self.moneyEarned = self.moneyEarned/2
            
            self.pointsLabel.text = "00:00:00"
            self.timer.invalidate()
            let oldMoney = UserDefaults.standard.double(forKey: "money")
            UserDefaults.standard.set(self.roundToTwoDecs(num: oldMoney + self.moneyEarned), forKey: "money")
            self.performSegue(withIdentifier: "showPointsSegue", sender: self)
        }))
        present(alert, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPointsSegue"{
            let pointsVC = segue.destination as! PointsViewController
            pointsVC.moneyEarned = moneyEarned
        }
    }
    
    func secondsToTimer(sec: Int) -> Array<Any>{
        var seconds = sec
        var output = [] as [Int]
        
        if seconds/3600 > 0{
            output.append(seconds/3600)
            seconds = seconds%3600
        } else {
            output.append(0)
        }
        
        if seconds/60 > 0{
            output.append(seconds/60)
            seconds =  seconds%60
        } else {
            output.append(0)
        }
        
        output.append(seconds)
        
        return output
    }
    
    func dollarPerMin() -> Int{
        var output = 0
        
        let bought = UserDefaults.standard.dictionary(forKey: "bought")
        
        output += bought!["tree"] as! Int
        output += (bought!["car"] as! Int)*10
        output += (bought!["solar"] as! Int)*100
        output += (bought!["wind"] as! Int)*1000
        output += (bought!["hydrogen"] as! Int)*10000
        output += (bought!["biomass"] as! Int)*100000
        output += (bought!["tidal"] as! Int)*1000000
        output += (bought!["hydro"] as! Int)*10000000
        output += (bought!["geothermal"] as! Int)*100000000
        output += (bought!["nuclear"] as! Int)*1000000000
        
        return output
    }
    func roundToTwoDecs(num: Double) -> Double{
        var output = num*100
        output.round()
        output = output/100.00
        return output
    }
}
