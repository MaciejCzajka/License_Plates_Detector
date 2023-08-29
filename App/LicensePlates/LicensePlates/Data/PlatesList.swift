//
//  PlatesList.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 26/01/2023.
//

import Foundation
import SwiftUI

class PlatesList : ObservableObject {
    @Published var imagesList: [LicensePlateItem] = [LicensePlateItem]()
    @Published var platesNumberList: [String] = UserDefaults.standard.stringArray(forKey: "platesList") ?? [String]()
    
    static let shared = PlatesList()
}
