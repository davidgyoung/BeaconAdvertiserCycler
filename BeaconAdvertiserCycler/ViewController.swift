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
    var minor: UInt16? = 1 // nil means do not advertise at all
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
        rotateAdvertisementWhenTime()
    }
    var lastRotationNumberWithinHour = -1
    func rotateAdvertisementWhenTime() {
        // Change the line below to adjust the number of seconds between rotations
        let rotationPeriodSeconds = 60
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            let secsSince1970 = Int(Date().timeIntervalSince1970)
            let minuteWithinHour = (secsSince1970 % 3600) / 60
            let rotationNumberWithinHour = (secsSince1970 % 3600) / rotationPeriodSeconds
            // check to see if we have crossed the minute boundary, otherwise do nothing here.
            if (rotationNumberWithinHour != self.lastRotationNumberWithinHour) {
                self.lastRotationNumberWithinHour = rotationNumberWithinHour
                self.stopTransmitter()
                // Uncomment this block to increment minor every minute
                //self.minor += 1
                // Uncomment this block to alternate minior between 1 and 2
                //self.minor = self.minor == 1 ? 2 : 1
                // Uncomment this block to alternate minor between 1 and 2 only on HH:00-HH:04, HH20-HH:24, HH:40-HH:44 (for five minutes three times an hour)
                if minuteWithinHour <= 4 || (minuteWithinHour >= 20 && minuteWithinHour <= 24) || (minuteWithinHour >= 40 && minuteWithinHour <= 44) {
                    self.minor = UInt16(minuteWithinHour) % 2 + 1 // minor 1 on even minutes minor 2 on odd minutes
                }
                else {
                    self.minor = nil
                }
                
                if self.minor != nil {
                    self.startTransmitter()
                }
            }
            self.rotateAdvertisementWhenTime()
        }
    }
    
    func startTransmitter() {
        transmitterOn = true
        NSLog("Starting advertisting")
        if let minor = minor {
            advertisingLabel.text = "ADVERTISING MINOR \(minor)"
            let uuid = UUID(uuidString: "00e69745-943a-45de-bf29-f80586c46c99")!
            let data = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: minor, identifier: "MyIdentifier").peripheralData(withMeasuredPower: nil)
            peripheralManager.startAdvertising(data as? [String:Any])
            advertisingLabel.textColor = .green
        }
        else {
            advertisingLabel.text = "NOT ADVERTISING NOW"
            advertisingLabel.textColor = .red
        }

    }
    func stopTransmitter() {
        transmitterOn = false
        advertisingLabel.text = "ADVERTISING OFF"
        advertisingLabel.textColor = .red
        NSLog("Stopping advertisting")
        peripheralManager.stopAdvertising()
    }


}

