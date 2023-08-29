//
//  WaitData.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 26/01/2023.
//

import Foundation

class Wait: ObservableObject {
    @Published var wait: Bool = false
    
    static let shared = Wait()
}
