//
//  ViewController.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    var preRecordedAudioURL: URL = {
        return Bundle.main.url(forResource: "LX40", withExtension: "m4a")!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.setUI(status: .ready)
        default:
            break
        }
    }

    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.setUI(status: .ready)
                default:
                    self.setUI(status: .unavailable)
                }
            }
        }
    }

    func recognizeFile(url: URL) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in
            guard let result = result else {
                return
            }
            self.transcriptionTextView.text = result.bestTranscription.formattedString
            if result.isFinal {
                self.searchFlight(number: result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        }
    }
}

// MARK: - UI Management

extension ViewController {

    func searchFlight(number: String) {
        if let flight = FlightsDataSource.searchFlight(number: number) {
            transcriptionTextView.text = "\(number)\n\(flight.status)"
        } else {
            transcriptionTextView.text = "No flight \(number) found 😭"
        }
    }

    // MARK: IBActions

    @IBAction func microphonePressed(_ sender: Any) {
        recognizeFile(url: preRecordedAudioURL)
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

