//
//  SwiftData Macro Demo.swift
//  SwiftMacrosAndMe
//
//  Created by Morris Richman on 6/8/25.
//

import SwiftUI
import Foundation

@Observable
class ContentViewModel {
    var text: String = "Hello, World!"
}

struct ContentView: View {
    @State var viewModel: ContentViewModel = .init()
    
    var body: some View {
        Text(viewModel.text)
    }
}

#Preview {
    ContentView()
}
