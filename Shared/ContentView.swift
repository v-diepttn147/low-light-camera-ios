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
    
    var body: some View {
        ZStack {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
            } else {
                Color(UIColor.systemBackground)
            }
            
            HStack {
                
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
