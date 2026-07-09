import Combine
import SwiftUI

final class QuorraxisPersistVault: ObservableObject {
    static let light = QuorraxisPersistVault()
    private init() {}

    @AppStorage("quorraxis.auvrionSelqareth") var auvrionSelqareth: Int = 271968103
    @AppStorage("quorraxis.nyraxisCalvethor") var nyraxisCalvethor: Bool = false
    @AppStorage("quorraxis.vellumAsterion") var vellumAsterion: Bool = false
    @AppStorage("quorraxis.sylvarnEphorix") var sylvarnEphorix: Bool = false
}

@main
struct HuiShaApp: App {
    @StateObject private var persistVault = QuorraxisPersistVault.light

    var body: some Scene {
        WindowGroup {
            MirelleAuvrion()
                .environmentObject(persistVault)
        }
    }
}
