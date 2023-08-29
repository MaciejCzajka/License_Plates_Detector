//
//  MenuView.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 26/01/2023.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var wait = Wait.shared
    
    var body: some View {
        ZStack {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "camera")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        Text("Photo")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    }
                PlatesListView()
                    .tabItem {
                        Image(systemName: "list.dash")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        Text("History")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    }
            }
            .accentColor(Color(colorScheme == .dark ? .white : .black))
            
            if wait.wait {
                GeometryReader { _ in
                    LoaderView().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .background(Color.black.opacity(0.45))
                .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
