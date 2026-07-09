import SwiftUI
import UIKit

struct QorvaneLumisVey: View {
    var lumisRetreat: () -> Void = {}
    var veyraPulse: (String) -> Void = { _ in }
    var kinraCast: () -> Void = {}
    var selqarethDrift: (Int) -> Void = { _ in }
    var sylPrompt: () -> Void = {}

    @EnvironmentObject private var veyraVeil: VeyraPromptLattice
    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @StateObject private var velmoraHearth = VelmoraUserGlyphStore.shared

    @State private var lumisCipher = ""

    private var kinraGlints: [VelmoraUserGlyph] {
        let lumenNeedle = lumisCipher.trimmingCharacters(in: .whitespacesAndNewlines)
        let shadeMarks = Set(auvrionCore?.shadeMarks ?? [])
        let bondMarks = Set(auvrionCore?.kinraMarks ?? [])
        return velmoraHearth.glyphs
            .filter { $0.id != qorraVault.auvrionSelqareth }
            .filter { !shadeMarks.contains($0.id) }
            .filter { !bondMarks.contains($0.id) }
            .filter { glint in
                guard !lumenNeedle.isEmpty else { return true }
                return glint.nameSigil.localizedCaseInsensitiveContains(lumenNeedle)
                    || "\(glint.id)".contains(lumenNeedle)
            }
    }

    private var auvrionCore: VelmoraUserGlyph? {
        velmoraHearth.glyphs.first { $0.id == qorraVault.auvrionSelqareth }
    }

    var body: some View {
        ZStack(alignment: .top) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                qorvaneCrest

                lumisSeeker
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if kinraGlints.isEmpty {
                            voidSigil
                                .padding(.top, 130)
                        } else {
                            ForEach(kinraGlints) { glint in
                                HStack(spacing: 12) {
                                    Button {
                                        selqarethDrift(glint.id)
                                    } label: {
                                        HStack(spacing: 12) {
                                            soulOrb(path: glint.soulTrace)

                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack(spacing: 10) {
                                                    Text(glint.nameSigil)
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                                                    Text("\(mienRune(glint.mienKind))·\(glint.yearCount)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 8)
                                                        .frame(height: 22)
                                                        .background(Color(red: 0.87, green: 0.38, blue: 0.93), in: Capsule())
                                                }

                                                Text("ID：\(velmoraDisplayUserId(glint.id))")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)

                                    Spacer()

                                    Button {
                                        castKinraTap()
                                    } label: {
                                        Text("加好友")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 40)
                                            .background(
                                                AuvrionChromatics.sylvarnEphorix,
                                                in: RoundedRectangle(cornerRadius: 13, style: .continuous)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 46)
                }
            }
        }
        .ignoresSafeArea()
        .dismissKeyboardOnOutsideTap()
    }

    private var qorvaneCrest: some View {
        ZStack {
            Button {
                lumisRetreat()
            } label: {
                Image("genuinebond")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)

            Text("添加好友")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
        }
        .padding(.top, 58)
        .padding(.bottom, 20)
    }

    private var lumisSeeker: some View {
        HStack(spacing: 10) {
            TextField("搜索联系人ID", text: $lumisCipher)
                .font(.system(size: 17))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                .textInputAutocapitalization(.never)
                .padding(.leading, 26)

            Button {
                veyraPulse(lumisCipher)
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
        .frame(height: 59)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func soulOrb(path: String) -> some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("soulbridgen")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private func mienRune(_ value: String) -> String {
        value.isEmpty ? "不公开" : value
    }

    private func castKinraTap() {
        guard qorraVault.sylvarnEphorix else {
            veyraVeil.showLoginPanel(loginAction: sylPrompt)
            return
        }

        veyraVeil.showText("好友申请已发送")
        kinraCast()
    }

    private var voidSigil: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}
