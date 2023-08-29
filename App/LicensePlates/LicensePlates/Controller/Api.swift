//
//  Api.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 25/01/2023.
//

import Foundation
import Alamofire
import SwiftUI

private let _apiAddress_ = "http://192.168.5.129:8080"

let evaluators:[String:ServerTrustEvaluating]=[
    _apiAddress_:DisabledTrustEvaluator()
]
let manager=ServerTrustManager(evaluators: evaluators)
let session=Session.init(serverTrustManager:manager)

class Api {
    
    func getImageResponse(image: String, completion: @escaping(Bool?) -> Void) {
        let endpointAddress = _apiAddress_ + "/detectLicense"
        let parameters = ["imageFile": image] as [String : Any]
        
        session.request(endpointAddress, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case.success:
                    if response.response?.statusCode == 200 {
                        var responseData = ""
                        do {
                            responseData = try JSONDecoder().decode(String.self, from: response.data!)
                            if responseData != "None" {
                                responseData = responseData.replacingOccurrences(of: "b'", with: "")
                                responseData = String(responseData.replacingOccurrences(of: "\'", with: ""))
                                responseData = responseData.fixedBase64Format
                                
                                let myUIImage = responseData.imageFromBase64
                                
                                let new_image = Image(uiImage: myUIImage!)
                                ResponseData.shared.imageData = new_image
                                PlatesList.shared.imagesList.append(LicensePlateItem(image: new_image))
                                
                                ResponseData.shared.uiImageData = myUIImage!
                                self.getPlatsNumberResponse(image: image) { res in
                                    if res == true {
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                }
                            } else {
                                completion(false)
                            }
                            
                        } catch {
                            print("Error: \(error)")
                            completion(false)
                        }
                        
                        
                    } else {
                        completion(false)
                    }
                case.failure:
                    completion(false)
                }
            }
    }
    
    func getPlatsNumberResponse(image: String, completion: @escaping(Bool?) -> Void) {
        let endpointAddress = _apiAddress_ + "/getPlatesNumber"
        let parameters = ["imageFile": image] as [String : Any]
        
        session.request(endpointAddress, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case.success:
                    if response.response?.statusCode == 200 {
                        let jsonData = response.data
                        do {
                            let allReplies = try JSONDecoder().decode(PlatesNumberItem.self, from: jsonData!)
                            
                            if allReplies.platesNumber != ["None"] {
                                
                                for n in allReplies.platesNumber {
                                    PlatesList.shared.platesNumberList.append(n)
                                }
                                
                                UserDefaults.standard.set(PlatesList.shared.platesNumberList, forKey: "platesList")
                                
                                completion(true)
                            } else {
                                completion(false)
                            }
                            
                        } catch {
                            print("Error: \(error)")
                            completion(false)
                        }
                        
                        
                    } else {
                        completion(false)
                    }
                case.failure:
                    completion(false)
                }
            }
    }
}

extension String {
    var fixedBase64Format: Self {
        let offset = count % 4
        guard offset != 0 else { return self }
        return padding(toLength: count + 4 - offset, withPad: "=", startingAt: 0)
    }
}
