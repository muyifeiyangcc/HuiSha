import SwiftUI

struct njaueiqb_zzneefja: View {
    var targetId: Int = 0
    var reportAction: () -> Void = {}
    var blockAction: () -> Void = {}
    var deleteAction: () -> Void = {}

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
                    Button {
                        reportAction()
                    } label: {
                        Text("举报")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .frame(width: 255, height: 48)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        blockAction()
                    } label: {
                        Text("拉黑")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .frame(width: 255, height: 48)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        deleteAction()
                    } label: {
                        Text("删除")
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

#Preview {
    njaueiqb_zzneefja()
}
