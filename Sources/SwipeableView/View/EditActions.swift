//
//  EditActions.swift
//  
//
//  Created by Ilya on 13.10.20.
//

import SwiftUI


enum ActionSide: CaseIterable {
    case left
    case right
}

public struct EditActions: View {
    
    @ObservedObject var viewModel: EditActionsVM
    @Binding var offset: CGSize
    @Binding var state: ViewState
    @State var side: ActionSide
    @State var rounded: Bool
    
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        #if DEBUG
        print("EditActions: = \(geometry.size.width) , \(geometry.size.height)")
        #endif
        
        return HStack(alignment: .center, spacing: rounded ? 5 : 0) {
            ForEach(viewModel.actions) { action in
                Button(action: {
                    action.action()
                    withAnimation {
                        offset = .zero
                        state = .center
                    }
                }, label: {
                    VStack (alignment: .center, spacing: 0){
                        Image(systemName: action.iconName)
                            .font(.system(size: 20))
                            .padding(.bottom, 8)
                        
                        if viewModel.actions.count < 4 && geometry.size.height > 50 {
                            
                            Text(action.title)
                                .font(.system(size: 10, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                        
                    }
                    .padding()
                    .frame(width: 80, height: geometry.size.height)
                    .background(action.bgColor.value.saturation(0.8))
                    .cornerRadius(rounded ? 10 : 0)
                })
                .accentColor(.white)
            }
        }
    }
    
    public var body: some View {
        
        GeometryReader { reader in
            HStack {
                switch side {
                case .left:
                    Spacer ()
                    self.makeView(reader)
                    
                case .right:
                    self.makeView(reader)
                    Spacer ()
                }
            }
            
        }
    }
}

struct EditActions_Previews: PreviewProvider {
    
    static var actions = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {}),
        Action(title: "Request offer", iconName: "doc.text", bgColor: .edit, action: {}),
        Action(title: "Order", iconName: "doc.text.fill", bgColor: .delete, action: {}),
        Action(title: "Order provided", iconName: "car", bgColor: .done, action: {}),
    ]
    static var previews: some View {
        Group {
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), side: .right, rounded: false)
                .previewLayout(.fixed(width: 450, height: 400))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), side: .left, rounded: false)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 2), offset: .constant(.zero), state: .constant(.center), side: .left, rounded: false)
                .previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 3), offset: .constant(.zero), state: .constant(.center), side: .right, rounded: true)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), side: .left, rounded: true)
                .previewLayout(.fixed(width: 550, height: 280))
            
            
        }
    }
}

