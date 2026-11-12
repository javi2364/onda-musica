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

## Instalar desde un PC Windows sin Mac

También puedes preparar una **IPA sin firmar** desde el repositorio público. GitHub Actions proporciona un Mac remoto gratuito para compilar (el resultado solo sirve para instalar después de firmarlo con tu propia cuenta Apple).

1. Abre [Compilar Onda iPhone](https://github.com/javi2364/onda-musica/actions/workflows/ios-build.yml).
2. Comprueba que una ejecución termina en verde (si está en rojo, lee el error: todavía no hay IPA funcional).
3. En la ejecución, ve a **Artifacts** y descarga `OndaPersonal-unsigned-IPA`; descomprime el ZIP y obtén `OndaPersonal-unsigned.ipa`.
4. En tu PC de casa, instala [AltStore Classic para Windows](https://faq.altstore.io/altstore-classic/how-to-install-altstore-windows) siguiendo **solo la documentación oficial**. Necesitas iTunes/iCloud de Apple, AltServer, un cable para conectar el iPhone y tu propia cuenta de Apple. No compartas tu contraseña conmigo ni la subas a GitHub.
5. Instala AltStore Classic en el iPhone con AltServer, activa el **Modo desarrollador** en el iPhone cuando lo solicite iOS y, desde AltStore, importa la IPA descargada para firmarla e instalarla.
6. Con un Apple ID gratuito tendrás que **renovar la firma como máximo cada 7 días** (es un requisito del aprovisionamiento gratuito de Apple). La instalación no significa que YouTube vaya a reproducirse sin anuncios o con la pantalla bloqueada.

**Si GitHub Actions falla, no instales un IPA antiguo**. Este código es experimental y aún no se ha compilado/verificado en un dispositivo físico.

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

