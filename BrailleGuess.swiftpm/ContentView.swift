import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BrailleKeyboardView()
        }
        .rotationEffect(.degrees(-90))
        .padding(350)
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
