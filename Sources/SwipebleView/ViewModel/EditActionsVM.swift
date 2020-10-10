//
//  EditActionsVM.swift
//  SwipebleView
//
//  Created by Ilya on 10.10.20.
//

import SwiftUI

enum EditActionColor {
    case edit
    case delete
    case done
    case note
}

extension EditActionColor {
    var value: Color {
        get {
            switch self {
            case .delete: return .red
            case .done: return .green
            case .edit: return .yellow
            case .note: return .blue
            }
        }
    }
}

struct Action: Identifiable {
    let id: UUID = UUID.init()
    let title: String
    let iconName: String
    let bgColor: EditActionColor
    let action: () -> ()?
}

class EditActionsVM: ObservableObject {
    let actions: [Action]
    init(_ actions: [Action]) {
        self.actions = Array(actions.prefix(4))
    }
}

struct EditActions: View {
    
    @ObservedObject var viewModel: EditActionsVM
    
    var body: some View {
        
        GeometryReader { reader in
            HStack {
                Spacer ()
                HStack(alignment: .top, spacing: 5) {
                    ForEach(viewModel.actions) { action in
                        Button(action: {
                            action.action()
                        }, label: {
                            VStack {
                                Image(systemName: action.iconName)
                                    .font(.system(size: 25))
                                    .padding()
                                if viewModel.actions.count < 4 {
                                    Text(action.title)
                                        .font(.system(size: 12))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                    //Spacer()
                                }
                                
                            }
                            .frame(maxHeight: .infinity)
                            .frame(maxWidth: (reader.size.width)/CGFloat(viewModel.actions.count))
                            .padding(8)
                            .background(action.bgColor.value.opacity(0.8))
                            .cornerRadius(10)
                        }).accentColor(.white)
                    }
                }
            }.padding(1)
            
        }
    }
}

struct EditActions_Previews: PreviewProvider {
    static var actions = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {})
    ]
    
    static var actions2 = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {}),
        Action(title: "Request offer", iconName: "doc.text", bgColor: .edit, action: {})
    ]
    
    static var actions3 = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {}),
        Action(title: "Request offer", iconName: "doc.text", bgColor: .edit, action: {}),
        Action(title: "Order", iconName: "doc.text.fill", bgColor: .delete, action: {})
    ]
    
    static var actions4 = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {}),
        Action(title: "Request offer", iconName: "doc.text", bgColor: .edit, action: {}),
        Action(title: "Order", iconName: "doc.text.fill", bgColor: .delete, action: {}),
        Action(title: "Order provided", iconName: "car", bgColor: .done, action: {}),
    ]
    static var previews: some View {
        Group {
            EditActions(viewModel: EditActionsVM(actions))
                .colorScheme(.dark)
                .previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions2)).previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions3)).previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions4)).previewLayout(.fixed(width: 450, height: 150))
            
            
        }
    }
}

