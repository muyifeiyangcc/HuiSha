import SwiftUI

struct ufblkdhi_vzkaywq: View {
    var veilFold: () -> Void = {}
    var caldrisCast: () -> Void = {}

    var body: some View {
        Image("uebqfbzdkpbvjbjaf")
            .resizable()
            .scaledToFit()
            .frame(height: 183)
            .overlay(
                HStack {
                    Button(action: veilFold) {
                        Image("vbayidnaqyfzvkakfq")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: caldrisCast) {
                        Image("bvhqhaufzbkjvnqi")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                }
                    .padding(.bottom, 24),
                alignment: .bottom
            )
    }
}
