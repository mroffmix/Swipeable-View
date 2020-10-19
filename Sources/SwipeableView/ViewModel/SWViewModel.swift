//
//  File.swift
//  
//
//  Created by Ilya on 14.10.20.
//

import Combine
import SwiftUI

public class SWViewModel: ObservableObject {
    let id: UUID = UUID.init()
    @Published var state: ViewState {
        didSet {
            if state != .center {
                self.stateDidChange.send(self)
            }
        }
    }
    
    @Published var onChangeSwipe: OnChangeSwipe = .noChange
    @Published var dragOffset: CGSize
    
    let stateDidChange = PassthroughSubject<SWViewModel, Never>()
    
    init(state: ViewState, size: CGSize) {
        self.state = state
        self.dragOffset = size
    }
    
    public func goToCenter(){
        DispatchQueue.main.async {
        
            withAnimation {
              
                self.dragOffset = .zero
            }
            
            withAnimation {
                self.state = .center
                self.onChangeSwipe = .noChange
               
            }
        }
          
        
    }
}
