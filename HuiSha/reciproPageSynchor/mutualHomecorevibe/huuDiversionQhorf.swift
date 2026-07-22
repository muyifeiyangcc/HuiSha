import SwiftUI

struct huuDiversionQhorf: View {
    var whisperAction: (Int) -> Void = { _ in }
    var addFriendAction: () -> Void = {}
    var openFriendProfileAction: (Int) -> Void = { _ in }
    var coinAction: () -> Void = {}
    var editProfileAction: () -> Void = {}
    var blacklistAction: () -> Void = {}
    var privacyAction: () -> Void = {}
    var userAgreementAction: () -> Void = {}
    var logoutAction: () -> Void = {}
    var deleteAccountAction: () -> Void = {}
    var loginPromptAction: () -> Void = {}

    @State private var asknuejkyqqocb = 0
    
    var body: some View {
        ZStack {
            switch asknuejkyqqocb {
            case 1:
                yyqfohais_ioofbasn(
                    kinraSummon: addFriendAction,
                    selqarethDrift: openFriendProfileAction,
                    whisperAction: whisperAction
                )
            case 2:
                truemirsou_thmunity(
                    coinAction: coinAction,
                    editProfileAction: editProfileAction,
                    blacklistAction: blacklistAction,
                    privacyAction: privacyAction,
                    userAgreementAction: userAgreementAction,
                    logoutAction: logoutAction,
                    deleteAccountAction: deleteAccountAction,
                    loginPromptAction: loginPromptAction
                )
            default:
                evewone_sopakco(whisperAction: whisperAction)
            }
            
            HStack {
                Button {
                    asknuejkyqqocb = 0
                } label: {
                    Image(asknuejkyqqocb == 0 ? "genuineticflow" : "spiritgridmatrix")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                .buttonStyle(.plain)
                
                Button {
                    asknuejkyqqocb = 1
                } label: {
                    Image(asknuejkyqqocb == 1 ? "trueessencecircle" : "soulpulsevibrant")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                
                Button {
                    asknuejkyqqocb = 2
                } label: {
                    Image(asknuejkyqqocb == 2 ? "heartwavesynergy" : "corebeaconguide")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 30)
            .padding(.horizontal, 28)
        }
        .ignoresSafeArea()
    }
}
