//
//  SearchForm.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import Foundation
import SwiftUI

struct SearchForm: View {
    
    @Binding var searchText: String
    let label: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(label, text: $searchText)
                
                if(!searchText.isEmpty) {
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
            }
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .padding(.trailing, 15)
                .foregroundColor(.secondary)
#if os(iOS)
                .background(Color(.systemGray6))
#else
                .background(Color(.systemGray))
#endif
                .cornerRadius(8)
                .padding(.horizontal, 5)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

//#Preview {
//    SearchBar(searchText: .constant(""), label: "Search...")
//}
