//
//  TimezoneConverter.swift
//  HoroscopeInfoTests
//
//  Created by Yusuf Özgül on 29.09.2020.
//

import Foundation
import CoreLocation

enum TimezoneConverterErrorType: Error {
    case error(String)
    case nilTimezone
}

class TimezoneConverter {
    class func getTimezone(from altitude: Double, longitude: Double, completion: @escaping(Result<TimeZone, TimezoneConverterErrorType>) -> Void) {
        let location = CLLocation(latitude: altitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
            if let error = err {
                completion(.failure(.error(error.localizedDescription)))
            } else {
                if let placemark = placemarks?[0], let timeZone = placemark.timeZone {
                    completion(.success(timeZone))
                } else {
                    completion(.failure(.nilTimezone))
                }
            }
        }
    }
}

