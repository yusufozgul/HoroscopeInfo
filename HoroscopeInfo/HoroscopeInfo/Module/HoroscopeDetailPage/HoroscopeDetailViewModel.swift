//
//  HoroscopeDetailViewModel.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

class HoroscopeDetailViewModel {
    weak var delegate: HoroscopeDetailViewModelDelegate?
    private let service: ApiService<HoroscopeDetailRequestResponse>!
    
    init() {
        service = ApiService<HoroscopeDetailRequestResponse>()
    }
}

extension HoroscopeDetailViewModel: HoroscopeDetailViewModelProtocol {
    
    func load(birthDate: Date, lat: String, lon: String) {
        guard let lat = Double(lat), let lon = Double(lon) else {
            notify(.showError("COORDINATES_ERROR".localized))
            return
        }
        
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: birthDate)
        guard let day = component.day, let month = component.month, let year = component.year, let hour = component.hour, let min = component.minute else {
            notify(.showError("DATE_ERROR".localized))
            return
        }
        
        TimezoneConverter.getTimezone(from: lat, longitude: lon) { (result) in
            switch result {
            case .success(let timeZone):
                print(timeZone)
                let data = HoroscopeDetailRequestData(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: 5.5)
                self.sendRequest(data: data)
            case .failure(let error):
                self.notify(.showError(error.localizedDescription))
            }
        }
    }
    func sendRequest(data: HoroscopeDetailRequestData) {
        notify(.setLoading(true))
        let request = HoroscopeDetailRequest(data: data)
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                var snapShot = HoroscopeDetailCollectionSnapshot()
                snapShot.appendSections([.main])
                var dataArray: [HoroscopeDetailCellData] = []
                if let ascendant = data.ascendant { dataArray.append(HoroscopeDetailCellData(key: "ascendant", value: ascendant)) }
                if let ascendantLord = data.ascendantLord { dataArray.append(HoroscopeDetailCellData(key: "ascendantLord", value: ascendantLord)) }
                if let varna = data.varna { dataArray.append(HoroscopeDetailCellData(key: "varna", value: varna)) }
                if let vashya = data.vashya { dataArray.append(HoroscopeDetailCellData(key: "vashya", value: vashya)) }
                if let yoni = data.yoni { dataArray.append(HoroscopeDetailCellData(key: "yoni", value: yoni)) }
                if let gan = data.gan { dataArray.append(HoroscopeDetailCellData(key: "gan", value: gan)) }
                if let nadi = data.nadi { dataArray.append(HoroscopeDetailCellData(key: "nadi", value: nadi)) }
                if let signLord = data.signLord { dataArray.append(HoroscopeDetailCellData(key: "signLord", value: signLord)) }
                if let sign = data.sign { dataArray.append(HoroscopeDetailCellData(key: "sign", value: sign)) }
                if let naksahtra = data.naksahtra { dataArray.append(HoroscopeDetailCellData(key: "naksahtra", value: naksahtra)) }
                if let naksahtraLord = data.naksahtraLord { dataArray.append(HoroscopeDetailCellData(key: "naksahtraLord", value: naksahtraLord)) }
                if let charan = data.charan { dataArray.append(HoroscopeDetailCellData(key: "charan", value: "\(charan)")) }
                if let yog = data.yog { dataArray.append(HoroscopeDetailCellData(key: "yog", value: yog)) }
                if let karan = data.karan { dataArray.append(HoroscopeDetailCellData(key: "karan", value: karan)) }
                if let tithi = data.tithi { dataArray.append(HoroscopeDetailCellData(key: "tithi", value: tithi)) }
                if let yunja = data.yunja { dataArray.append(HoroscopeDetailCellData(key: "yunja", value: yunja)) }
                if let tatva = data.tatva { dataArray.append(HoroscopeDetailCellData(key: "tatva", value: tatva)) }
                if let nameAlphabet = data.nameAlphabet { dataArray.append(HoroscopeDetailCellData(key: "nameAlphabet", value: nameAlphabet)) }
                if let paya = data.paya { dataArray.append(HoroscopeDetailCellData(key: "paya", value: paya)) }
                snapShot.appendItems(dataArray, toSection: .main)
                self.notify(.showDetail(snapShot))
            case .failure(let error):
                self.notify(.showError(error.localizedDescription))
            }
            self.notify(.setLoading(false))
        }
    }
    
    private func notify(_ output: HoroscopeDetailViewModelOutput) {
            delegate?.handleOutput(output)
    }
}

struct HoroscopeDetailCellData: Hashable {
    let id = UUID()
    let key: String
    let value: String
}
