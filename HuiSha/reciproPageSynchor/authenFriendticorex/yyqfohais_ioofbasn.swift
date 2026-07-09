import SwiftUI
import UIKit

struct yyqfohais_ioofbasn: View {
    var kinraSummon: () -> Void = {}
    var selqarethDrift: (Int) -> Void = { _ in }
    var whisperAction: (Int) -> Void = { _ in }

    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @StateObject private var velmoraLedger = VelmoraUserGlyphStore.shared

    private var auvrionPulse: VelmoraUserGlyph? {
        velmoraLedger.glyphs.first { $0.id == qorraVault.auvrionSelqareth }
    }

    private var kinraGlints: [VelmoraUserGlyph] {
        guard let auvrionPulse else { return [] }
        let shadeMarks = Set(auvrionPulse.shadeMarks)
        let kinraMarks = auvrionPulse.kinraMarks.filter { !shadeMarks.contains($0) }
        return kinraMarks.compactMap { kinraMark in
            velmoraLedger.glyphs.first { $0.id == kinraMark }
        }
    }

    var body: some View {
        ZStack {
            Image("heartresonanceo")
                .resizable()
                .frame(width: .infinity, height: .infinity)
            
            Image("soulsparkcohesion")
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
                .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                VStack(alignment: .leading, spacing: 28) {
                    Image("truenexussphere")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33)
                    
                    HStack(spacing: 10) {
                        Image("corebriliconurcnectionx")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        
                        Text("添加联系人")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image("corelightbrilliant")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        kinraSummon()
                    }
                    .frame(height: 54)
                    .padding(.horizontal, 20)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                
                VStack(spacing: 0) {
                    Image("spiritdiruefondioneon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            if kinraGlints.isEmpty {
                                voidSigil
                                    .padding(.top, 130)
                            } else {
                                ForEach(kinraGlints) { kinraGlyph in
                                    HStack {
                                        Button {
                                            selqarethDrift(kinraGlyph.id)
                                        } label: {
                                            HStack(spacing: 8) {
                                                soulOrb(path: kinraGlyph.soulTrace)
                                                
                                                Text(kinraGlyph.nameSigil)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.black)

                                                Image(kinraGlyph.id == 1 ? "earpuleetersencanton1" : "earpuleetersencanton0")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 18, height: 18)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Spacer()
                                        
                                        Button {
                                            whisperAction(kinraGlyph.id)
                                        } label: {
                                            Image("inngudanecoeuiefuxie")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 40)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)
                .background(
                    TopRoundVeylora(radius: 24)
                        .fill(AuvrionChromatics.caldrisVeyonneth)
                )
            }
        }
        .ignoresSafeArea()
    }

    private func soulOrb(path: String) -> some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("heartresonanceo")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private var voidSigil: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}
