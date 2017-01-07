//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var flightTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

    }

    // TODO
}

// MARK: - UI Management

extension ViewController {

    func searchFlight(number: String) {
        if let flight = FlightsDataSource.searchFlight(number: number) {
            flightTextView.text = "\(number)\n\(flight.status)"
        } else {
            flightTextView.text = "No flight \(number) found 😭"
        }
    }

    // MARK: IBActions

    @IBAction func microphonePressed(_ sender: Any) {
        
    }
}


// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FlightsDataSource.flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        let flight = FlightsDataSource.flights[indexPath.row]
        cell.textLabel?.text = flight.number
        cell.detailTextLabel?.text = flight.status
        return cell
    }
}

