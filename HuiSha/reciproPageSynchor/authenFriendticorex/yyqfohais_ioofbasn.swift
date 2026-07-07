import SwiftUI
import UIKit

struct yyqfohais_ioofbasn: View {
    var addFriendAction: () -> Void = {}
    var openProfileAction: (Int) -> Void = { _ in }
    var openChatAction: (Int) -> Void = { _ in }

    @EnvironmentObject private var persistVault: QuorraxisPersistVault
    @StateObject private var userStore = VelmoraUserGlyphStore.shared

    private var currentUser: VelmoraUserGlyph? {
        userStore.glyphs.first { $0.id == persistVault.auvrionSelqareth }
    }

    private var visibleFriends: [VelmoraUserGlyph] {
        guard let currentUser else { return [] }
        let blockedIds = Set(currentUser.shadowList)
        let friendIds = currentUser.kinshipList.filter { !blockedIds.contains($0) }
        return friendIds.compactMap { friendId in
            userStore.glyphs.first { $0.id == friendId }
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
                        addFriendAction()
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
                            if visibleFriends.isEmpty {
                                emptyPlaceholder
                                    .padding(.top, 130)
                            } else {
                                ForEach(visibleFriends) { friend in
                                HStack {
                                    Button {
                                        openProfileAction(friend.id)
                                    } label: {
                                        HStack(spacing: 8) {
                                            avatarView(path: friend.imageTrace)
                                            
                                            Text(friend.nameSigil)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.black)

                                            Image(friend.id == 1 ? "earpuleetersencanton1" : "earpuleetersencanton0")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 18, height: 18)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    Button {
                                        openChatAction(friend.id)
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

    private func avatarView(path: String) -> some View {
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

    private var emptyPlaceholder: some View {
        Image("evoligntehozastinpece")
            .resizable()
            .scaledToFit()
            .frame(width: 138, height: 166)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    yyqfohais_ioofbasn()
        .environmentObject(QuorraxisPersistVault.light)
}
