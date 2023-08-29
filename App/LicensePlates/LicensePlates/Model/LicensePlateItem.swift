//
//  LicensePlateItem.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 26/01/2023.
//

import Foundation
import SwiftUI

struct LicensePlateItem {
    var id = UUID()
    var image: Image
}

struct PlatesNumberItem: Codable {
    var platesNumber: [String]
}
