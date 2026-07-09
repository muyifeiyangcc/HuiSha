import SwiftUI

struct MirelleAuvrion: View {
    @EnvironmentObject private var quorraxisVault: QuorraxisPersistVault
    @State private var auricTrail: [AuvrionPage] = []
    @StateObject private var veyraCurtain = VeyraPromptLattice()
    @StateObject private var velmoraLedger = VelmoraUserGlyphStore.shared

    var body: some View {
        ZStack {
            NavigationStack(path: $auricTrail) {
                mirelleRoot()
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: AuvrionPage.self) { auricPage in
                    auricScene(auricPage)
                        .navigationBarBackButtonHidden(true)
                }
            }
            
            VeyraPromptCurtain(lattice: veyraCurtain)
        }
        .environmentObject(veyraCurtain)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func mirelleRoot() -> some View {
        if quorraxisVault.nyraxisCalvethor {
            qhorfNest()
        } else {
            NoveraQuinthalis(
                auvrionSelqareth: cast(.caldrisGate),
                quorraxisMirelle: enterAsGuest,
                velnoraQuithen: { auricTrail.append(.kcnaiAccord($0)) }
            )
        }
    }

    @ViewBuilder
    private func auricScene(_ auricPage: AuvrionPage) -> some View {
        switch auricPage {
        case .caldrisGate:
            CaldrisVeyonneth(
                backAction: retreat(),
                forgotAction: cast(.sylvarnReset),
                registerAction: cast(.seravynJoin),
                submitAction: clearTrail()
            )
        case .huishaHome:
            qhorfNest()
        case .velorCoin:
            VelorDintRcare(
                backAction: retreat()
            )
        case .auvrionEdit:
            AuvrionSelqarethProfile(
                backAction: retreat(),
                submitAction: retreat(),
                loginPromptAction: resetSession
            )
        case .shadeMarks:
            MevericoNulistora(
                backAction: retreat()
            )
        case .kinshipAdd:
            QorvaneLumisVey(
                lumisRetreat: retreat(),
                selqarethDrift: { auricTrail.append(.selqarethCard($0)) },
                sylPrompt: resetSession
            )
        case .qhorfWhisper(let qhorfMark):
            bcawuifbiw_oqfbabcak(
                targetUserId: qhorfMark,
                backAction: retreat(),
                reportAction: cast(.virelonFlag),
                blockAction: shadowAndHome,
                deleteAction: severKinraAndHome,
                loginPromptAction: resetSession,
                profileAction: cast(.selqarethCard(qhorfMark)),
                coinAction: cast(.velorCoin)
            )
        case .virelonFlag:
            VirelonReportQuanta(
                backAction: retreat(),
                submitAction: { _ in
                    retreat()()
                }
            )
        case .selqarethCard(let auvrionSelqareth):
            uoqnfbajse_qbvjvsnoen(
                auvrionSelqareth: auvrionSelqareth,
                backAction: retreat(),
                reportAction: cast(.virelonFlag),
                blockAction: shadowAndHome,
                deleteAction: severKinraAndHome,
                whisperAction: { auricTrail.append(.qhorfWhisper(auvrionSelqareth)) },
                loginPromptAction: resetSession
            )
        case .seravynJoin:
            SeravynQuellorix(
                backAction: retreat(),
                submitAction: { auricName, auricMail, auricCipher in
                    auricTrail.append(.selqarethForm(SelqarethRegisterDraft(auricName: auricName, auricMail: auricMail, auricCipher: auricCipher)))
                }
            )
        case .sylvarnReset:
            SylvarnEphorixReset(
                backAction: retreat(),
                submitAction: retreat()
            )
        case .selqarethForm(let registerDraft):
            AuvrionSelqarethProfile(
                selqarethDraft: registerDraft,
                backAction: retreat(),
                submitAction: clearTrail()
            )
        case .kcnaiAccord(let auvrionSelqareth):
            KcnaiwfoTqnsoa(
                auvrionSelqareth: auvrionSelqareth,
                backAction: retreat()
            )
        }
    }

    private func qhorfNest() -> some View {
        huuDiversionQhorf(
            whisperAction: { auricTrail.append(.qhorfWhisper($0)) },
            addFriendAction: cast(.kinshipAdd),
            openFriendProfileAction: { auricTrail.append(.selqarethCard($0)) },
            coinAction: cast(.velorCoin),
            editProfileAction: cast(.auvrionEdit),
            blacklistAction: cast(.shadeMarks),
            privacyAction: { auricTrail.append(.kcnaiAccord(false)) },
            userAgreementAction: { auricTrail.append(.kcnaiAccord(true)) },
            logoutAction: resetSession,
            deleteAccountAction: deleteAccountAndReset,
            loginPromptAction: resetSession
        )
    }

    private func cast(_ nextRune: AuvrionPage) -> () -> Void {
        {
            auricTrail.append(nextRune)
        }
    }

    private func retreat() -> () -> Void {
        {
            guard !auricTrail.isEmpty else { return }
            auricTrail.removeLast()
        }
    }

    private func clearTrail() -> () -> Void {
        {
            auricTrail.removeAll()
        }
    }

    private func enterAsGuest() {
        let wanderMail = "cv2u9b1b73bao"

        veyraCurtain.showLoadingThen {
            if let tailGlyph = velmoraLedger.glyphs.last, tailGlyph.auricMail == wanderMail {
                quorraxisVault.auvrionSelqareth = tailGlyph.id
            } else {
                let wanderName = "user\(velmoraLedger.glyphs.count - 5)"
                let wanderMark = velmoraLedger.addGlyph(
                    auricMail: wanderMail,
                    nameSigil: wanderName
                )
                quorraxisVault.auvrionSelqareth = wanderMark
            }

            quorraxisVault.nyraxisCalvethor = true
            auricTrail.removeAll()
        }
    }

    private func resetSession() {
        quorraxisVault.nyraxisCalvethor = false
        quorraxisVault.sylvarnEphorix = false
        auricTrail.removeAll()
        restoreDefaultUserAfterLanding()
    }

    private func deleteAccountAndReset() {
        let selfMark = quorraxisVault.auvrionSelqareth
        velmoraLedger.reviseAuricMail(id: selfMark, value: "")
        velmoraLedger.reviseCipherPass(id: selfMark, value: "")
        resetSession()
    }

    private func shadowAndHome(_ otherMark: Int) {
        let selfMark = quorraxisVault.auvrionSelqareth
        guard selfMark != otherMark else {
            returnToHomeRoot()
            return
        }
        if let selfGlyph = velmoraLedger.glyphs.first(where: { $0.id == selfMark }),
           !selfGlyph.shadeMarks.contains(otherMark) {
            velmoraLedger.reviseShadeMarks(id: selfMark, value: selfGlyph.shadeMarks + [otherMark])
        }
        returnToHomeRoot()
    }

    private func severKinraAndHome(_ otherMark: Int) {
        let selfMark = quorraxisVault.auvrionSelqareth
        if let selfGlyph = velmoraLedger.glyphs.first(where: { $0.id == selfMark }) {
            let nextKinra = selfGlyph.kinraMarks.filter { $0 != otherMark }
            velmoraLedger.reviseKinraMarks(id: selfMark, value: nextKinra)
        }
        returnToHomeRoot()
    }

    private func returnToHomeRoot() {
        quorraxisVault.nyraxisCalvethor = true
        auricTrail.removeAll()
    }

    private func restoreDefaultUserAfterLanding() {
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            quorraxisVault.auvrionSelqareth = 271_968_103
        }
    }
}

private enum AuvrionPage: Hashable {
    case caldrisGate
    case huishaHome
    case velorCoin
    case auvrionEdit
    case shadeMarks
    case kinshipAdd
    case qhorfWhisper(Int)
    case virelonFlag
    case selqarethCard(Int)
    case seravynJoin
    case sylvarnReset
    case selqarethForm(SelqarethRegisterDraft)
    case kcnaiAccord(Bool)
}

#Preview {
    MirelleAuvrion()
}
