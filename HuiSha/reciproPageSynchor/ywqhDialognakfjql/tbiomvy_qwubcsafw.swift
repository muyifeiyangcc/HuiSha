import SwiftUI

struct tbiomvy_qwubcsafw: View {
    var veilFold: () -> Void = {}
    var velorCast: () -> Void = {}

    var body: some View {
        Image("polcjfuqmjahdebzjayeb")
            .resizable()
            .scaledToFit()
            .frame(height: 230)
            .overlay(
                HStack {
                    Button {
                        veilFold()
                    } label: {
                        Image("vbayidnaqyfzvkakfq")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)

                    Button {
                        velorCast()
                    } label: {
                        Image("hiahchvbztwroujbfdfg")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                }
                    .padding(.bottom, 29),
                alignment: .bottom
            )
    }
}
