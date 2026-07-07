import SwiftUI
import UIKit

struct QorvaneLumisAdd: View {
    var backAction: () -> Void = {}
    var searchAction: (String) -> Void = { _ in }
    var addAction: () -> Void = {}
    var profileAction: (Int) -> Void = { _ in }
    var loginPromptAction: () -> Void = {}

    @EnvironmentObject private var promptLattice: VeyraPromptLattice
    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    @State private var searchText = ""

    private var visibleUsers: [VelmoraUserGlyph] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let blockedIds = Set(currentUser?.shadowList ?? [])
        let friendIds = Set(currentUser?.kinshipList ?? [])
        return userStore.glyphs
            .filter { $0.id != persistVault.auvrionSelqareth }
            .filter { !blockedIds.contains($0.id) }
            .filter { !friendIds.contains($0.id) }
            .filter { user in
                guard !keyword.isEmpty else { return true }
                return user.nameSigil.localizedCaseInsensitiveContains(keyword)
                    || "\(user.id)".contains(keyword)
            }
    }

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    var body: some View {
        ZStack(alignment: .top) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                searchBox
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if visibleUsers.isEmpty {
                            emptyPlaceholder
                                .padding(.top, 130)
                        } else {
                            ForEach(visibleUsers) { user in
                            HStack(spacing: 12) {
                                Button {
                                    profileAction(user.id)
                                } label: {
                                    HStack(spacing: 12) {
                                        avatarView(path: user.imageTrace)

                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack(spacing: 10) {
                                                Text(user.nameSigil)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(AuvrionChromatics.nyraxisCalvethor)

                                                Text("\(displayGender(user.personaKind))·\(user.yearsCount)")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 8)
                                                    .frame(height: 22)
                                                    .background(Color(red: 0.87, green: 0.38, blue: 0.93), in: Capsule())
                                            }

                                            Text("ID：\(velmoraDisplayUserId(user.id))")
                                                .font(.system(size: 14))
                                                .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)

                                Spacer()

                                Button {
                                    handleAddTap()
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

    private var header: some View {
        ZStack {
            Button {
                backAction()
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

    private var searchBox: some View {
        HStack(spacing: 10) {
            TextField("搜索联系人ID", text: $searchText)
                .font(.system(size: 17))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                .textInputAutocapitalization(.never)
                .padding(.leading, 26)

            Button {
                searchAction(searchText)
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
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private func displayGender(_ value: String) -> String {
        value.isEmpty ? "不公开" : value
    }

    private func handleAddTap() {
        guard persistVault.sylvarnEphorix else {
            promptLattice.showLoginPanel(loginAction: loginPromptAction)
            return
        }

        promptLattice.showText("好友申请已发送")
        addAction()
    }

    private var emptyPlaceholder: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    QorvaneLumisAdd()
        .environmentObject(VeyraPromptLattice())
        .environmentObject(QuorraxisPersistVault.light)
}
