//
//  SwipeableView.swift
//  SwipeableView
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
    @State var dragOffset: CGSize = .zero
    @State private var state: ViewState = .center
    var rounded: Bool
    var leftActions: EditActionsVM
    var rightActions: EditActionsVM
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content, leftActions: [Action], rightActions: [Action], rounded: Bool = false) {
        
        self.content = content()
        self.leftActions = EditActionsVM(leftActions, maxActions: leftActions.count)
        self.rightActions = EditActionsVM(rightActions, maxActions: rightActions.count)
        self.rounded = rounded
        self.dragOffset = .zero
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        return content
    }
    
    public var body: some View {

            ZStack {
                switch state {
                case .left:
                    EditActions(viewModel: leftActions, offset: $dragOffset, state: $state, side: .left, rounded: rounded)
                    
                case .right :
                    EditActions(viewModel: rightActions, offset: $dragOffset, state: $state, side: .right, rounded: rounded)
                case .center:
                    EmptyView()
                    
                }
                
                GeometryReader { reader in
                    self.makeView(reader)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: dragOffset.width)
                }
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    withAnimation {
                        dragOffset = CGSize.zero
                        state = .center
                    }
                })
                
                .gesture(
                    DragGesture(minimumDistance: 1.0, coordinateSpace: .local)
                        .onEnded { value in
                            
                            withAnimation {
                                
                                #if DEBUG
                                print(dragOffset)
                                #endif
                                
                                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    // left
                                    if state == .center {
                                        var offset = (CGFloat(min(4, leftActions.actions.count)) * -80)
                                        if rounded {
                                            offset -= CGFloat(min(4, leftActions.actions.count)) * 5 
                                        }
                                                      
                                        dragOffset = (CGSize.init(width: offset, height: 0))
                                        state = .left
                                    } else {
                                        dragOffset = CGSize.zero
                                        state = .center
                                    }
                                    
                                    
                                } else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    // right
                                    if state == .center {
                                        
                                        var offset = (CGFloat(min(4, rightActions.actions.count)) * +80)
                                        if rounded {
                                            offset += CGFloat(min(4, rightActions.actions.count)) * 5
                                        }
                                        
                                        dragOffset = (CGSize.init(width: offset, height: 0))
                                        state = .right
                                    } else {
                                        dragOffset = CGSize.zero
                                        state = .center
                                    }
                                    
                                }
                            }
                        }
                )
            }
    }
}

class example: SwipeableViewModel {
    @Published var leftActions: EditActionsVM = EditActionsVM([], maxActions: 4)
    @Published var rightActions: EditActionsVM = EditActionsVM([], maxActions: 4)
    @Published var dragOffset: CGSize = CGSize.zero
    
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
