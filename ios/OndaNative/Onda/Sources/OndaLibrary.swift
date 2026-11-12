import Foundation
import Combine

struct Track: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let artist: String
    let album: String
    let cover: String
    let duration: Int
    let videoId: String?

    var firstArtist: String {
        artist.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? artist
    }

    var formattedDuration: String {
        String(format: "%d:%02d", duration / 60, duration % 60)
    }
}

final class OndaLibrary: ObservableObject {
    let tracks: [Track]
    @Published private(set) var favorites: Set<String>
    @Published private(set) var savedVideoURLs: [String: String]

    init() {
        if let path = Bundle.main.url(forResource: "tracks", withExtension: "json"),
           let data = try? Data(contentsOf: path),
           let decoded = try? JSONDecoder().decode([Track].self, from: data) {
            tracks = decoded
        } else {
            tracks = []
        }

        let favData = UserDefaults.standard.data(forKey: "onda.favorites") ?? Data()
        favorites = Set((try? JSONDecoder().decode([String].self, from: favData)) ?? [])

        let urlData = UserDefaults.standard.data(forKey: "onda.videoURLs") ?? Data()
        savedVideoURLs = (try? JSONDecoder().decode([String: String].self, from: urlData)) ?? [:]
    }

    func isFavorite(_ song: Track) -> Bool {
        favorites.contains(song.id)
    }

    func toggleFavorite(_ song: Track) {
        if favorites.contains(song.id) {
            favorites.remove(song.id)
        } else {
            favorites.insert(song.id)
        }
        if let data = try? JSONEncoder().encode(Array(favorites)) {
            UserDefaults.standard.set(data, forKey: "onda.favorites")
        }
    }

    func playbackPage(for song: Track) -> URL {
        if let saved = savedVideoURLs[song.id], let url = URL(string: saved) {
            return url
        }
        if let videoId = song.videoId, !videoId.isEmpty {
            // Existing Onda association, not independently retested on device.
            return URL(string: "https://m.youtube.com/watch?v=\(videoId)")!
        }

        var components = URLComponents(string: "https://m.youtube.com/results")!
        components.queryItems = [
            URLQueryItem(name: "search_query",
                         value: "\(song.title) \(song.firstArtist) audio oficial")
        ]
        return components.url!
    }

    func saveCurrentVideo(for song: Track, pageURL: URL) -> Bool {
        guard let canonical = Self.youtubeVideoURL(from: pageURL) else {
            return false
        }
        savedVideoURLs[song.id] = canonical.absoluteString
        if let data = try? JSONEncoder().encode(savedVideoURLs) {
            UserDefaults.standard.set(data, forKey: "onda.videoURLs")
        }
        return true
    }

    static func youtubeVideoURL(from url: URL) -> URL? {
        let host = (url.host ?? "").lowercased()
        let videoId: String?
        if ["youtube.com", "www.youtube.com", "m.youtube.com", "music.youtube.com"].contains(host),
           url.path == "/watch" {
            videoId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "v" })?.value
        } else if host == "youtu.be" || host == "www.youtu.be" {
            videoId = url.path.split(separator: "/").first.map(String.init)
        } else {
            return nil
        }

        guard let id = videoId,
              id.range(of: "^[A-Za-z0-9_-]{11}$", options: .regularExpression) != nil else {
            return nil
        }
        return URL(string: "https://m.youtube.com/watch?v=\(id)")
    }
}
