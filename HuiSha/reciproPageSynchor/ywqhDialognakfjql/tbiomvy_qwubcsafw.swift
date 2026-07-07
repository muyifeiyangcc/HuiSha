import SwiftUI

struct tbiomvy_qwubcsafw: View {
    var cancelAction: () -> Void = {}
    var rechargeAction: () -> Void = {}

    var body: some View {
        Image("polcjfuqmjahdebzjayeb")
            .resizable()
            .scaledToFit()
            .frame(height: 230)
            .overlay(
                HStack {
                    Button {
                        cancelAction()
                    } label: {
                        Image("vbayidnaqyfzvkakfq")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)

                    Button {
                        rechargeAction()
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

#Preview {
    tbiomvy_qwubcsafw()
}
