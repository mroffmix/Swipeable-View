//
//  SwManager.swift
//  
//
//  Created by Ilya on 14.10.20.
//

import Combine

public class SwManager: ObservableObject {
    private var views: [SWViewModel]
    private var subscriptions = Set<AnyCancellable>()
    
    public init() {
        views = []
    }
    
    public func hideAllViews() {
        self.views.forEach {
            $0.goToCenter()
        }
    }
    
    public func addView(_ view: SWViewModel) {
        views.append(view)
        
        view.stateDidChange.sink(receiveValue: { vm in
            if self.views.count != 0 {
                #if DEBUG
                //print("swiped = \(vm.id.uuidString)")
                #endif
                self.views.forEach {
                    if vm.id != $0.id && $0.state != .center{
                        $0.goToCenter()
                    }
                }
            }
        }).store(in: &subscriptions)
    }
}
