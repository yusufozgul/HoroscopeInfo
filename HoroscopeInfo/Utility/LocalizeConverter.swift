//
//  LocalizeConverter.swift
//  HoroscopeInfo
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

extension String {
    var localized: String { return NSLocalizedString(self, comment: self) }
}
