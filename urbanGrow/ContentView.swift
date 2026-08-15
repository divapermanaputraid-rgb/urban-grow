//
//  ContentView.swift
//  urbanGrow
//
//  Created by MacBook on 16/08/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "leaf.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
