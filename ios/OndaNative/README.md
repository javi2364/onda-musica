# Onda nativa · experimento tipo Demus (iOS)

Esta carpeta contiene un **prototipo de aplicación iOS en SwiftUI** que prueba el enfoque descrito públicamente por Demus: biblioteca local y **sitio web oficial de YouTube dentro de un navegador integrado** (`WKWebView`), sin descarga ni extracción de audio.

**Estado: código fuente preparado para compilación; reproducción real sin verificar en iPhone.** No se garantiza reproducción en segundo plano de YouTube, ausencia de publicidad, continuidad entre vídeos ni disponibilidad de todas las canciones.

## Funcionalidades incluidas

- Las **281 canciones** de la playlist Coche, empaquetadas como metadatos JSON.
- Biblioteca con carátulas, artista, duración, buscador y filtro de favoritos.
- Persistencia local de favoritos y enlaces de vídeos con UserDefaults.
- Navegación a YouTube **dentro de la app**, sin saltar a Brave.
- Búsqueda precargada de canción y artista cuando no hay URL directa.
- Seis asociaciones antiguas que estaban en Onda web, **pendientes de validar en el dispositivo**.
- Posibilidad de guardar el vídeo actual que el usuario elija en YouTube.
- Configuración del modo iOS `UIBackgroundModes: [audio]` y `AVAudioSession.Category.playback`. Estas opciones **no fuerzan** a YouTube a reproducirse con la pantalla bloqueada.

La web anterior sigue en la raíz de este repositorio y no se ha modificado por este experimento.

## Generar la aplicación con Xcode

Se necesita un Mac con Xcode reciente (se recomienda Xcode 16 o superior). El código se prepara con [XcodeGen](https://github.com/yonaskolb/XcodeGen):

```bash
brew install xcodegen
cd ios/OndaNative
xcodegen generate
open OndaPersonal.xcodeproj
```

En Xcode, selecciona el target **OndaPersonal**, elige tu equipo o cuenta Apple en **Signing & Capabilities**, y ejecuta la aplicación en un iPhone físico. Con una cuenta Apple gratuita puedes probarla personalmente, pero el aprovisionamiento puede caducar y exigir renovar la instalación. Esto no es una app ya instalada ni un IPA distribuible.

## Prueba imprescindible en iPhone

1. Abre Onda, selecciona una canción y elige su vídeo en la página de YouTube integrada.
2. Comprueba que se reproduce completo en primer plano.
3. Bloquea el iPhone y comprueba si la reproducción sigue. Repite con varias canciones.
4. Comprueba si finalizado un vídeo se inicia otro automáticamente y cómo funcionan los controles del sistema.
5. Comprueba anuncios, fallos de login o errores de reproducción. Si se interrumpe, no consideres esta funcionalidad implementada.

**Aviso:** activar el modo de audio en segundo plano de iOS no permite eludir políticas de YouTube. Este proyecto no bloquea publicidad, oculta el reproductor, extrae audio/vídeo, utiliza scripts para manipular el sitio ni intenta saltarse sus controles.

## Privacidad y almacenamiento

Solo guardamos títulos, artistas, carátulas, favoritos y asociaciones de enlaces. El contenido se solicita directamente a YouTube desde la propia web. Si inicias sesión en YouTube, esa sesión pertenece al almacenamiento web de WebKit; Onda no solicita credenciales ni tokens de Google. No hay servidor propio.

## Referencias

- Arquitectura declarada de Demus: https://demus.app/privacy.html
- Apple AVAudioSession/background: https://developer.apple.com/documentation/avfoundation/configuring-your-app-for-media-playback
- Políticas YouTube: https://developers.google.com/youtube/terms/developer-policies

