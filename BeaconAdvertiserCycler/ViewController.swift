//
//  ViewController.swift
//  BeaconAdvertiserCycler
//
//  Created by David G. Young on 4/20/22.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    var minor: UInt16 = 1
    var peripheralManager: CBPeripheralManager!
    var transmitterOn = false
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startTransmitter()
        }
    }
    
    @IBOutlet weak var advertisingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager =  CBPeripheralManager(delegate: self, queue: nil)
        rotateAdvertisement()
    }
    func rotateAdvertisement() {
        // Change the line below to adjust the number of seconds between rotations
        let rotationPeriodSeconds = 60.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+rotationPeriodSeconds) {
            self.stopTransmitter()            
            // Uncomment this line to increment minor every
            self.minor += 1
            // Uncomment this line to alternate minior between 1 and 2
            // self.minor = self.minor == 1 ? 2 : 1
            self.startTransmitter()
            self.rotateAdvertisement()
        }
    }
    
    func startTransmitter() {
        transmitterOn = true
        NSLog("Starting advertisting")
        advertisingLabel.text = "ADVERTISING MINOR \(minor)"
        advertisingLabel.textColor = .green

        let uuid = UUID(uuidString: "00e69745-943a-45de-bf29-f80586c46c99")!
        let data = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: minor, identifier: "MyIdentifier").peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising(data as? [String:Any])
    }
    func stopTransmitter() {
        transmitterOn = false
        advertisingLabel.text = "ADVERTISING OFF"
        advertisingLabel.textColor = .red
        NSLog("Stopping advertisting")
        peripheralManager.stopAdvertising()
    }


}

