import SwiftUI

struct fbryqiw_nsoqlcu: View {
    var quorraxisExit: () -> Void = {}
    var auricErase: () -> Void = {}

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Image("laiebqvvckmcbayqv")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("更多操作")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                VStack(spacing: 8) {
                    Button(action: quorraxisExit) {
                        Text("退出登录")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .frame(width: 255, height: 48)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: auricErase) {
                        Text("删除账号")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .frame(width: 255, height: 48)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .background(AuvrionChromatics.caldrisVeyonneth)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 52)
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .ignoresSafeArea()
    }
}
