//
//  SwipeableView.swift
//  SwipeableView
//
//  Created by Ilya on 10.10.20.
//

import SwiftUI

public struct SwipeableView<T,Content: View>: View  where T: SwipeableViewModel{
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: T
    @State var frame: CGSize = .zero
    @State private var actions: EditActions?
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content, viewModel: T) {
        self.content = content()
        self.viewModel = viewModel
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        DispatchQueue.main.async { self.frame = geometry.size }
        return content
    }
    
    public var body: some View {
        
        return
            ZStack {
                
                EditActions(viewModel: viewModel.actions, isShowed: $viewModel.dragOffset)
                GeometryReader { reader in
                    self.makeView(reader)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: viewModel.dragOffset.width)
                }
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    withAnimation {
                        viewModel.dragOffset = CGSize.zero
                    }
                })
                
                .gesture(
                    DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                        .onEnded { value in
                            
                            withAnimation {
                                print(viewModel.dragOffset)
                                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    viewModel.dragOffset = (CGSize.init(width: (CGFloat(min(4, viewModel.actions.actions.count)) * -80 - CGFloat(min(4, viewModel.actions.actions.count)) * 5 ), height: 0))
                                    
                                }
                                else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                                    viewModel.dragOffset = CGSize.zero
                                }
                            }
                        }
                )
            }
    }
}

class example: SwipeableViewModel {
    @Published var dragOffset: CGSize = CGSize.zero
    @Published var actions: EditActionsVM = EditActionsVM([], maxActions: 4)
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
                    
                }, viewModel: example())
                
                Spacer()
            }
        }
        
    }
}
