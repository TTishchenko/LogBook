//
//  WindViewController.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 18.06.2021.
//

import Foundation
import UIKit
import MessageUI

class WindViewController: UIViewController {
    
    @IBOutlet weak var WindSpeedLbl: UILabel!
    @IBOutlet weak var WindSpeedSlider: UISlider!
    
    @IBOutlet weak var NButton: UIButton!
    @IBOutlet weak var SButton: UIButton!
    @IBOutlet weak var WButton: UIButton!
    @IBOutlet weak var EButton: UIButton!
    @IBOutlet weak var NWButton: UIButton!
    @IBOutlet weak var NEButton: UIButton!
    @IBOutlet weak var SWButton: UIButton!
    @IBOutlet weak var SEButton: UIButton!
    
    @IBAction func WindSpeedSlider(_ sender: UISlider) {
        WindSpeedLbl.text = String(Int(sender.value))
    }
}
