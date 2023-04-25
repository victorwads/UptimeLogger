//
//  MonoText.swift
//  UptimeLogger
//
//  Created by Victor Wads on 24/04/23.
//

import SwiftUI

struct MonoText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        let text = Text(text)
        if #available(macOS 13.0, *){
            text.monospaced()
        } else {
            text
        }
    }
}


struct MonoText_Previews: PreviewProvider {
    static var previews: some View {
        MonoText("any thing here")
    }
}
