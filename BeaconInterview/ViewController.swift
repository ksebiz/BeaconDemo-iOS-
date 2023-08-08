//
//  ViewController.swift
//  BeaconInterview
//
//  Created by Hari Krishna on 8/2/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var beaconTableView: UITableView!

  /// This location manager is used to demonstrate how to range beacons.
  var locationManager = CLLocationManager()

  var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
  var beacons = [CLProximity: [CLBeacon]]()

  override func viewDidLoad() {
    super.viewDidLoad()

    beaconTableView.register([BeaconListCell.className])
    locationManager.delegate = self
  }

  @IBAction func addUUIDAction(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add Beacon UUID",
                                  message: "Enter UUID",
                                  preferredStyle: .alert)

    var uuidTextField: UITextField!

    alert.addTextField { textField in
      textField.placeholder = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
      uuidTextField = textField
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let addAction = UIAlertAction(title: "Add", style: .default) { alert in
      if let uuidString = uuidTextField.text, let uuid = UUID(uuidString: uuidString) {
        self.locationManager.requestWhenInUseAuthorization()

        // Create a new constraint and add it to the dictionary.
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        self.beaconConstraints[constraint] = []


        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
        self.locationManager.startMonitoring(for: beaconRegion)
      } else {
        let invalidAlert = UIAlertController(title: "Invalid UUID",
                                             message: "Please specify a valid UUID.",
                                             preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        invalidAlert.addAction(okAction)
        self.present(invalidAlert, animated: true)
      }
    }

    alert.addAction(cancelAction)
    alert.addAction(addAction)

    present(alert, animated: true)
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return beacons.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Array(beacons.values)[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = beaconTableView.dequeueReusableCell(withIdentifier: BeaconListCell.className, for: indexPath) as! BeaconListCell

    let sectionkey = Array(beacons.keys)[indexPath.section]
    let beaconInfo = beacons[sectionkey]![indexPath.row]

    cell.uuidLabel.text = "UUID:- \(beaconInfo.uuid)"
    cell.majorLabel.text = "Major:- \(beaconInfo.major)"
    cell.minorLabel.text = "Minor:- \(beaconInfo.minor)"
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension ViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    let beaconRegion = region as? CLBeaconRegion
    if state == .inside {
      // Start ranging when inside a region.
      manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
    } else {
      // Stop ranging when not inside a region.
      manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
    }
  }

  /// - Tag: didRange
  func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    /*
     Beacons are categorized by proximity. A beacon can satisfy
     multiple constraints and can be displayed multiple times.
     */

    beaconConstraints[beaconConstraint] = beacons

    self.beacons.removeAll()

    var allBeacons = [CLBeacon]()

    for regionResult in beaconConstraints.values {
      allBeacons.append(contentsOf: regionResult)
    }

    for range in [CLProximity.unknown, .immediate, .near, .far] {
      let proximityBeacons = allBeacons.filter { $0.proximity == range }
      if !proximityBeacons.isEmpty {
        self.beacons[range] = proximityBeacons
      }
    }
    beaconTableView.reloadData()

  }
}
