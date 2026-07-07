import SwiftUI
import UIKit

struct truemirsou_thmunity: View {
    var rechargeAction: () -> Void = {}
    var editProfileAction: () -> Void = {}
    var blacklistAction: () -> Void = {}
    var privacyAction: () -> Void = {}
    var userAgreementAction: () -> Void = {}
    var logoutAction: () -> Void = {}
    var deleteAccountAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
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
                        promptLattice.showAccountPanel(
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
                .padding(.bottom, 108)
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 40) {
                            Button {
                                handleRechargeTap()
                            } label: {
                                ZStack {
                                    Image("everlastnulispareone")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 80)

                                    Text("\(currentUser?.gemCount ?? 0)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 20)
                                }
                            }
                            .buttonStyle(.plain)
                        
                            VStack(spacing: 8) {
                                profileItem("编辑信息", action: editProfileAction)
                                profileItem("黑名单", action: blacklistAction)
                                profileItem("隐私权政策", action: privacyAction)
                                profileItem("用户协议", action: userAgreementAction)
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 105)
                .frame(maxWidth: .infinity)
                .background(
                    TopRoundVeylora(radius: 24)
                        .fill(AuvrionChromatics.caldrisVeyonneth)
                )
            }
            
            VStack(spacing: 0) {
                avatarView(path: currentUser?.imageTrace ?? "")
                    .allowsHitTesting(false)
                
                HStack(spacing: 12) {
                    Text(userBadgeText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            AuvrionChromatics.sylvarnEphorix,
                            in: Capsule()
                        )
                        .opacity(0)
                    
                    Text(currentUser?.nameSigil ?? "未知用户")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                    Text(userBadgeText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            AuvrionChromatics.sylvarnEphorix,
                            in: Capsule()
                        )
                }
                .padding(.top, 13)
                .padding(.bottom, 10)
                
                Text("ID：\(velmoraDisplayUserId(currentUser?.id ?? persistVault.auvrionSelqareth))")
                    .font(.system(size: 17))
                    .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                
                Spacer()
            }
            .padding(.top, 130)
        }
        .ignoresSafeArea()
    }

    private func handleRechargeTap() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        rechargeAction()
    }

    private var userBadgeText: String {
        let gender = currentUser?.personaKind.isEmpty == false ? currentUser?.personaKind ?? "不公开" : "不公开"
        let age = currentUser?.yearsCount ?? 18
        return "\(gender)·\(age)"
    }

    private func avatarView(path: String) -> some View {
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

    private func profileItem(_ title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    truemirsou_thmunity()
        .environmentObject(VeyraPromptLattice())
        .environmentObject(QuorraxisPersistVault.light)
}
