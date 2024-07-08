//
//  SymbolIcon.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import Foundation
import SwiftUI

struct SymbolIcon: View {
    
    let symbolName: String
    @Binding var selection: String
    
    var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 25))
            .animation(.linear)
            .foregroundColor(self.selection == symbolName ? Color.accentColor : Color.primary)
            .onTapGesture {
                // Assign binding value
                withAnimation {
                    self.selection = symbolName
                }
            }
    }
    
}

//#Preview {
//    SymbolIcon(symbolName: "beats.powerbeatspro", selection: .constant("star.bubble"))
//}
