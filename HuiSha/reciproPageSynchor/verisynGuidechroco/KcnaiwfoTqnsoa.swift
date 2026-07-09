import SwiftUI
import WebKit

struct KcnaiwfoTqnsoa: View {
    let auvrionSelqareth: Bool
    var backAction: () -> Void = {}

    @State private var isLoading = true
    @State private var errorText: String?

    private var url: URL {
        let path = auvrionSelqareth ? "users" : "privacy"
        return URL(string: "https://app.dt8y0whb.link/\(path)")!
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Color.white
                    .frame(height: 100)

                ZStack {
                    QavrenWebLattice(url: url, isLoading: $isLoading, errorText: $errorText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    if isLoading {
                        ProgressView()
                            .tint(AuvrionChromatics.sylvarnEphorix)
                    }

                    if let errorText {
                        Text(errorText)
                            .font(.system(size: 15))
                            .foregroundColor(AuvrionChromatics.vellumQuorraxis)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()

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
            .padding(.leading, 15)
            .padding(.top, 49)
        }
        .ignoresSafeArea()
    }
}

private struct QavrenWebLattice: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var errorText: String?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = true
        webView.scrollView.backgroundColor = .white
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.loadedURL != url else { return }
        context.coordinator.loadedURL = url
        isLoading = true
        errorText = nil
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, errorText: $errorText)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var loadedURL: URL?
        private var isLoading: Binding<Bool>
        private var errorText: Binding<String?>

        init(isLoading: Binding<Bool>, errorText: Binding<String?>) {
            self.isLoading = isLoading
            self.errorText = errorText
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading.wrappedValue = false
            errorText.wrappedValue = nil
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            showFailure(error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            showFailure(error)
        }

        private func showFailure(_ error: Error) {
            isLoading.wrappedValue = false
            errorText.wrappedValue = "页面加载失败，请稍后重试"
        }
    }
}
