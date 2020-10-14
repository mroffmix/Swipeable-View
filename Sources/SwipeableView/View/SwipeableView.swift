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

public struct SwipeableView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    var rounded: Bool
    var leftActions: EditActionsVM
    var rightActions: EditActionsVM
    @ObservedObject var viewModel: SWViewModel
    
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
    
    public var body: some View {

            ZStack {
                
                switch viewModel.state {
                case .left:
                    
                    EditActions(viewModel: leftActions,
                                offset: .init(get: {viewModel.dragOffset}, set: {viewModel.dragOffset = $0}),
                                state: .init(get: {viewModel.state}, set: {viewModel.state = $0}),
                                side: .left,
                                rounded: rounded)
                    
                case .right :
                    
                    EditActions(viewModel: rightActions,
                                offset: .init(get: {viewModel.dragOffset}, set: {viewModel.dragOffset = $0}),
                                state: .init(get: {viewModel.state}, set: {viewModel.state = $0}),
                                side: .right,
                                rounded: rounded)
                case .center:
                    EmptyView()
                    
                }
                
                GeometryReader { reader in
                    self.makeView(reader)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: viewModel.dragOffset.width)
                }
                .onTapGesture(count: 1, perform: {
                    withAnimation {
                        viewModel.dragOffset = CGSize.zero
                        viewModel.state = .center
                    }
                })
                
                .gesture(
                    DragGesture(minimumDistance: 1.0, coordinateSpace: .local)
                        .onEnded { value in
                            
                            withAnimation {
                                
                                #if DEBUG
                                print(viewModel.dragOffset)
                                #endif
                                
                                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    // left
                                    if viewModel.state == .center {
                                        var offset = (CGFloat(min(4, leftActions.actions.count)) * -80)
                                        if rounded {
                                            offset -= CGFloat(min(4, leftActions.actions.count)) * 5 
                                        }
                                                      
                                        viewModel.dragOffset = CGSize.init(width: offset, height: 0)
                                        viewModel.state = .left
                                    } else {
                                        viewModel.dragOffset = CGSize.zero
                                        viewModel.state = .center
                                    }
                                    
                                    
                                } else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    // right
                                    if viewModel.state == .center {
                                        
                                        var offset = (CGFloat(min(4, rightActions.actions.count)) * +80)
                                        if rounded {
                                            offset += CGFloat(min(4, rightActions.actions.count)) * 5
                                        }
                                        
                                        viewModel.dragOffset = (CGSize.init(width: offset, height: 0))
                                        viewModel.state = .right
                                    } else {
                                        viewModel.dragOffset = CGSize.zero
                                        viewModel.state = .center
                                    }
                                    
                                }
                            }
                        }
                )
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
                    HStack {
                        Spacer()
                        Text("View content")
                        Spacer()
                    }.padding()
                    .background(Color.blue)
                    
                },
                leftActions:[],
                rightActions: []
                )
                
                Spacer()
            }
        }
        
    }
}
