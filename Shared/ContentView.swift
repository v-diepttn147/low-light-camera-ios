//
//  ContentView.swift
//  Shared
//
//  Created by Diep Tran on 27/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @State private var isSaved = false
    
    let imageUtil = ImageUtil()
    
    var body: some View {
        ZStack {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            if isSaved {
                                
                            } else {
                                isSaved = true
                                imageUtil.writeToPhotoAlbum(image: capturedImage!)
                            }
                        }, label: {
                            Image(systemName: "square.and.arrow.down.fill")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                
                        })
                        
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                            isCustomCameraViewPresented.toggle()
                        }, label: {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                
                        })
                        .padding(.bottom)
                        .sheet(isPresented: $isCustomCameraViewPresented, content: {
                            CustomCameraView(capturedImage: $capturedImage)
                        })
                    }
                }
                
            } else {
                Color(UIColor.systemBackground)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    isCustomCameraViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        
                })
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    CustomCameraView(capturedImage: $capturedImage)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
