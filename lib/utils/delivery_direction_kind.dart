class DeliveryDirectionKind {
  static const String send = 'send';
  static const String receive = 'receive';

  static String label(String kind, {bool spanish = true}) {
    if (kind == receive) {
      return spanish ? 'Recibir' : 'Receive';
    }
    return spanish ? 'Enviar' : 'Send';
  }

  static String pickupHint(String kind, {bool spanish = true}) {
    if (kind == receive) {
      return spanish ? 'Dónde recoger el paquete' : 'Package pickup point';
    }
    return spanish ? 'Desde dónde envías' : 'Where you send from';
  }

  static String dropHint(String kind, {bool spanish = true}) {
    if (kind == receive) {
      return spanish ? 'Dónde te entregamos' : 'Your delivery address';
    }
    return spanish ? 'A dónde entregamos' : 'Delivery destination';
  }
}
