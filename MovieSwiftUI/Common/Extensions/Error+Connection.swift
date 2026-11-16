//
//  Error+Connection.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

extension Error {
    var isInternetConnectionError: Bool {
        guard let urlError = self as? URLError else { return false }
        return urlError.code == .notConnectedToInternet
    }
}
