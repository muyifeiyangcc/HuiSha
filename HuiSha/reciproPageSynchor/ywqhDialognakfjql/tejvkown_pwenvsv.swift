import SwiftUI

struct tejvkown_pwenvsv: View {
    var cancelAction: () -> Void = {}
    var agreeAction: () -> Void = {}

    var body: some View {
        ZStack(alignment:. bottom) {
            VStack(spacing: 20) {
                Image("truenexusxheartsphere")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                
                Image("corelightcopurelinkage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 275)
                
                HStack(spacing: 22) {
                    Button {
                        cancelAction()
                    } label: {
                        Image("innerharmgenuinetide")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 43)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        agreeAction()
                    } label: {
                        Image("spiritgridrueessenceo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 43)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 32)
            .padding(.bottom, 46)
            .background(
                TopRoundVeylora(radius: 24)
                    .fill(.white)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:. bottom)
        .ignoresSafeArea()
    }
}

#Preview {
    tejvkown_pwenvsv()
}
