//
//  ViewController.swift
//  Digital Detox
//
//  Created by Jyothi Rao on 6/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var airLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        timerPicker.dataSource = self
        timerPicker.delegate = self
        if (UserDefaults.standard.value(forKey: "air") == nil){
            UserDefaults.standard.set(0.0, forKey: "air")
            UserDefaults.standard.set(0.0, forKey: "money")
            UserDefaults.standard.set(["tree": 1, "car": 0, "solar": 0,"wind": 0,"hydrogen": 0, "biomass": 0, "tidal": 0, "hydro": 0, "geothermal": 0, "nuclear": 0], forKey: "bought")
            UserDefaults.standard.set(true, forKey: "adviceAlert")
            howToPlay()
        }
        
        let air = UserDefaults.standard.value(forKey: "air") as! Double
        airLabel.text = String(roundToTwoDecs(num: air))
        
        var airTimer = Timer()
        
        airTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    var airAmount = UserDefaults.standard.double(forKey: "air")
    @objc func updateTimer(){
        let airPerSecond = Double(airPerMin())/60.0
        airAmount += airPerSecond
        UserDefaults.standard.set(airAmount, forKey: "air")
        airLabel.text = String(roundToTwoDecs(num: airAmount))
    }
    
    @IBAction func startClicked(_ sender: UIButton) {
        
        if (inputHours == 0) && (inputMinutes == 0) {
            let timerAlert = UIAlertController(title: "Timer Error", message: "You must input a time over 0 minutes", preferredStyle: .alert)
            timerAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
                print("Dismiss Pressed")
            }))
            present(timerAlert, animated: true)
            return
        }
        
        if (UserDefaults.standard.bool(forKey: "adviceAlert") == true){
            adviceAlert()
        }
        
        UserDefaults.standard.set(false, forKey: "leftApp")
        self.performSegue(withIdentifier: "startTimerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTimerSegue"{
            let timerVC = segue.destination as! TimerViewController
            timerVC.inputSeconds = ((inputHours*60) + inputMinutes)*60
        }
    }
    
    func howToPlay() {
        print("havent completed yet")
    }
    
    func adviceAlert() {
        let alert = UIAlertController(title: "ADVICE", message: "For best results, turn on 'Do Not Disturb' and mute iPhone notifications", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
            self.performSegue(withIdentifier: "startTimerSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Don't Show Again", style: .destructive, handler: {action in
            UserDefaults.standard.set(false, forKey: "adviceAlert")
            self.performSegue(withIdentifier: "startTimerSegue", sender: self)
        }))
        present(alert, animated: true)
    }
}


let hoursArray = Array(0...23)
let minutesArray = Array(0...59)

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return hoursArray.count
        } else {
            return minutesArray.count
        }
    }
    
    
}

var inputHours = 0
var inputMinutes = 0

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            return (String(hoursArray[row]) + " hours")
        } else {
            return (String(minutesArray[row]) + " minutes")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            inputHours = hoursArray[row]
        } else {
            inputMinutes = minutesArray[row]
        }
    }
}

func airPerMin() -> Int{
    var output = 0
    
    let bought = UserDefaults.standard.dictionary(forKey: "bought")
    
    output += bought!["tree"] as! Int
    output += (bought!["car"] as! Int)*5
    output += (bought!["solar"] as! Int)*15
    output += (bought!["wind"] as! Int)*35
    output += (bought!["hydrogen"] as! Int)*75
    output += (bought!["biomass"] as! Int)*125
    output += (bought!["tidal"] as! Int)*250
    output += (bought!["hydro"] as! Int)*500
    output += (bought!["geothermal"] as! Int)*1000
    output += (bought!["nuclear"] as! Int)*10000
    
    return output
}

func roundToTwoDecs(num: Double) -> Double{
    var output = num*100
    output.round()
    output = output/100.00
    return output
}
