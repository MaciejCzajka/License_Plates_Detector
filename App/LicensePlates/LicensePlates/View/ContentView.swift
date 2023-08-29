//
//  ContentView.swift
//  LicensePlates
//
//  Created by Maciej Czajka on 25/01/2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item = ResponseData.shared
    @ObservedObject var wait = Wait.shared
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var showingCameraPicker = false
    @State private var isCameraAccessEnabled = false
    @State public var inputImage: UIImage?
    @State private var disabledButton = true
    @State private var isPresented = false
    @State private var notDetected = false
    @State private var selection: String? = nil
    private let apiManager = Api()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ResultView(), tag: "Success", selection: $selection) { EmptyView() }
                Spacer()
                if image != nil {
                    HStack {
                        Spacer()
                        image?.resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                openCamera()
                            }
                        Image(systemName: "minus.circle")
                            .foregroundColor(Color(.red))
                            .padding(5)
                            .onTapGesture {
                                withAnimation(.easeOut) {
                                    image = nil
                                    inputImage = nil
                                    disabledButton = true
                                }
                            }
                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                .padding(.top, 5)
                                .onTapGesture {
                                    self.showingImagePicker = true
                                }
                                .padding()
                            Text("Choose a photo\n from the library")
                                .multilineTextAlignment(.center)
                                
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                                .padding(.top, 5)
                                .onTapGesture {
                                    isPresented.toggle()
                                }
                                .padding()
                            Text("Take a photo\n with a camera")
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
                if disabledButton == false {
                    Button {
                        wait.wait = true
                        apiManager.getImageResponse(image: inputImage!.base64!) { res in
                            if res == true {
                                selection = "Success"
                                wait.wait = false
                                image = nil
                                inputImage = nil
                                disabledButton = true
                            } else {
                                wait.wait = false
                                notDetected.toggle()
                                image = nil
                                inputImage = nil
                                disabledButton = true
                            }
                        }
                    } label: {
                        Text("Detect license plate")
                    }
                    .disabled(disabledButton)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .cornerRadius(40)
                    .foregroundColor(Color(colorScheme == .dark ? .white : .black))
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color(colorScheme == .dark ? .white : .black), lineWidth: 2.0))
                    .padding()
                }
                Spacer()
            }
            .alert("Please take a photo horizontally", isPresented: $isPresented) {
                        Button("OK", role: .cancel) {
                            openCamera()
                        }
                    }
            .alert("No license plate detected, find another photo", isPresented: $notDetected) {
                        Button("OK", role: .cancel) {
                            // do nothing
                        }
                    }
            
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .sheet(isPresented: $showingCameraPicker, onDismiss: loadImage) {
            CameraPicker(sourceType: .camera, selectedImage: self.$inputImage)
        }
        
    }
    
    private func openCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.showingCameraPicker = true
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            self.showingCameraPicker = true
        } else {
            self.isCameraAccessEnabled = true
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        disabledButton = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImageOverlay: View {
    
    var number: String
    
    init(_ number: String) {
        self.number = number
    }
    
    var body: some View {
        ZStack {
            
            Text(number)
                .font(.system(size: 50))
                .font(.callout)
                .padding(.trailing, 30)
                .foregroundColor(.black)
        }
    }
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
