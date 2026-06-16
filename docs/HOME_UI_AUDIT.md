# Auditoría UI — Xisti vs Zimo (home pasajero)

| Elemento | Zimo | Xisti (antes) | Xisti (nuevo layout) |
|----------|------|---------------|----------------------|
| Estructura | Mapa + panel fijo abajo | Igual | Mapa full + sheet draggable |
| Búsqueda origen/destino | En panel inferior | Igual | Tarjeta flotante superior |
| Modos de servicio | Cards en panel | Igual + encomiendas | Chips compactos sobre mapa |
| Vehículos | Horizontal scroll abajo | Igual | Dentro del sheet |
| CTA reserva | Fila inferior panel | Igual | Anclado al sheet |
| Marca | Zimo | Verde `#39FF14` + morado | Tokens `XistiHomeUiTokens` |
| Polyline ruta | Negro | Negro | Verde primario Xisti |
| Recientes | Panel set-route | Solo destino en set-route | + chips en search card |

Tokens: [`lib/utils/xisti_home_ui_tokens.dart`](../lib/utils/xisti_home_ui_tokens.dart)

Wireframe: [`store-assets/wireframes/NEW_HOME_LAYOUT.md`](../store-assets/wireframes/NEW_HOME_LAYOUT.md)
