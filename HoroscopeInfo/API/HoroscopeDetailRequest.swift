//
//  HoroscopeDetailRequest.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

struct HoroscopeDetailRequest: ApiRequestProtocol {
    var method: HttpMethod = .POST
    var url: String = "astro_details"
    var body: Encodable?
    
    init(data: HoroscopeDetailRequestData) {
        self.body = data
    }
}

struct HoroscopeDetailRequestData: Encodable {
    var day: Int
    var month: Int
    var year: Int
    var hour: Int
    var min: Int
    var lat: Double
    var lon: Double
    var tzone: Double
}

struct HoroscopeDetailRequestResponse: Decodable, Equatable {
    let ascendant, ascendantLord, varna, vashya: String?
    let yoni, gan, nadi, signLord: String?
    let sign, naksahtra, naksahtraLord: String?
    let charan: Int?
    let yog, karan, tithi, yunja: String?
    let tatva, nameAlphabet, paya: String?
    
    enum CodingKeys: String, CodingKey {
        case ascendant
        case ascendantLord = "ascendant_lord"
        case varna = "Varna"
        case vashya = "Vashya"
        case yoni = "Yoni"
        case gan = "Gan"
        case nadi = "Nadi"
        case signLord = "SignLord"
        case sign
        case naksahtra = "Naksahtra"
        case naksahtraLord = "NaksahtraLord"
        case charan = "Charan"
        case yog = "Yog"
        case karan = "Karan"
        case tithi = "Tithi"
        case yunja, tatva
        case nameAlphabet = "name_alphabet"
        case paya
    }
}
