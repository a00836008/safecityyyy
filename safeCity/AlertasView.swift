import SwiftUI

struct AlertasView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                navigationBar(isActive_Alert : true)
            }
            .navigationBarTitle("Alertas")
        }
        .accentColor(.purple)
    }
}

#Preview {
    AlertasView()
}
