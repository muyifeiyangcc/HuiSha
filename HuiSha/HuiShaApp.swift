//
//  HuiShaApp.swift
//  HuiSha
//
//  Created by yangyang on 2026/7/1.
//

import Combine
import SwiftUI

final class QuorraxisPersistVault: ObservableObject {
    static let light = QuorraxisPersistVault()
    private init() {}

//    当前用户id
    @AppStorage("quorraxis.auvrionSelqareth") var auvrionSelqareth: Int = 271968103
//    是否持久化进入首页
    @AppStorage("quorraxis.nyraxisCalvethor") var nyraxisCalvethor: Bool = false
//    是否同意eula
    @AppStorage("quorraxis.vellumAsterion") var vellumAsterion: Bool = false
//    是否登录
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
