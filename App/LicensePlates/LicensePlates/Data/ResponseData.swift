//
//  ResponseData.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 25/01/2023.
//

import Foundation
import SwiftUI

class ResponseData: ObservableObject {
    @Published var str: String = ""
    @Published var imageData: Image = Image(systemName: "trash")
    @Published var uiImageData: UIImage = UIImage()
    
    static let shared = ResponseData()
}
