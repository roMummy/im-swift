//
//  ContentView.swift
//  SPMMACExample
//
//  Created by macbook pro 2022 m2 on 2025/12/15.
//

import SwiftUI
import IMSDK

struct ContentView: View {
    var body: some View {
        VStack {
            Button.init {
                convertToPNG()
            } label: {
                Text("Convert Image")
            }
        }
        .padding()
    }
    
    private func convertToPNG() {
        let input = Bundle.main.path(forResource: "111", ofType: "jpg")!
        let output = NSTemporaryDirectory() + "output.png"
        
        let result = IMCore.shared.conver(inputPath: input, outputPath: output)
        
        IMCore.shared.progressBlock = { value in
            print("Progress: \(value)")
        }
        
        print(result.status == .success)
        
        print(output)
    }
}

#Preview {
    ContentView()
}
