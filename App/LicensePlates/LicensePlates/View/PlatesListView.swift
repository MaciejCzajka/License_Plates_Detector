//
//  CodesListView.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 25/01/2023.
//

import SwiftUI

struct PlatesListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var imagesList = PlatesList.shared
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if imagesList.platesNumberList.isEmpty {
                    Text("No history")
                } else {
                    List {
                        ForEach(imagesList.platesNumberList, id: \.self) { item in
                            Image("plate")
                                .resizable()
                                .scaledToFit()
                                .overlay(ImageOverlay(item), alignment: .trailing)
                        }
                        .onDelete(perform: removeRows)
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    }
                }
            }
            .alert(isPresented: $isPresented, content: {
                Alert(title: Text("Do you want to delete the history?"),
                      primaryButton: .default(Text("No")){
                },
                      secondaryButton:.default(Text("Yes")) {
                    UserDefaults.standard.set([String](), forKey: "platesList")
                    imagesList.platesNumberList = UserDefaults.standard.stringArray(forKey: "platesList") ?? [String]()
                })
            })
        }
    }
    func removeRows(at offsets: IndexSet) {
        imagesList.platesNumberList.remove(atOffsets: offsets)
        UserDefaults.standard.set(imagesList.platesNumberList, forKey: "platesList")
    }
}

struct PlatesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlatesListView()
    }
}
