//
//  LoaderView.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 27/01/2023.
//

import SwiftUI

struct LoaderView: View {
    
    @State var animate: Bool = false
    
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0.025, to: 0.82)
                .stroke(AngularGradient(gradient: .init(colors: [Color(.white), Color(.white)]), center: .center),  style:  StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
        }
        .background(Color.clear)
        .onAppear { self.animate.toggle() }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
