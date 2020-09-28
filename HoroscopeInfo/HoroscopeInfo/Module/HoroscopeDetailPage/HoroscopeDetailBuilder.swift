//
//  HoroscopeDetailBuilder.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import UIKit

class HoroscopeDetailBuilder {
    static func make() -> HoroscopeDetailVC {
        let storyboard = UIStoryboard(name: "HoroscopeDetailView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HoroscopeDetail") as! HoroscopeDetailVC
        viewController.viewModel = HoroscopeDetailViewModel()
        return viewController
    }
}
