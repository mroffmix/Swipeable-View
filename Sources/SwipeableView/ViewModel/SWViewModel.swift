//
//  File.swift
//  
//
//  Created by Ilya on 14.10.20.
//

import SwiftUI
import Combine

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
    let otherActionTapped = PassthroughSubject<Bool, Never>()
    
    init(state: ViewState, size: CGSize) {
        self.state = state
        self.dragOffset = size
    }
    
    public func otherTapped(){
        self.otherActionTapped.send(true)
    }
    
    public func goToCenter(){
        self.dragOffset = .zero
        self.state = .center
        self.onChangeSwipe = .noChange
    }
}
