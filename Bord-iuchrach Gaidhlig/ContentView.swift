//
//  ContentView.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/11/21.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var text: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Hello, world!")
                    .padding()
                TextField("Some test text", text: $text)
                    .padding()
                    .background(Color(white: 0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
