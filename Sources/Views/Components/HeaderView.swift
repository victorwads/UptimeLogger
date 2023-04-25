import SwiftUI

struct HeaderView<Content: View>: View {
    
    let title: LocalizedStringKey
    let icon: String
    let content: Content?

    init(_ title: LocalizedStringKey, icon: String, @ViewBuilder content: @escaping () -> Content? = { nil }) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    init(_ title: LocalizedStringKey, icon: String) where Content == EmptyView {
        self.title = title
        self.icon = icon
        self.content = nil
    }

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Label(title, systemImage: icon)
                    .font(.title)
                    .padding()
                Spacer()
                if let content = content {
                    HStack {
                        content
                    }.padding(.horizontal)
                }
            }
            Spacer()
            Divider()
        }
        .frame(height: 59)
        .padding(0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("Algum titulo", icon: "arrow.clockwise") {
            // Adicione qualquer conteúdo adicional aqui
            Text("Alguma view")
        }

        HeaderView("Outro Título", icon: "star")
    }
}
