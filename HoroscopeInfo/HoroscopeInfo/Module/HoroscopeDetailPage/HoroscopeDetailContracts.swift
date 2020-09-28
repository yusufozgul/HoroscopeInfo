//
//  HoroscopeDetailContracts.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation


protocol HoroscopeDetailViewModelProtocol {
    var delegate: HoroscopeDetailViewModelDelegate? { get set }
    func load(birthDate: Date, lat: String, lon: String)
}

enum HoroscopeDetailViewModelOutput {
    case setLoading(Bool)
    case showDetail(HoroscopeDetailCollectionSnapshot)
    case showError(String)
}

protocol HoroscopeDetailViewModelDelegate: class {
    func handleOutput(_ output: HoroscopeDetailViewModelOutput)
}
