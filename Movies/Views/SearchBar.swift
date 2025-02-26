import SwiftUI

struct SearchBar: View {
    @Binding var searchString: String

    var body: some View {
        TextField("Search Movies", text: $searchString)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}
