//
//  SymbolsPickerViewModel.swift
//  CleverOwl
//
//  Created by user228347 on 7/8/24.
//

import Foundation
public class SymbolsPickerViewModel: ObservableObject {
    
    let title: String
    let searchbarLabel: String
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    
    @Published var symbols: [String] = []
    
    init(title: String, searchbarLabel: String, autoDismiss: Bool) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss
        self.symbols = []
        self.loadSymbols()
    }
    
    public var hasMoreSymbols: Bool {
        return symbolLoader.hasMoreSymbols()
    }
    
    public func loadSymbols() {
        if(symbolLoader.hasMoreSymbols()) {
            
            symbols = symbols + symbolLoader.getSymbols()
            
        }
    }
    
    public func searchSymbols(with name: String) {
        
        symbols = symbolLoader.getSymbols(named: name)
        
    }
    
    public func reset() {
        symbolLoader.resetPagination()
        symbols.removeAll()
        loadSymbols()
    }
}
