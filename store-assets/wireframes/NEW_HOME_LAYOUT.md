# Xisti — Nuevo home pasajero (wireframe)

## Objetivo
Diferenciar visualmente de Zimo: mapa dominante + búsqueda flotante arriba + sheet inferior draggable.

## Portrait (teléfono)

```
┌─────────────────────────────┐
│ [≡]                         │  ← cuenta (esquina)
│ ┌─────────────────────────┐ │
│ │ XISTI · Viaje urbano    │ │  ← hero subtítulo por modo
│ │ ○ Origen actual         │ │
│ │ ● ¿A dónde vas?         │ │
│ │ [Reciente A] [Reciente B]│ │  ← atajos destino (opcional)
│ └─────────────────────────┘ │
│ [Viajes][Envío][Encomiendas]│  ← chips multiservicio
│                             │
│         MAPA  (~75%)        │
│              📍             │
│                        [◎]  │  ← mi ubicación
│ ┌─────────────────────────┐ │
│ │ ─── handle ───          │ │
│ │ Moto  Carro  Motoratón  │ │  ← sheet peek
│ │ [ Ofrecer mi tarifa ]   │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

## Estados del sheet
- **Peek (~22%)**: vehículos + CTA
- **Medio (~45%)**: + campos encomienda si aplica
- **Expandido (~72%)**: scroll completo de opciones

## Landscape / tablet (futuro)
Mapa ~55% izquierda | panel booking ~45% derecha.

## Flag
`enable_xisti_new_home_layout` (API) / Hive — rollback al layout Zimo-like sin revertir código.
