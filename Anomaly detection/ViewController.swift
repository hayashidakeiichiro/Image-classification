//
//  ViewController.swift
//  Anomaly detection
//
//  Created by 林田計一郎 on 2022/04/14.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var Lbtn: UIButton!
    @IBOutlet weak var Tbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Lbtn.layer.cornerRadius=10
        Lbtn.layer.shadowOpacity=0.3
        Lbtn.layer.shadowRadius=5
        Lbtn.layer.shadowOffset=CGSize(width: 7, height: 7)
        
        Tbtn.layer.cornerRadius=10
        Tbtn.layer.shadowOpacity=0.3
        Tbtn.layer.shadowRadius=5
        Tbtn.layer.shadowOffset=CGSize(width: 7, height: 7)
    }

    @IBAction func toL(_ sender: Any) {
        self.performSegue(withIdentifier: "toLcamera", sender: nil)
    }
    
    @IBAction func toT(_ sender: Any) {
        self.performSegue(withIdentifier: "toTcamera", sender: nil)
    }
    @IBAction func reset(_ sender: Any) {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
}

