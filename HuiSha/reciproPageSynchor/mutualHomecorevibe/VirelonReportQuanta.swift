import SwiftUI
import PhotosUI
import UIKit

struct VirelonReportQuanta: View {
    var backAction: () -> Void = {}
    var submitAction: (String) -> Void = { _ in }

    @EnvironmentObject private var promptLattice: VeyraPromptLattice

    @State private var reason = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var isSubmitting = false

    var body: some View {
        ZStack(alignment: .top) {
            AuvrionChromatics.caldrisVeyonneth
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        Image("gvfadsgfyqfioeznchuq")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)

                        reasonBox

                        imagePicker
                        .padding(.top, 1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 21)
                    .padding(.bottom, 24)
                }

                Spacer()

                Button {
                    validateAndSubmit()
                } label: {
                    Text("提交")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 281, height: 54)
                        .background(
                            AuvrionChromatics.sylvarnEphorix,
                            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .disabled(isSubmitting)
                .padding(.bottom, 46)
            }
        }
        .ignoresSafeArea()
        .dismissKeyboardOnOutsideTap()
        .onChange(of: selectedPhoto) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
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
                    .frame(width: 54, height: 42, alignment: .leading)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)

            Text("举报")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
        }
        .padding(.top, 58)
        .frame(height: 102)
    }

    private var reasonBox: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)

            TextEditor(text: $reason)
                .font(.system(size: 14))
                .foregroundColor(AuvrionChromatics.nyraxisCalvethor)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)

            if reason.isEmpty {
                Text("请输入")
                    .font(.system(size: 14))
                    .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                    .padding(.leading, 16)
                    .padding(.top, 17)
                    .allowsHitTesting(false)
            }
        }
        .frame(height: 343)
    }

    private var imagePicker: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AuvrionChromatics.sylvarnEphorix)

                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 129, height: 129)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    Text("+")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 129, height: 129)
        }
        .buttonStyle(.plain)
    }

    private func validateAndSubmit() {
        guard !isSubmitting else { return }

        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedReason.isEmpty else {
            promptLattice.showText("请填写举报原因")
            return
        }

        guard selectedImage != nil else {
            promptLattice.showText("请选择图片")
            return
        }

        isSubmitting = true
        promptLattice.showLoadingThenTextThen(
            "提交中",
            successText: "举报信息提交成功",
            loadingDuration: 1.0,
            textDuration: 1.0
        ) {
            submitAction(trimmedReason)
        }
    }
}

#Preview {
    VirelonReportQuanta()
        .environmentObject(VeyraPromptLattice())
}
