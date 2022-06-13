//
//  PointsViewController.swift
//  Digital Detox
//
//  Created by Jyothi Rao on 6/12/22.
//

import UIKit

class PointsViewController: UIViewController {
    
    @IBAction func returnButton(_ sender: UIButton) {
        performSegue(withIdentifier: "returnMenuSegue", sender: self)
    }
    
    func roundToTwoDecs(num: Double) -> Double{
        var output = num*100
        output.round()
        output = output/100.00
        return output
    }
    
    var moneyEarned: Double?
    
    @IBOutlet weak var pointsIndicator: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsIndicator.text = "You earned $" + String(roundToTwoDecs(num: moneyEarned!))

    }
    
}
