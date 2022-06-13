//
//  MarketplaceViewController.swift
//  Digital Detox
//
//  Created by Jyothi Rao on 6/12/22.
//

import UIKit

class MarketplaceViewController: UIViewController {

    let itemInfo = [["tree", #imageLiteral(resourceName: "tree"),"1","1",10],
                    ["car", #imageLiteral(resourceName: "car"),"10","5",100],
                    ["solar", #imageLiteral(resourceName: "solar"),"100","15",500],
                    ["wind", #imageLiteral(resourceName: "wind"),"1000","35",10000],
                    ["hydrogen", #imageLiteral(resourceName: "hydrogen"),"10000","75",50000],
                    ["biomass", #imageLiteral(resourceName: "biomass"),"100000","125",750000],
                    ["tidal", #imageLiteral(resourceName: "tidal"),"1000000","250",5000000],
                    ["hydro", #imageLiteral(resourceName: "hydro"),"10000000","500",75000000],
                    ["geothermal", #imageLiteral(resourceName: "geothermal"),"100000000","1000",1000000000],
                    ["nuclear", #imageLiteral(resourceName: "nuclear"), "1000000000","10000",10000000000]]
    
    let rowNames = ["Tree","Electric Car", "Solar Panel", "Wind Turbine","Hydrogen Power Plant","Biomass Power Plant","Tidal Power Plant","Hydroelectric Power Plant","Geothermal Power Plant", "Nuclear Power Plant"]
    
    @IBOutlet weak var itemPicker: UIPickerView!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var amountOwned: UILabel!
    @IBOutlet weak var moneyMin: UILabel!
    @IBOutlet weak var airMin: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemPicker.dataSource = self
        itemPicker.delegate = self
        let money = UserDefaults.standard.double(forKey: "money")
        moneyLabel.text = "$" + String(money)
        
        let bought: [String : Int] = UserDefaults.standard.value(forKey: "bought") as! [String : Int]
        let itemName = itemInfo[0][0] as! String
        let numOwned = bought[itemName]!
        amountOwned.text = "Owned: " + String(numOwned)
        
        itemImage.image = itemInfo[0][1] as? UIImage
        moneyMin.text = itemInfo[0][2] as? String
        airMin.text = itemInfo[0][3] as? String
        itemPrice.text = "$" + String(itemInfo[0][4] as! Int)
    }

    @IBAction func buyClicked(_ sender: UIButton) {
        let money = UserDefaults.standard.double(forKey: "money")
        let price = itemInfo[currentRow][4] as! Int
        let itemName = itemInfo[currentRow][0] as! String
        
        if money < Double(price){
            let alert = UIAlertController(title: "Insufficient Funds", message: "You don't have enough money to buy this item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
                return
            }))
            present(alert, animated: true)
        }
        else {
            let newPrice = money - Double(price)
            UserDefaults.standard.set(newPrice, forKey: "money")
            moneyLabel.text = "$" + String(newPrice)
            
            var bought: [String : Int] = UserDefaults.standard.value(forKey: "bought") as! [String : Int]
            bought[itemName] = bought[itemName]! + 1
            UserDefaults.standard.set(bought, forKey: "bought")
        }
    }
}

extension MarketplaceViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemInfo.count
    }
    
    
}


var currentRow = 0

extension MarketplaceViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentRow = row
        
        let bought: [String : Int] = UserDefaults.standard.value(forKey: "bought") as! [String : Int]
        let itemName = itemInfo[row][0] as! String
        let numOwned = bought[itemName]!
        amountOwned.text = "Owned: " + String(numOwned)
        
        itemImage.image = itemInfo[row][1] as? UIImage
        moneyMin.text = itemInfo[row][2] as? String
        airMin.text = itemInfo[row][3] as? String
        itemPrice.text = "$" + String(itemInfo[row][4] as! Int)
        
    }
}
