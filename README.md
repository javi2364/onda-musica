# Onda + Brave — Playlist Coche

Proyecto web de biblioteca musical publicado con GitHub Pages.

**Acceso:** https://javi2364.github.io/onda-musica/

## Qué está implementado
- Diseño Onda + Brave, adaptable a PC y iPhone.
- Las **281 canciones de Coche** con título, artistas, duración y carátulas.
- Búsqueda y filtrado por artista o título, favoritos persistidos localmente.
- **6 URLs directas de vídeo verificadas en canales oficiales** de YouTube: `WAOH`, `Miedo y Asco en Madrid`, `Universitaria`, `Chamaquita`, `Bandolero` y `Fumando Serio`.
- **275 enlaces de búsqueda específicos**, generados automáticamente con título y artista, **no vídeos verificados**.
- Botón para abrir el contenido seleccionado en Brave (esquema de URL del navegador iOS) y alternativa HTTPS.
- Opción de guardar una URL verificada por canción en el navegador.

## Cómo usarlo en iPhone
1. Abre Onda y elige la canción.
2. Toca **Abrir en Brave**. Si el sistema bloquea el salto de aplicación, abre Onda directamente desde Brave y usa **Abrir en YouTube**.
3. Si ves una página de resultados, elige el vídeo original.
4. En Brave, usa el icono de **Playlist** de la barra para añadir ese contenido si lo permite.
5. Reproduce desde Brave Playlist. La reproducción en segundo plano/pantalla bloqueada depende de Brave, el sitio y la versión.

**Límites importantes:** Onda no reproduce vídeos de YouTube en su reproductor ni controla la lista interna de Brave. No puede enviar automáticamente las 281 canciones a Brave Playlist, eliminar anuncios desde su propia página ni reproducir toda la cola por sí sola. Los enlaces de búsqueda no deben interpretarse como coincidencias confirmadas.

## Versiones
La versión antigua que utilizaba Audius se conserva en `onda-auto-anterior.html`.

## Publicación
**Settings → Pages → Deploy from a branch → main → /(root)**

El proyecto no contiene archivos de audio ni códigos de acceso privados.
