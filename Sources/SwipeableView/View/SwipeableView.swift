//
//  SwipeableView.swift
//
//
//  Created by Ilya on 10.10.20.
//

import SwiftUI

public enum ViewState: CaseIterable {
    case left
    case right
    case center
}

enum OnChangeSwipe {
    case leftStarted
    case rightStarted
    case noChange
}
public struct SwipeableView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    var rounded: Bool
    var leftActions: EditActionsVM
    var rightActions: EditActionsVM
    @ObservedObject var viewModel: SWViewModel
    
    //@State private var onChangeSwipe: OnChangeSwipe = .noChange
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content, leftActions: [Action], rightActions: [Action], rounded: Bool = false, container: SwManager? = nil ) {
        
        self.content = content()
        self.leftActions = EditActionsVM(leftActions, maxActions: leftActions.count)
        self.rightActions = EditActionsVM(rightActions, maxActions: rightActions.count)
        self.rounded = rounded
        
        viewModel = SWViewModel(state: .center, size: .zero)
        container?.addView(viewModel)
        
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        return content
    }
    
    private func makeActions() -> AnyView {
        switch viewModel.onChangeSwipe {
        case .leftStarted:
            
            return AnyView(EditActions(viewModel: leftActions,
                                       offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                       state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                       onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                       side: .left,
                                       rounded: rounded)
                            .transition(.slide))
                
            
        case .rightStarted :
            
            return AnyView(EditActions(viewModel: rightActions,
                                       offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                       state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                       onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                       side: .right,
                                       rounded: rounded)
                            .transition(.slide))
                    
        case .noChange:
            return AnyView(EmptyView())
            
        }
    }
    
    private func toCenterWithAnimation() {
        withAnimation(.easeOut) {
            self.viewModel.dragOffset = CGSize.zero
            self.viewModel.state = .center
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.easeOut) {
                if self.viewModel.state == .center {
                    self.viewModel.onChangeSwipe = .noChange
                }
            }
        }
    }
    
    private func onChanged(value: DragGesture.Value){

        if self.viewModel.state == .center {
            if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                self.viewModel.onChangeSwipe = .leftStarted
                self.viewModel.dragOffset.width = value.translation.width
            } else if self.viewModel.dragOffset.width >= 0 && value.translation.height > -30 && value.translation.height < 30{
                
                self.viewModel.onChangeSwipe = .rightStarted
                self.viewModel.dragOffset.width = value.translation.width
            }
        } else {
           
            self.viewModel.dragOffset.width =  self.viewModel.dragOffset.width + ((value.translation.width < 0) ? -2 : 2)
        }
        
    }
    

    
    private func onEnded(value: DragGesture.Value){
        
        #if DEBUG
        // print(viewModel.dragOffset)
        #endif
        
        if self.viewModel.dragOffset.width < 0 {
            // left
            if self.viewModel.state == .center && value.translation.width < -50 {
                
                var offset = (CGFloat(min(4, self.leftActions.actions.count)) * -80)
                
                if self.rounded {
                    offset -= CGFloat(min(4, self.leftActions.actions.count)) * 5
                }
                withAnimation(.easeOut) {
                    self.viewModel.dragOffset = CGSize.init(width: offset, height: 0)
                    self.viewModel.state = .left
                }
                
            } else {
                self.toCenterWithAnimation()
            }
            
            
        } else if self.viewModel.dragOffset.width > 0 {
            // right
            if self.viewModel.state == .center && value.translation.width > 50{
                
                var offset = (CGFloat(min(4, self.rightActions.actions.count)) * +80)
                if self.rounded {
                    offset += CGFloat(min(4, self.rightActions.actions.count)) * 5
                }
                withAnimation(.easeOut) {
                    self.viewModel.dragOffset = (CGSize.init(width: offset, height: 0))
                    self.viewModel.state = .right
                }
            } else {
                self.toCenterWithAnimation()
            }
            
        }
        
    }
    
    public var body: some View {
        
        ZStack {
            makeActions()
            GeometryReader { reader in
                self.makeView(reader)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: self.viewModel.dragOffset.width)
                    
                    .onTapGesture(count: 1, perform: { toCenterWithAnimation()})
                    .gesture( DragGesture(minimumDistance: 10.0, coordinateSpace: .local).onChanged(onChanged(value:)).onEnded(onEnded(value:)))
            }
            
        }
    }
}

@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { reader in
            VStack {
                Spacer()
                SwipeableView(content: {
                    GroupBox {
                        Text("View content")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                },
                leftActions:[
                    Action(title: "Note", iconName: "pencil", bgColor: .note, action: {}),
                    Action(title: "Edit doc", iconName: "doc.text", bgColor: .edit, action: {}),
                    Action(title: "New doc", iconName: "doc.text.fill", bgColor: .done, action: {})
                ],
                rightActions: [
                    Action(title: "Note", iconName: "pencil", bgColor: .note, action: {}),
                    Action(title: "Edit doc", iconName: "doc.text", bgColor: .edit, action: {})
                ],
                rounded: true
                ).frame(height: 90)
                
                Spacer()
            }
        }
        
    }
}
