//
//  ResultView.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 26/01/2023.
//

import SwiftUI

struct ResultView: View {
    
    @ObservedObject var responseData = ResponseData.shared
    @State var lastScaleValue: CGFloat = 1.0
    
    var body: some View {
        if responseData.imageData != Image(systemName: "trash" ) {
            Spacer()
            responseData.imageData
                .resizable()
                .scaledToFit()
                .padding()
            Spacer()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
