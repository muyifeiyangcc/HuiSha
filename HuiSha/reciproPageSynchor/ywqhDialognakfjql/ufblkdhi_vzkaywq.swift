//
//  ufblkdhi_vzkaywq.swift
//  HuiSha
//
//  Created by yangyang on 2026/7/3.
//

import SwiftUI

struct ufblkdhi_vzkaywq: View {
    var cancelAction: () -> Void = {}
    var loginAction: () -> Void = {}

    var body: some View {
        Image("uebqfbzdkpbvjbjaf")
            .resizable()
            .scaledToFit()
            .frame(height: 183)
            .overlay(
                HStack {
                    Button(action: cancelAction) {
                        Image("vbayidnaqyfzvkakfq")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: loginAction) {
                        Image("bvhqhaufzbkjvnqi")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                }
                    .padding(.bottom, 24),
                alignment: .bottom
            )
    }
}

#Preview {
    ufblkdhi_vzkaywq()
}
