import SwiftUI
import WebKit
import AVFAudio

struct ContentView: View {
    @StateObject private var library = OndaLibrary()
    @State private var query = ""
    @State private var favoritesOnly = false
    @State private var selectedTrack: Track?

    private let purple = Color(red: 0.73, green: 0.51, blue: 0.98)

    private var visibleTracks: [Track] {
        library.tracks.filter { track in
            (!favoritesOnly || library.isFavorite(track)) &&
            (query.isEmpty ||
             track.title.localizedCaseInsensitiveContains(query) ||
             track.artist.localizedCaseInsensitiveContains(query) ||
             track.album.localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TU BIBLIOTECA").font(.caption2.bold()).tracking(2)
                        .foregroundStyle(purple)
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Coche").font(.largeTitle.bold())
                            Text("\(library.tracks.count) canciones importadas")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "waveform")
                            .font(.largeTitle).foregroundStyle(purple)
                    }
                    Picker("Mostrar", selection: $favoritesOnly) {
                        Text("Todas").tag(false)
                        Text("Favoritas").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.14, green: 0.10, blue: 0.21))

                List(visibleTracks) { song in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: song.cover)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.purple.opacity(0.24))
                                .overlay(Image(systemName: "music.note"))
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 3) {
                            Text(song.title)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)
                            Text(song.artist)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            Text(song.formattedDuration)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        Spacer(minLength: 5)
                        Button {
                            library.toggleFavorite(song)
                        } label: {
                            Image(systemName: library.isFavorite(song) ? "heart.fill" : "heart")
                                .foregroundStyle(purple)
                                .frame(width: 34, height: 44)
                        }
                        .buttonStyle(.borderless)

                        Button {
                            selectedTrack = song
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                                .foregroundStyle(purple)
                                .frame(width: 37, height: 44)
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Abrir \(song.title) dentro de Onda")
                    }
                    .listRowBackground(Color(red: 0.10, green: 0.09, blue: 0.15))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(Color(red: 0.06, green: 0.05, blue: 0.10))
            .navigationTitle("Onda")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Canción, artista o álbum")
            .sheet(item: $selectedTrack) { track in
                YouTubePlayerScreen(track: track)
                    .environmentObject(library)
            }
        }
        .tint(purple)
        .preferredColorScheme(.dark)
    }
}

struct YouTubePlayerScreen: View {
    let track: Track
    @EnvironmentObject private var library: OndaLibrary
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage: URL?
    @State private var message = "La reproducción de YouTube depende de sus propias condiciones."

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Button("Cerrar") { dismiss() }
                    .font(.subheadline.weight(.semibold))
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(track.title).font(.subheadline.bold()).lineLimit(1)
                    Text(track.firstArtist).font(.caption2).foregroundStyle(.secondary)
                }
            }
            .padding(15)

            // The *visible, unmodified* official YouTube webpage stays within Onda.
            YouTubeBrowser(startURL: library.playbackPage(for: track),
                           currentPage: $currentPage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                if let url = currentPage,
                   OndaLibrary.youtubeVideoURL(from: url) != nil {
                    Button("Guardar este vídeo para \(track.title)") {
                        if library.saveCurrentVideo(for: track, pageURL: url) {
                            message = "Vídeo asociado. Se abrirá directamente la próxima vez."
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                Text(message)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("Prueba en un iPhone físico: la web puede detenerse al bloquear la pantalla. No se bloquean anuncios ni se extrae audio.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.12, green: 0.10, blue: 0.16))
        }
        .background(Color.black)
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                message = "No se pudo activar el audio: \(error.localizedDescription)"
            }
        }
        .preferredColorScheme(.dark)
    }
}
