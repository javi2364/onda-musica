import SwiftUI
import WebKit

/// Displays the genuine YouTube mobile website without injected scripts,
/// advertising filters or extraction of audio/video stream addresses.
struct YouTubeBrowser: UIViewRepresentable {
    let startURL: URL
    @Binding var currentPage: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .all

        let browser = WKWebView(frame: .zero, configuration: configuration)
        browser.navigationDelegate = context.coordinator
        browser.uiDelegate = context.coordinator
        browser.allowsBackForwardNavigationGestures = true
        browser.isOpaque = false
        browser.backgroundColor = .black
        browser.scrollView.backgroundColor = .black
        browser.load(URLRequest(url: startURL))
        return browser
    }

    func updateUIView(_ browser: WKWebView, context: Context) {
        // Intentionally keep the same web view while SwiftUI redraws.
        // Recreating it would interrupt playback and discard page state.
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: YouTubeBrowser

        init(_ parent: YouTubeBrowser) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.currentPage = webView.url
        }

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            // Keep links opened by YouTube within the app.
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
