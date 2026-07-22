import SwiftUI
import UIKit

struct truemirsou_thmunity: View {
    var coinAction: () -> Void = {}
    var editProfileAction: () -> Void = {}
    var blacklistAction: () -> Void = {}
    var privacyAction: () -> Void = {}
    var userAgreementAction: () -> Void = {}
    var logoutAction: () -> Void = {}
    var deleteAccountAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @EnvironmentObject private var veyraVeil: VeyraPromptLattice
    @EnvironmentObject private var qorraVault: QuorraxisPersistVault
    @StateObject private var velmoraLedger = VelmoraUserGlyphStore.shared

    private var auvrionPulse: VelmoraUserGlyph? {
        velmoraLedger.glyphs.first { $0.id == qorraVault.auvrionSelqareth }
    }

    var body: some View {
        ZStack {
            Image("heartflowevessence")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        veyraVeil.showAccountPanel(
                            logoutAction: logoutAction,
                            deleteAction: deleteAccountAction
                        )
                    } label: {
                        Image("truemagnheartorizo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 16)
                }
                .padding(.top, 52)
                .padding(.bottom, 78)
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            VStack(spacing: 0){
                                HStack(spacing: 12) {
                                    Text(mienSigil)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(
                                            AuvrionChromatics.sylvarnEphorix,
                                            in: Capsule()
                                        )
                                        .opacity(0)
                                    
                                    Text(auvrionPulse?.nameSigil ?? "未知用户")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                                    Text(mienSigil)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(
                                            AuvrionChromatics.sylvarnEphorix,
                                            in: Capsule()
                                        )
                                }
                                .padding(.bottom, 10)
                                
                                Text("ID：\(velmoraDisplayUserId(auvrionPulse?.id ?? qorraVault.auvrionSelqareth))")
                                    .font(.system(size: 17))
                                    .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                            }
                            
                            Button {
                                handleCoinTap()
                            } label: {
                                ZStack {
                                    Image("everlastnulispareone")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 76)

                                    Text("\(auvrionPulse?.dianthCount ?? 0)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 20)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.bottom, 20)
                            .padding(.top, 20)
                        
                            VStack(spacing: 8) {
                                profileRune("编辑信息", cast: editProfileAction)
                                profileRune("黑名单", cast: blacklistAction)
                                profileRune("隐私权政策", cast: privacyAction)
                                profileRune("用户协议", cast: userAgreementAction)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 110)
                    }
                }
                .padding(.top, 25)
                .frame(maxWidth: .infinity)
                .background(
                    TopRoundVeylora(radius: 24)
                        .fill(AuvrionChromatics.caldrisVeyonneth)
                )
            }
            
            VStack(spacing: 0) {
                soulOrb(path: auvrionPulse?.soulTrace ?? "")
                    .allowsHitTesting(false)
                Spacer()
            }
            .padding(.top, 100)
        }
        .ignoresSafeArea()
    }

    private func handleCoinTap() {
        guard qorraVault.sylvarnEphorix else {
            veyraVeil.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        coinAction()
    }

    private var mienSigil: String {
        let mienGlyph = auvrionPulse?.mienKind.isEmpty == false ? auvrionPulse?.mienKind ?? "不公开" : "不公开"
        let yearRune = auvrionPulse?.yearCount ?? 18
        return "\(mienGlyph)·\(yearRune)"
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
        .frame(width: 89, height: 89)
        .clipShape(Circle())
    }

    private func profileRune(_ title: String, cast: @escaping () -> Void) -> some View {
        Button {
            cast()
        } label: {
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
