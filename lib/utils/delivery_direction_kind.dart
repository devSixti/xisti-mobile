class DeliveryDirectionKind {
  static const String send = 'send';
  static const String receive = 'receive';

  static String label(String kind, {bool spanish = true}) {
    if (kind == receive) {
      return spanish ? 'Recibir' : 'Receive';
    }
    return spanish ? 'Enviar' : 'Send';
  }
}
