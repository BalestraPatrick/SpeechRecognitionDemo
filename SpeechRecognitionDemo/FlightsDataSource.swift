//
//  FlightsDataSource.swift
//  SpeechRecognitionDemo
//
//  Created by Patrick Balestra on 1/6/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import Foundation

struct Flight {
    let number: String
    let status: String
}

class FlightsDataSource {

    static var flights: [Flight] = {
        return [
            Flight(number: "LX40", status: "Gate 40, On Time"),
            Flight(number: "UA37", status: "Departure Scheduled"),
            Flight(number: "BA191", status: "Delayed 50 minutes"),
            Flight(number: "QR196", status: "Departure Scheduled"),
            Flight(number: "SQ326", status: "Gate 43, On Time"),
            Flight(number: "EK507", status: "Departure Scheduled"),
            Flight(number: "MH8208", status: "Landed"),
            Flight(number: "U24612", status: "Cancelled"),
            Flight(number: "SQ345", status: "Delayed 15 minutes"),
            Flight(number: "LX1486", status: "Landed"),
            Flight(number: "LX86", status: "Gate 2, On Time"),
            Flight(number: "AZ786", status: "Departure Scheduled"),
            Flight(number: "CX830", status: "Landed"),
            Flight(number: "QF15", status: "Landed"),
            Flight(number: "EY183", status: "Landed")
        ]
    }()

    static func searchFlight(number: String) -> Flight? {
        return flights.filter { number.contains($0.number) }.first
    }
}
