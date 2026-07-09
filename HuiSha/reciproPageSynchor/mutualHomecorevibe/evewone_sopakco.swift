import SwiftUI
import UIKit

struct evewone_sopakco: View {
    var whisperAction: (Int) -> Void = { _ in }

    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @StateObject private var mirelithLedger = MirelithMessageGlyphStore.shared
    @StateObject private var velmoraLedger = VelmoraUserGlyphStore.shared

    @State private var veyraNeedle = ""

    private var murmurThreads: [MirelithMessageGlyph] {
        let selfMark = qorraVault.auvrionSelqareth
        let shadeMarks = Set(auvrionPulse?.shadeMarks ?? [])
        let lumenNeedle = veyraNeedle.trimmingCharacters(in: .whitespacesAndNewlines)

        return mirelithLedger.glyphs
            .filter { threadGlyph in
                threadGlyph.mirelMarks.contains(selfMark)
            }
            .filter { threadGlyph in
                shadeMarks.isDisjoint(with: Set(threadGlyph.mirelMarks))
            }
            .filter { threadGlyph in
                guard !lumenNeedle.isEmpty else { return true }
                let veyraMate = mateGlyph(for: threadGlyph, selfMark: selfMark)
                return threadGlyph.murmurSigil.localizedCaseInsensitiveContains(lumenNeedle)
                    || (veyraMate?.nameSigil.localizedCaseInsensitiveContains(lumenNeedle) ?? false)
            }
            .sorted { $0.timeSigil > $1.timeSigil }
    }

    private var auvrionPulse: VelmoraUserGlyph? {
        velmoraLedger.glyphs.first { $0.id == qorraVault.auvrionSelqareth }
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
                        TextField("搜索昵称或聊天记录", text: $veyraNeedle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                            .textInputAutocapitalization(.never)
                            .padding(.leading, 26)

                        Button {
                        } label: {
                            Image("corelightbrilliant")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .frame(width: 46, height: 46)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 14)
                    }
                    .frame(height: 54)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                
                VStack(spacing: 0) {
                    Image("purelinkagespace")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            if murmurThreads.isEmpty {
                                voidSigil
                                    .padding(.top, 130)
                            } else {
                                ForEach(murmurThreads) { threadGlyph in
                                    Button {
                                        if let mateMark = mateMark(for: threadGlyph, selfMark: qorraVault.auvrionSelqareth) {
                                            whisperAction(mateMark)
                                        }
                                    } label: {
                                        threadRune(threadGlyph)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
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
        .dismissKeyboardOnOutsideTap()
    }

    private func threadRune(_ threadGlyph: MirelithMessageGlyph) -> some View {
        let veyraMate = mateGlyph(for: threadGlyph, selfMark: qorraVault.auvrionSelqareth)

        return HStack {
            soulOrb(path: veyraMate?.soulTrace ?? "")
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(veyraMate?.nameSigil ?? "未知用户")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(timeSigil(threadGlyph.timeSigil))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Text(threadGlyph.murmurSigil)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
    }

    private func mateGlyph(for threadGlyph: MirelithMessageGlyph, selfMark: Int) -> VelmoraUserGlyph? {
        let mateMark = mateMark(for: threadGlyph, selfMark: selfMark)
        guard let mateMark else { return nil }
        return velmoraLedger.glyphs.first { $0.id == mateMark }
    }

    private func mateMark(for threadGlyph: MirelithMessageGlyph, selfMark: Int) -> Int? {
        threadGlyph.mirelMarks.first { $0 != selfMark }
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

    private func timeSigil(_ auricDate: Date) -> String {
        let chronFormatter = DateFormatter()
        chronFormatter.dateFormat = "H:mm"
        return chronFormatter.string(from: auricDate)
    }

    private var voidSigil: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}
