import SwiftUI
import PhotosUI
import UIKit

struct SelqarethRegisterDraft: Hashable {
    let auricName: String
    let auricMail: String
    let auricCipher: String
}

struct AuvrionSelqarethProfile: View {
    @EnvironmentObject private var veyraVeil: VeyraPromptLattice
    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @StateObject private var velmoraHearth = VelmoraUserGlyphStore.shared

    var selqarethDraft: SelqarethRegisterDraft?
    var backAction: () -> Void = {}
    var submitAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @State private var auvrionSelqareth = ""
    @State private var nyraxisCalvethor = ""
    @State private var quorraxisMirelle = ""
    @State private var vellumAsterion = ""
    @State private var sylvarnEphorix: PhotosPickerItem?
    @State private var caldrisVeyonneth: Image?
    @State private var soulBytes: Data?

    private let yearRunes = (18...99).map { "\($0)" }

    var body: some View {
        QuenraLuminethShell(backAction: backAction) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        if let caldrisVeyonneth {
                            caldrisVeyonneth
                                .resizable()
                                .scaledToFill()
                                .frame(width: 89, height: 89)
                                .clipShape(Circle())
                        } else {
                            Image("soulbridgen")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 89, height: 89)
                        }

                        PhotosPicker(selection: $sylvarnEphorix, matching: .images) {
                            Image("purespector")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 41, height: 34)
                        }
                        .buttonStyle(.plain)
                        .offset(x: 38, y: -2)
                    }
                    .padding(.top, 110)
                    .onChange(of: sylvarnEphorix) { newValue in
                        Task {
                            if let pickedSoul = try? await newValue?.loadTransferable(type: Data.self),
                               let soulImage = UIImage(data: pickedSoul) {
                                soulBytes = pickedSoul
                                caldrisVeyonneth = Image(uiImage: soulImage)
                            }
                        }
                    }

                    VellumQuorraxisStack(rows: [
                        ElarionVaskethra(label: "heartlinkco", placeholder: "请输入", value: $auvrionSelqareth),
                        ElarionVaskethra(label: "genuflowco", placeholder: "请选择", value: $nyraxisCalvethor, hasChevron: true, options: ["中国大陆", "中国香港", "中国台湾", "海外"]),
                        ElarionVaskethra(label: "recipauthentic", placeholder: "请选择", value: $quorraxisMirelle, hasChevron: true, options: ["男", "女", "不公开"]),
                        ElarionVaskethra(label: "authenticrecip", placeholder: "请选择", value: $vellumAsterion, hasChevron: true, options: yearRunes)
                    ])
                    .padding(.top, 40)

                    MorvianLethirax(asset: "verimutualcore", action: sealSelqareth)
                        .padding(.top, 54)
                        .padding(.bottom, 45)
                }
                .frame(maxWidth: .infinity)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 12)
            }

        }
        .ignoresSafeArea()
        .onAppear {
            bloomSelqarethIfNeeded()
        }
    }

    private func sealSelqareth() {
        if let selqarethDraft {
            birthSelqareth(selqarethDraft)
            return
        }

        renewSelqareth()
    }

    private func birthSelqareth(_ selqarethDraft: SelqarethRegisterDraft) {
        let nameRune = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let realmRune = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let mienRune = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let yearText = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nameRune.isEmpty, !realmRune.isEmpty, !mienRune.isEmpty, !yearText.isEmpty else {
            veyraVeil.showText("请完整填写信息")
            return
        }

        guard !velmoraHearth.glyphs.contains(where: { $0.auricMail == selqarethDraft.auricMail }) else {
            veyraVeil.showText("该邮箱已注册，请不要重复注册")
            return
        }

        let selfMark = velmoraHearth.addGlyph(
            auricMail: selqarethDraft.auricMail,
            cipherPass: selqarethDraft.auricCipher,
            nameSigil: nameRune,
            realmMark: realmRune,
            mienKind: mienRune,
            yearCount: yearCount(from: yearText)
        )

        if let soulBytes {
            velmoraHearth.reviseSoulTrace(id: selfMark, soulBytes: soulBytes)
        }

        veyraVeil.showLoadingThen {
            qorraVault.auvrionSelqareth = selfMark
            qorraVault.nyraxisCalvethor = true
            qorraVault.sylvarnEphorix = true
            submitAction()
        }
    }

    private func renewSelqareth() {
        guard qorraVault.sylvarnEphorix else {
            veyraVeil.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        let nameRune = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let realmRune = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let mienRune = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let yearText = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nameRune.isEmpty, !realmRune.isEmpty, !mienRune.isEmpty, !yearText.isEmpty else {
            veyraVeil.showText("请完整填写信息")
            return
        }

        let selfMark = qorraVault.auvrionSelqareth
        velmoraHearth.reviseNameSigil(id: selfMark, value: nameRune)
        velmoraHearth.reviseRealmMark(id: selfMark, value: realmRune)
        velmoraHearth.reviseMienKind(id: selfMark, value: mienRune)
        velmoraHearth.reviseYearCount(id: selfMark, value: yearCount(from: yearText))
        if let soulBytes {
            velmoraHearth.reviseSoulTrace(id: selfMark, soulBytes: soulBytes)
        }

        veyraVeil.showLoadingThenTextThen("加载中", successText: "修改成功") {
            submitAction()
        }
    }

    private func bloomSelqarethIfNeeded() {
        if let selqarethDraft {
            if auvrionSelqareth.isEmpty {
                auvrionSelqareth = selqarethDraft.auricName
            }
            return
        }

        guard auvrionSelqareth.isEmpty,
              let selfGlyph = velmoraHearth.glyphs.first(where: { $0.id == qorraVault.auvrionSelqareth }) else {
            return
        }

        auvrionSelqareth = selfGlyph.nameSigil
        nyraxisCalvethor = selfGlyph.realmMark
        quorraxisMirelle = selfGlyph.mienKind
        vellumAsterion = "\(selfGlyph.yearCount)"
        if let soulImage = UIImage(contentsOfFile: selfGlyph.soulTrace) {
            caldrisVeyonneth = Image(uiImage: soulImage)
        }
    }

    private func yearCount(from text: String) -> Int {
        let prefix = text.prefix { $0.isNumber }
        return Int(prefix) ?? 18
    }
}
