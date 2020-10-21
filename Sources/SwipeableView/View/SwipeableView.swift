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
    @ObservedObject var viewModel: SWViewModel
    var container: SwManager?
    var rounded: Bool
    var leftActions: EditActionsVM
    var rightActions: EditActionsVM    
    let content: Content
    
    @State var finishedOffset: CGSize = .zero
    
    public init(@ViewBuilder content: () -> Content, leftActions: [Action], rightActions: [Action], rounded: Bool = false, container: SwManager? = nil ) {
        
        self.content = content()
        self.leftActions = EditActionsVM(leftActions, maxActions: leftActions.count)
        self.rightActions = EditActionsVM(rightActions, maxActions: rightActions.count)
        self.rounded = rounded
        
        viewModel = SWViewModel(state: .center, size: .zero)
        self.container = container
        
        container?.addView(viewModel)
        
        
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        return content
    }
    
    public var body: some View {
        
        let dragGesture = DragGesture(minimumDistance: 1.0, coordinateSpace: .global)
            .onChanged(self.onChanged(value:))
            .onEnded(self.onEnded(value:))
        
        return GeometryReader { reader in
            self.makeLeftActions()
            self.makeView(reader)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: self.viewModel.dragOffset.width)
                .zIndex(100)
                .onTapGesture(count: 1, perform: { self.toCenterWithAnimation()})
                .highPriorityGesture( dragGesture )
            self.makeRightActions()
        }
    }
    
    private func makeRightActions() -> AnyView {
        
        return AnyView(EditActions(viewModel: rightActions,
                                   offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                   state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                   onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                   side: .right,
                                   rounded: rounded)
                        .animation(.easeInOut))
    }
    
    private func makeLeftActions() -> AnyView {
        
        return AnyView(EditActions(viewModel: leftActions,
                                   offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                   state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                   onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                   side: .left,
                                   rounded: rounded)
                        .animation(.easeInOut))
    }
    
    private func toCenterWithAnimation() {
        withAnimation(.easeOut) {
            self.viewModel.dragOffset = CGSize.zero
            self.viewModel.state = .center
            self.viewModel.onChangeSwipe = .noChange
            self.viewModel.otherTapped()
        }
    }
    
    private func onChanged(value: DragGesture.Value) {
        
        if self.viewModel.state == .center {
            
            if value.translation.width <= 0  {
                //&& value.translation.height > -60 && value.translation.height < 60
                self.viewModel.onChangeSwipe = .leftStarted
                self.viewModel.dragOffset.width = value.translation.width
                
            } else if self.viewModel.dragOffset.width >= 0 {
                //&& value.translation.height > -60 && value.translation.height < 60
                
                self.viewModel.onChangeSwipe = .rightStarted
                self.viewModel.dragOffset.width = value.translation.width
            }
        } else {
            // print(value.translation.width)
            if self.viewModel.dragOffset.width != .zero {
                self.viewModel.dragOffset.width = finishedOffset.width + value.translation.width
                //  print(self.viewModel.dragOffset.width)
            } else {
                self.viewModel.onChangeSwipe = .noChange
                self.viewModel.state = .center
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value) {
        
        finishedOffset = value.translation
        
        if self.viewModel.dragOffset.width <= 0 {
            // left
            if self.viewModel.state == .center && value.translation.width <= -50 {
                
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
                finishedOffset = .zero
            }
            
            
        } else if self.viewModel.dragOffset.width >= 0 {
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
    
    
}

@available(iOS 14.0, *)
struct SwipebleView_Previews: PreviewProvider {
    @ObservedObject static var container = SwManager()
    static var previews: some View {
        
        let left = [
            Action(title: "Note", iconName: "pencil", bgColor: .red, action: {}),
            Action(title: "Edit doc", iconName: "doc.text", bgColor: .yellow, action: {}),
            Action(title: "New doc", iconName: "doc.text.fill", bgColor: .green, action: {})
        ]
        
        let right = [
            Action(title: "Note", iconName: "pencil", bgColor: .blue, action: {}),
            Action(title: "Edit doc", iconName: "doc.text", bgColor: .yellow, action: {})
        ]
        
        return GeometryReader { reader in
            VStack {
                Spacer()
                HStack {
                    Text("Independed view:")
                        .bold()
                    Spacer()
                }
                SwipeableView(content: {
                    GroupBox {
                        Text("View content")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                },
                leftActions: left,
                rightActions: right,
                rounded: true
                ).frame(height: 90)
                HStack {
                    Text("Container:")
                        .bold()
                    Spacer()
                }
                
                
                SwipeableView(content: {
                    Text("View content")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.5))
                },
                leftActions: left,
                rightActions: right,
                rounded: false,
                container: container
                ).frame(height: 90)
                
                SwipeableView(content: {
                    Text("View content")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.5))
                },
                leftActions: left,
                rightActions: right,
                rounded: false,
                container: container
                ).frame(height: 90)
                
                Spacer()
            }.padding()
        }
        
    }
}
