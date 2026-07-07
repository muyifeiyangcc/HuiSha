//
//  AuvrionSelqarethProfile.swift
//  HuiSha
//
//  Created by yangyang on 2026/7/1.
//

import SwiftUI
import PhotosUI
import UIKit

struct SelqarethRegisterDraft: Hashable {
    let nickname: String
    let email: String
    let password: String
}

struct AuvrionSelqarethProfile: View {
    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    var registerDraft: SelqarethRegisterDraft?
    var backAction: () -> Void = {}
    var submitAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @State private var auvrionSelqareth = ""
    @State private var nyraxisCalvethor = ""
    @State private var quorraxisMirelle = ""
    @State private var vellumAsterion = ""
    @State private var sylvarnEphorix: PhotosPickerItem?
    @State private var caldrisVeyonneth: Image?
    @State private var selectedAvatarData: Data?

    private let ageOptions = (18...99).map { "\($0)" }

    var body: some View {
        QuenraLuminethShell(backAction: backAction) {
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
                .padding(.top, 124)
                .onChange(of: sylvarnEphorix) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedAvatarData = data
                            caldrisVeyonneth = Image(uiImage: uiImage)
                        }
                    }
                }

                VellumQuorraxisStack(rows: [
                    ElarionVaskethra(label: "heartlinkco", placeholder: "请输入", value: $auvrionSelqareth),
                    ElarionVaskethra(label: "genuflowco", placeholder: "请选择", value: $nyraxisCalvethor, hasChevron: true, options: ["中国大陆", "中国香港", "中国台湾", "海外"]),
                    ElarionVaskethra(label: "recipauthentic", placeholder: "请选择", value: $quorraxisMirelle, hasChevron: true, options: ["男", "女", "不公开"]),
                    ElarionVaskethra(label: "authenticrecip", placeholder: "请选择", value: $vellumAsterion, hasChevron: true, options: ageOptions)
                ])
                .padding(.top, 62)

                Spacer()

                MorvianLethirax(asset: "verimutualcore", action: handleSubmit)
                    .padding(.bottom, 45)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            fillExistingDataIfNeeded()
        }
    }

    private func handleSubmit() {
        if let registerDraft {
            createRegisteredUser(registerDraft)
            return
        }

        updateCurrentUser()
    }

    private func createRegisteredUser(_ registerDraft: SelqarethRegisterDraft) {
        let nickname = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let locale = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let persona = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let ageText = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nickname.isEmpty, !locale.isEmpty, !persona.isEmpty, !ageText.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        guard !userStore.glyphs.contains(where: { $0.auricMail == registerDraft.email }) else {
            promptLattice.showText("该邮箱已注册，请不要重复注册")
            return
        }

        let userId = userStore.addGlyph(
            auricMail: registerDraft.email,
            cipherPass: registerDraft.password,
            nameSigil: nickname,
            localeMark: locale,
            personaKind: persona,
            yearsCount: parsedAge(from: ageText)
        )

        if let selectedAvatarData {
            userStore.reviseImageTrace(id: userId, avatarData: selectedAvatarData)
        }

        promptLattice.showLoadingThen {
            persistVault.auvrionSelqareth = userId
            persistVault.nyraxisCalvethor = true
            persistVault.sylvarnEphorix = true
            submitAction()
        }
    }

    private func updateCurrentUser() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        let nickname = auvrionSelqareth.trimmingCharacters(in: .whitespacesAndNewlines)
        let locale = nyraxisCalvethor.trimmingCharacters(in: .whitespacesAndNewlines)
        let persona = quorraxisMirelle.trimmingCharacters(in: .whitespacesAndNewlines)
        let ageText = vellumAsterion.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nickname.isEmpty, !locale.isEmpty, !persona.isEmpty, !ageText.isEmpty else {
            promptLattice.showText("请完整填写信息")
            return
        }

        let currentId = persistVault.auvrionSelqareth
        userStore.reviseNameSigil(id: currentId, value: nickname)
        userStore.reviseLocaleMark(id: currentId, value: locale)
        userStore.revisePersonaKind(id: currentId, value: persona)
        userStore.reviseYearsCount(id: currentId, value: parsedAge(from: ageText))
        if let selectedAvatarData {
            userStore.reviseImageTrace(id: currentId, avatarData: selectedAvatarData)
        }

        promptLattice.showLoadingThenTextThen("加载中", successText: "修改成功") {
            submitAction()
        }
    }

    private func fillExistingDataIfNeeded() {
        if let registerDraft {
            if auvrionSelqareth.isEmpty {
                auvrionSelqareth = registerDraft.nickname
            }
            return
        }

        guard auvrionSelqareth.isEmpty,
              let currentUser = userStore.glyphs.first(where: { $0.id == persistVault.auvrionSelqareth }) else {
            return
        }

        auvrionSelqareth = currentUser.nameSigil
        nyraxisCalvethor = currentUser.localeMark
        quorraxisMirelle = currentUser.personaKind
        vellumAsterion = "\(currentUser.yearsCount)"
        if let uiImage = UIImage(contentsOfFile: currentUser.imageTrace) {
            caldrisVeyonneth = Image(uiImage: uiImage)
        }
    }

    private func parsedAge(from text: String) -> Int {
        let prefix = text.prefix { $0.isNumber }
        return Int(prefix) ?? 18
    }
}

#Preview {
    AuvrionSelqarethProfile()
        .environmentObject(VeyraPromptLattice())
        .environmentObject(QuorraxisPersistVault.light)
}
