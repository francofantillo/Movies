import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool

    var body: some View {
        if isLoading {
            VStack {
                Spacer()
                ProgressView()
                    .scaleEffect(3.0)
                Spacer()
            }
        }
    }
}
