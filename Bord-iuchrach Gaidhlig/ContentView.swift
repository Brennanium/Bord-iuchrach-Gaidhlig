//
//  ContentView.swift
//  Bord-iuchrach Gaidhlig
//
//  Created by Brennan Drew on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            TextField("Some test text", text: $text)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
