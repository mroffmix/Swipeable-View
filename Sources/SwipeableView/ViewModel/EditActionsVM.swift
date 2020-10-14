//
//  EditActionsVM.swift
//  SwipebleView
//
//  Created by Ilya on 10.10.20.
//

import SwiftUI

public enum EditActionColor {
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

public struct Action: Identifiable {
    public init(title: String, iconName: String, bgColor: EditActionColor, action: @escaping () -> ()?) {
        self.title = title
        self.iconName = iconName
        self.bgColor = bgColor
        self.action = action
    }
    
    public let id: UUID = UUID.init()
    let title: String
    let iconName: String
    let bgColor: EditActionColor
    let action: () -> ()?
}

open class EditActionsVM: ObservableObject {
    let actions: [Action]
    public init(_ actions: [Action], maxActions: Int) {
        self.actions = Array(actions.prefix(maxActions))
    }
}
