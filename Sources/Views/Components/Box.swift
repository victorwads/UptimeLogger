//
//  Box.swift
//  UptimeLogger
//
//  Created by Victor Wads on 02/05/23.
//

import SwiftUI

struct Box<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let padding: CGFloat
    let active: Bool

    init(
        active: Bool = false,
        cornerRadius: CGFloat = 10, padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.active = active
    }
    
    var body: some View {
        content
            .padding(padding)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius).stroke(
                    active ? Color.accentColor : Color(.separatorColor),
                    lineWidth: 1
                )
            )
            .padding(padding)
    }
}

struct Box_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Box {
                Text("Conteúdo interno da box")
            }
            Box(active: true) {
                Text("Conteúdo interno da box")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

