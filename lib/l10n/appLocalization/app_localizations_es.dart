// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'XISTI';

  @override
  String get tagline => 'Fácil y Seguro';

  @override
  String get splashScreenMsg =>
      'Fácil y Seguro — acuerda tu tarifa y muévete en Medellín.';

  @override
  String get year => 'año';

  @override
  String get years => 'años';

  @override
  String get month => 'mes';

  @override
  String get months => 'meses';

  @override
  String get week => 'semana';

  @override
  String get weeks => 'semanas';

  @override
  String get day => 'día';

  @override
  String get days => 'días';

  @override
  String get hour => 'hora';

  @override
  String get hours => 'horas';

  @override
  String get minute => 'minuto';

  @override
  String get minutes => 'minutos';

  @override
  String get seconds => 'segundos';

  @override
  String get justNow => 'ahora mismo';

  @override
  String get ago => 'hace';

  @override
  String get serverError => 'Error del servidor';

  @override
  String get connectionLost => 'Conexión perdida';

  @override
  String get ok => 'Aceptar';

  @override
  String get retry => 'Reintentar';

  @override
  String get serverErrorMessage =>
      'Parece que hay un problema\ncon nuestro servidor. Por favor, inténtalo más tarde.';

  @override
  String get internetConnLostMessage =>
      'No se puede conectar a internet.\nVerifica tu conexión e inténtalo de nuevo.';

  @override
  String get apiErrorCancelMsg => 'La solicitud al servidor fue cancelada';

  @override
  String get apiErrorConnectTimeoutMsg =>
      'Tiempo de conexión agotado con el servidor';

  @override
  String get apiErrorOtherMsg =>
      'Estás sin conexión. Por favor verifica tu internet.';

  @override
  String get apiErrorReceiveTimeoutMsg =>
      'Tiempo de espera agotado al recibir datos del servidor';

  @override
  String get apiErrorResponseMsg =>
      'Se recibió un código de respuesta inválido';

  @override
  String get apiErrorSendTimeoutMsg =>
      'Tiempo de espera agotado al enviar datos al servidor';

  @override
  String get apiErrorUnexpectedErrorMsg => 'Ocurrió un error inesperado';

  @override
  String get apiErrorCommunicationMsg =>
      'Ocurrió un error al comunicarse con el servidor. Código de estado';

  @override
  String get newUpdateAvailable => '¡Hay una nueva actualización disponible!';

  @override
  String get newUpdateMsg =>
      'Por favor, actualiza la app desde la tienda para continuar usándola.';

  @override
  String get update => 'Actualizar';

  @override
  String get locationMessageTitle =>
      'Permisos de ubicación y tratamiento de datos';

  @override
  String get locationMessage =>
      'XISTI utiliza la ubicación del dispositivo para facilitar la conexión entre usuarios y conductores independientes a través de la plataforma.\n\nCuando la aplicación está activa o en segundo plano, la ubicación puede utilizarse para:\n\n• Mostrar solicitudes cercanas.\n• Mejorar la precisión de los recorridos.\n• Facilitar la ubicación entre usuarios y conductores.\n• Mantener actualizada la disponibilidad dentro de la plataforma.\n\nFunción: Plataforma tecnológica de conexión entre usuarios y conductores independientes.\n\nLa información será tratada de acuerdo con nuestra Política de Privacidad y Tratamiento de Datos Personales.\n\nPor favor, permite el acceso a tu ubicación \"Siempre\" si eres conductor independiente.';

  @override
  String get preferences => 'Preferencias';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get selectCurrency => 'Seleccionar moneda';

  @override
  String get preferenceMsg =>
      'Puedes cambiar estas opciones más adelante en la app.';

  @override
  String get obTitle1 => 'Tu ciudad, tu ruta';

  @override
  String get obMsg1 =>
      'Marca tu destino en Medellín y encuentra conductor urbano en minutos.';

  @override
  String get obTitle2 => 'Indica tu tarifa';

  @override
  String get obMsg2 =>
      'Ofrece en pasos de 500 COP y acuerda un precio justo, estilo movilidad urbana.';

  @override
  String get obTitle3 => 'Viaja seguro';

  @override
  String get obMsg3 =>
      'Conductores verificados, pagos flexibles y la confianza XISTI: Fácil y Seguro.';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get welcomeTo => 'Bienvenido a';

  @override
  String get loginYourAccount => 'Ingresa a tu cuenta';

  @override
  String get contactNumber => 'Número de contacto';

  @override
  String get enterContactNumber => 'Ingresa tu número de contacto';

  @override
  String get sendOTP => 'Enviar código';

  @override
  String get orLoginWith => 'O inicia sesión con';

  @override
  String get loginWithTouchID => 'Iniciar sesión con huella o rostro';

  @override
  String get enableTouchID => 'Activar huella o reconocimiento facial';

  @override
  String get bioMetricsDisableMsg =>
      'Puedes activar esta opción una vez que hayas iniciado sesión.';

  @override
  String get bioMetricsPopupMsg =>
      'Escanea tu huella o rostro para verificar tu identidad.';

  @override
  String get authenticationRequired => '¡Se requiere verificación!';

  @override
  String get verifyIdentity => 'Verificar identidad';

  @override
  String get noThanks => 'No, gracias';

  @override
  String get enterOTPSendNumber => 'Ingresa el código enviado a tu número';

  @override
  String get enterOTPVerifyAccount =>
      'Ingresa el código para verificar tu cuenta.';

  @override
  String get continueTxt => 'Continuar';

  @override
  String get resend => 'Reenviar';

  @override
  String get startYour => 'Comienza tu';

  @override
  String get journeyWithUs => 'viaje con nosotros';

  @override
  String get registerAndStart => '¡Regístrate y empieza a explorar!';

  @override
  String get haveNotCode => '¿No recibiste el código?';

  @override
  String get ifNotGetCode =>
      'Si no recibiste el código, prueba una de las opciones a continuación.';

  @override
  String get retryIn => 'Reintentar en';

  @override
  String get changeNumber => 'Cambiar número';

  @override
  String get sendAgain => 'Enviar de nuevo';

  @override
  String get resendOtpSuccessMsg =>
      'Se envió un nuevo código a tu número registrado';

  @override
  String get resendOtpWhatsappSuccessMsg =>
      'Te enviamos un nuevo código por WhatsApp';

  @override
  String get otpSentViaWhatsappHint =>
      'Si tu operador bloquea SMS, el código puede llegarte por WhatsApp.';

  @override
  String get yourName => 'Tu nombre';

  @override
  String get failed => 'Fallido';

  @override
  String get email => 'Correo electrónico';

  @override
  String get referralCode => 'Código de referido';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get enterValidFullName =>
      'Ingresa un nombre válido usando solo letras y espacios';

  @override
  String get enterEmailAddress => 'Ingresa tu correo electrónico';

  @override
  String get invalidEmailAddress => 'Correo electrónico inválido';

  @override
  String get byRegisterYouAgree => 'He leído y acepto los';

  @override
  String get termsCondition => 'Términos y Condiciones';

  @override
  String get privacyPolicy => 'Política de Privacidad y Tratamiento de Datos';

  @override
  String get platformConnectionNotice =>
      'Entiendo que XISTI es una plataforma tecnológica de conexión entre usuarios y conductores independientes, y que no presta servicios de transporte ni opera vehículos.';

  @override
  String get driverIndependentNotice =>
      'Declaro que actúo como conductor independiente y que el uso de la plataforma XISTI no genera relación laboral, subordinación, representación comercial ni exclusividad alguna con XISTI.';

  @override
  String get deliveryLegalNotice =>
      'Los envíos corresponden a entregas gestionadas entre usuarios mediante la plataforma. XISTI facilita la conexión entre las partes y no presta servicios de transporte de pasajeros ni de carga.';

  @override
  String get agreeAndContinue => 'Aceptar y continuar';

  @override
  String get marketingOptIn =>
      'Autorizo recibir comunicaciones, novedades y promociones de XISTI.';

  @override
  String get account => 'Cuenta';

  @override
  String get driverMode => 'Modo conductor';

  @override
  String get passengerMode => 'Modo usuario';

  @override
  String get rideHistory => 'Historial de viajes';

  @override
  String get notification => 'Notificación';

  @override
  String get myWallet => 'Mi billetera';

  @override
  String get referHistory => 'Historial de referidos';

  @override
  String get liveChat => 'Chat en vivo';

  @override
  String get myPreference => 'Mis preferencias';

  @override
  String get emergencyContact => 'Contacto de emergencia';

  @override
  String get inviteFriend => 'Invitar amigo';

  @override
  String get reportIssue => 'Reportar problema';

  @override
  String get help => 'Ayuda';

  @override
  String get manageAccount => 'Gestionar cuenta';

  @override
  String get agree => 'Acepto';

  @override
  String get pickUpLocation => 'Lugar de recogida';

  @override
  String get dropLocation => 'Lugar de destino';

  @override
  String get cash => 'Efectivo';

  @override
  String get card => 'Tarjeta';

  @override
  String get wallet => 'Billetera';

  @override
  String get offerMyFare => 'Ofertar valor';

  @override
  String get fetchingLocation => 'Obteniendo ubicación';

  @override
  String get stopPoint => 'Punto de parada';

  @override
  String get selectVehicle => 'Seleccionar vehículo';

  @override
  String get setRoute => 'Definir ruta';

  @override
  String get setLocationOnMap => 'Seleccionar ubicación en el mapa';

  @override
  String get confirmLocation => 'Confirmar ubicación';

  @override
  String get searchLocation => 'Buscar ubicación';

  @override
  String get selectYourLocation => 'Selecciona tu ubicación';

  @override
  String get selectLocation => 'Seleccionar ubicación';

  @override
  String get comments => 'Comentarios';

  @override
  String get writeYourComment => 'Escribe tu comentario';

  @override
  String get childSeatSafety => 'Silla de seguridad para niños';

  @override
  String get handicapAccess => 'Accesibilidad para personas con discapacidad';

  @override
  String get bookForOther => 'Reservar para otra persona';

  @override
  String get selectContactNumber => 'Seleccionar número de contacto';

  @override
  String get stop => 'Parada';

  @override
  String get km => 'Km';

  @override
  String get selectPickup => 'Seleccionar lugar de recogida';

  @override
  String get selectDrop => 'Seleccionar lugar de destino';

  @override
  String get selectStop => 'Seleccionar punto de parada';

  @override
  String get offerAmount => 'Monto ofertado';

  @override
  String get enterFareValue => 'Indica tu tarifa';

  @override
  String offerFareMin(String amount) {
    return 'El mínimo para esta solicitud es $amount';
  }

  @override
  String offerFareMax(String amount) {
    return 'Puedes ofertar hasta $amount';
  }

  @override
  String get scheduleRide => 'Agendar recorrido';

  @override
  String get autoAcceptDriverRide =>
      'Aceptar automáticamente al conductor independiente más cercano para tu oferta';

  @override
  String get findDrive => 'Conectar conductor';

  @override
  String get recommendedFare => 'Precio orientativo';

  @override
  String get minFare => 'Mínimo orientativo';

  @override
  String get maxFare => 'Máximo orientativo';

  @override
  String get recipientName => 'Nombre del destinatario';

  @override
  String get recipientNumber => 'Número del destinatario';

  @override
  String get parcelEstimatedPrice => 'Valor estimado del paquete';

  @override
  String get parcelNote => 'Nota del paquete';

  @override
  String get enterRecipientName => 'Ingresa el nombre del destinatario';

  @override
  String get enterRecipientNumber => 'Ingresa el número del destinatario';

  @override
  String get enterParcelEstimatedPrice =>
      'Ingresa el valor estimado del paquete';

  @override
  String get enterParcelNote => 'Ingresa una nota para el paquete';

  @override
  String get systemSelected => 'Automático';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get selectAppTheme => 'Seleccionar tema de la app';

  @override
  String get currentFare => 'Valor actual';

  @override
  String get cancelRide => 'Cancelar viaje';

  @override
  String get raiseFare => 'Ajustar oferta';

  @override
  String get myDetails => 'Mis datos';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get cropper => 'Recortar';

  @override
  String get online => 'En línea';

  @override
  String get offline => 'Desconectado';

  @override
  String kmAway(String km) {
    return 'A $km km de distancia';
  }

  @override
  String get noRecordFound => 'Lo siento !!\nNo se encontraron registros';

  @override
  String get manageDistance => 'Gestionar distancia';

  @override
  String get reset => 'Restablecer';

  @override
  String get apply => 'Aplicar';

  @override
  String get reject => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get pleaseSelectADistance => 'Por favor selecciona una distancia.';

  @override
  String get trackLocationInBackground => 'Rastrear ubicación en segundo plano';

  @override
  String changeRideFare(String name) {
    return '$name cambió el valor del recorrido.';
  }

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String permissionText1(String appName) {
    return 'Permite que $appName se muestre sobre otras apps';
  }

  @override
  String permissionText2(String appName) {
    return 'Permite que $appName se muestre sobre otras apps para recibir solicitudes de viaje cuando estés en línea.';
  }

  @override
  String get permissionText3 =>
      'Toca Permitir y activa el interruptor en la pantalla de Ajustes.';

  @override
  String get permissionText4 =>
      'Activa el ícono de acceso rápido para verlo sobre otras apps';

  @override
  String get quickAccessIcon => 'Ícono de acceso rápido';

  @override
  String get settingsPermission => 'Ir a Ajustes';

  @override
  String get yourDriverIsOnWay => 'Tu conductor está en camino';

  @override
  String get driverIsAtPickup => 'El conductor está en tu punto de recogida';

  @override
  String get driverHeadingDestination => 'El conductor va hacia tu destino';

  @override
  String get reachYourDestination => 'Has llegado a tu destino';

  @override
  String get call => 'Llamar';

  @override
  String get shareOTP => 'Compartir código';

  @override
  String get proceedToPay => 'Proceder al pago';

  @override
  String get pay => 'Pagar';

  @override
  String get payment => 'Pago';

  @override
  String get insufficientWalletBalance =>
      'No puedes pagar el viaje con la billetera porque no tienes saldo suficiente.';

  @override
  String get onlinePayment => 'Pago en línea';

  @override
  String get shareFeedBack => 'Enviar opinión';

  @override
  String get writeYourFeedBack => 'Escribe tu opinión';

  @override
  String get submit => 'Enviar';

  @override
  String get giveFeedbackErrorMsg => '¡Deja tu opinión!';

  @override
  String get rideDetail => 'Detalles del viaje';

  @override
  String get downloadInvoice => 'Descargar factura';

  @override
  String get completed => 'Completado';

  @override
  String get pending => 'Pendiente';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get accepted => 'Aceptado';

  @override
  String get running => 'En curso';

  @override
  String get rideDateTime => 'Fecha y hora del viaje';

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get paymentStatus => 'Estado del pago';

  @override
  String get bookingId => 'ID de reserva';

  @override
  String get invoiceDetail => 'Detalles de la factura';

  @override
  String get okay => 'Está bien';

  @override
  String get vehicleInformation => 'Información del vehículo';

  @override
  String get driverDetails => 'Datos del conductor';

  @override
  String get profileUpdateSuccessfully => 'Perfil actualizado con éxito.';

  @override
  String get txtToday => 'Hoy';

  @override
  String get txtUpcoming => 'Próximos';

  @override
  String get txtLast7Days => 'Últimos 7 días';

  @override
  String get txtThisMonth => 'Últimos 30 días';

  @override
  String get txtYear => 'Este año';

  @override
  String get txtAll => 'Todos';

  @override
  String get sortByDays => 'Ordenar por días';

  @override
  String get ongoing => 'En curso';

  @override
  String get itemDesc => 'Descripción del artículo';

  @override
  String get courierDetail => 'Detalles del envío';

  @override
  String get courierDateTime => 'Fecha y hora del envío';

  @override
  String get rideCompleteByAdminMsg => 'Viaje completado por el administrador';

  @override
  String get rideCancelByAdminMsg => 'Viaje cancelado por el administrador';

  @override
  String get startRide => 'Iniciar viaje';

  @override
  String get collectAmount => 'Cobrar monto';

  @override
  String collectAmountMsg(String collectionAmount) {
    return '¿Confirmás que cobraste $collectionAmount al cliente?';
  }

  @override
  String get rideOTPVerifyMsg => 'Pide el código al cliente e ingrésalo aquí.';

  @override
  String get start => 'Iniciar';

  @override
  String get collectPayment => 'Cobrar pago';

  @override
  String get rateUser => 'Calificar usuario';

  @override
  String get completeRide => 'Finalizar el viaje';

  @override
  String get errorMessageCommon =>
      'Algo salió mal. ¿Quieres intentarlo de nuevo?';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get min => 'min';

  @override
  String get other => 'Otro';

  @override
  String get offerFare => 'Ofertar valor';

  @override
  String get requiredMess => 'Por favor completa los datos a continuación.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get accountDelete => 'Eliminar cuenta';

  @override
  String get accountDeleteDialogMsg =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Cualquier saldo en tu billetera no será reembolsable.';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logOutDialogMsg => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get arrived => 'Llegué';

  @override
  String get enterOtp => 'Ingresar código';

  @override
  String get numberOfToll => 'Número de peajes';

  @override
  String get tollAmount => 'Monto del peaje';

  @override
  String get enterTollAmount => 'Ingresa el monto del peaje';

  @override
  String get enterNumberOfToll => 'Ingresa el número de peajes';

  @override
  String get reviewUser => 'Calificar usuario';

  @override
  String get reviewUserMsg => 'Califica al usuario del 1 al 5';

  @override
  String get showMore => 'Ver más';

  @override
  String get showLess => 'Ver menos';

  @override
  String get amount => 'Monto';

  @override
  String get claimed => 'Reclamado';

  @override
  String get rejected => 'Rechazado';

  @override
  String get manageAddress => 'Gestionar direcciones';

  @override
  String get home => 'Casa';

  @override
  String get work => 'Trabajo';

  @override
  String get addressDeletedSuccessMsg => 'Dirección eliminada con éxito';

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get enterContactName => 'Ingresa el nombre del contacto';

  @override
  String get sureToCancel => '¿Estás seguro de que quieres cancelar tu viaje?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get rideCancel => 'Viaje cancelado';

  @override
  String get from => 'Desde';

  @override
  String get at => 'A las';

  @override
  String get currentBalance => 'Saldo actual';

  @override
  String get history => 'Historial';

  @override
  String get transfer => 'Transferir';

  @override
  String get topUp => 'Recargar';

  @override
  String get cashOut => 'Retirar dinero';

  @override
  String get all => 'Todo';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get transactionNotFound => 'Transacción no encontrada';

  @override
  String get success => 'Éxito';

  @override
  String get successTransaction => 'Transferiste exitosamente';

  @override
  String get selectUser => 'Seleccionar usuario';

  @override
  String get searchByContactOrEmail => 'Buscar por contacto o correo';

  @override
  String get beneficial => 'Beneficiario';

  @override
  String get beneficialContactNumber => 'Número del beneficiario';

  @override
  String get beneficialEmail => 'Correo del beneficiario';

  @override
  String get amountToTransfer => 'Monto a transferir';

  @override
  String get enterAmount => 'Ingresa el monto';

  @override
  String get youCantTransfer => 'No puedes transferir más de';

  @override
  String get invalidAmountMsg => 'Ingresa un monto válido';

  @override
  String get customer => 'Cliente';

  @override
  String get driver => 'Conductor';

  @override
  String get enterContactOrEmailToSearchPerson =>
      'Ingresa el número o correo para buscar a la persona.';

  @override
  String get proceedToAddMoney => 'Proceder a agregar dinero';

  @override
  String get chooseAmount => 'Elegir monto';

  @override
  String get walletMinTopupNotice =>
      'Recarga mínima \$13.000 COP. Comisión XISTI 8% — más margen para conductores.';

  @override
  String get pleaseEnterAmount => 'Por favor ingresa o selecciona el monto.';

  @override
  String get walletAddSuccessful => 'Dinero agregado a la billetera con éxito';

  @override
  String get invalidRequestCashOutAmountMsg =>
      'No puedes retirar más de tu saldo disponible';

  @override
  String get pleaseEnterRequestCashOutAmount =>
      'Ingresa el monto que deseas retirar';

  @override
  String get enterValidRequestCashOutAmount =>
      'Ingresa un monto válido para retirar';

  @override
  String get cashOutSuccess => '¡Solicitud de retiro enviada con éxito!';

  @override
  String get requestToCash => 'Solicitar retiro';

  @override
  String get cashOutAmount => 'Monto a retirar';

  @override
  String get newRequest => 'Nueva solicitud';

  @override
  String get goBack => 'Volver';

  @override
  String get searchingForRideRequests => 'Buscando solicitudes de viaje\n';

  @override
  String get yourOfferIsBeingReviewedByCustomer =>
      'Tu oferta está siendo\nrevisada por el cliente';

  @override
  String distanceKm(String km) {
    return 'Distancia: $km km ';
  }

  @override
  String get reqRejectCustomer => 'Tu solicitud fue rechazada por el cliente.';

  @override
  String get enterCancelReason => 'Ingresa el motivo de cancelación';

  @override
  String get away => 'de distancia';

  @override
  String get otp => 'Código';

  @override
  String get rideCompleted => 'Viaje completado';

  @override
  String get rideCompletedMsg => 'Tu viaje fue completado con éxito.';

  @override
  String rideCancelBy(String name) {
    return '¡Viaje cancelado por $name!';
  }

  @override
  String get rateDriver => 'Calificar conductor';

  @override
  String get rideFare => 'Tarifa del viaje';

  @override
  String get totalPay => 'Total a pagar';

  @override
  String get referDiscount => 'Descuento por referido';

  @override
  String get inviteFriends => 'Invitar amigos';

  @override
  String get shareInvite => 'Compartir invitación';

  @override
  String get referFriendAndGetBenefits =>
      'Refiere a un amigo y gana beneficios';

  @override
  String get inviteFriendsMsg =>
      'Invita a tu amigo con este \ncódigo de referido y obtén más beneficios';

  @override
  String get use => 'Usar';

  @override
  String get referCodeGetDiscount => 'Código de referido y obtén descuento';

  @override
  String get download => 'Descargar';

  @override
  String get emergencyContactNumber => 'Número de emergencia';

  @override
  String get emergencyContactAddMsg =>
      'Puedes agregar un número de emergencia \ndesde tu perfil.';

  @override
  String get emergencyContactMsg =>
      'Puedes cambiar tu número de emergencia \ndesde tu perfil.';

  @override
  String get emergencyCall => 'Llamada de emergencia';

  @override
  String get addEmergencyContact => 'Agregar contacto de emergencia';

  @override
  String get manageVehicle => 'Gestionar vehículo';

  @override
  String get addAddress => 'Agregar dirección';

  @override
  String get editAddress => 'Editar dirección';

  @override
  String maxAddressMsg(int maxLimit) {
    return 'Puedes agregar máximo $maxLimit direcciones. Elimina una antes de agregar otra.';
  }

  @override
  String get saveAddress => 'Guardar dirección';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAddress => '¿Eliminar dirección?';

  @override
  String get deleteAddressDialogMsg =>
      '¿Estás seguro de que quieres eliminar esta dirección?';

  @override
  String get noAnyAddressMsg =>
      'No tienes direcciones guardadas. Agrega una para usarla al reservar un viaje.';

  @override
  String get heatMap => 'Mapa de calor';

  @override
  String get writeAMessageHere => 'Escribe un mensaje aquí';

  @override
  String get enterValidateNoTolls => 'Ingresa un número válido de peajes';

  @override
  String get enterValidateTollCharge => 'Ingresa un monto válido de peaje';

  @override
  String get whatWouldYouLikeToChoose => '¿Qué deseas elegir?';

  @override
  String get downloading => 'Descargando...';

  @override
  String get downloadingComplete => 'Descarga completada';

  @override
  String get downloadingFailed => 'Descarga fallida';

  @override
  String get pdfDownloadSuccessful => '¡PDF descargado con éxito!';

  @override
  String get downloadCancelled => '¡Descarga fallida!';

  @override
  String get fillYourInformation => 'Completa tu información';

  @override
  String driverRegisterMsg(String appName) {
    return 'Por favor completa tu información personal para empezar a ganar con $appName';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get proceed => 'Continuar';

  @override
  String get manageInformation => 'Gestionar información';

  @override
  String get drivingLicence => 'Licencia de conducir';

  @override
  String get addDocument => 'Agregar documento';

  @override
  String get uploadImage => 'Subir imagen';

  @override
  String get selectExpiryDateHere =>
      'Selecciona la fecha de vencimiento aquí...';

  @override
  String get uploadDocument => 'Subir documento';

  @override
  String get updateDocument => 'Actualizar documento';

  @override
  String get selectDocument => 'Por favor selecciona un documento';

  @override
  String get expiryDate => 'Fecha de vencimiento';

  @override
  String get selectExpiryDate => 'Seleccionar fecha de vencimiento';

  @override
  String get emptyDocument =>
      'Este documento no es necesario para este servicio';

  @override
  String get document => 'Documento';

  @override
  String get upload => 'Subir';

  @override
  String get add => 'Agregar';

  @override
  String get approved => 'Aprobado';

  @override
  String get noDocument => 'Sin documento';

  @override
  String get expired => 'Vencido';

  @override
  String get customerDetails => 'Datos del cliente';

  @override
  String get rideEstimation => 'Estimación del viaje';

  @override
  String get customerName => 'Nombre del cliente';

  @override
  String get customerNumber => 'Número del cliente';

  @override
  String get confirm => 'Confirmar';

  @override
  String get addCustomerDetails => 'Agregar datos del cliente';

  @override
  String get bankDetails => 'Datos bancarios';

  @override
  String get updateBankDetailSuccessMsg =>
      '¡Tus datos bancarios se actualizaron con éxito!';

  @override
  String get enterAccountNumber => 'Ingresa el número de cuenta';

  @override
  String get accountNumber => 'Número de cuenta';

  @override
  String get enterAccountHolderName => 'Ingresa el nombre del titular';

  @override
  String get accountHolderName => 'Nombre del titular';

  @override
  String get enterBankName => 'Ingresa el nombre del banco';

  @override
  String get bankName => 'Nombre del banco';

  @override
  String get enterBankLocation => 'Ingresa la sucursal del banco';

  @override
  String get bankLocation => 'Sucursal del banco';

  @override
  String get enterSwiftCode => 'Ingresa el código BIC/SWIFT';

  @override
  String get swiftCode => 'Código BIC/SWIFT';

  @override
  String get feedback => 'Opinión';

  @override
  String get rating => 'Calificación';

  @override
  String get viewRide => 'Ver viaje';

  @override
  String get addIssue => 'Agregar problema';

  @override
  String get myReportedIssue => 'Mis problemas reportados';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get chooseAnOrderWithIssue => 'Elige un viaje con problema';

  @override
  String get reportGeneralIssue => 'Reportar problema general';

  @override
  String get resolved => 'Resuelto';

  @override
  String get unResolved => 'Sin resolver';

  @override
  String get general => 'General';

  @override
  String get issueNotFound => 'Problema no encontrado';

  @override
  String get ticketId => 'ID del ticket';

  @override
  String get description => 'Descripción';

  @override
  String get enterDescription => 'Ingresa la descripción';

  @override
  String get deleteImage => 'Eliminar imagen';

  @override
  String get deleteImageMsg =>
      '¿Estás seguro de que quieres eliminar esta imagen?';

  @override
  String get rideId => 'ID del viaje';

  @override
  String get orderNotFound => 'Pedido no encontrado';

  @override
  String uploadMinImagesMsg(int minIssueImageCount) {
    return 'Por favor sube al menos $minIssueImageCount imágenes.';
  }

  @override
  String get chat => 'Chat';

  @override
  String get submitIssue => 'Enviar problema';

  @override
  String get manufactureName => 'Marca';

  @override
  String get modelName => 'Modelo / Referencia';

  @override
  String get vehiclePlateNumber => 'Número de placa';

  @override
  String get vehicleColor => 'Color del vehículo';

  @override
  String get vehicleYear => 'Año del vehículo';

  @override
  String get selectVehicleType => 'Seleccionar tipo de vehículo';

  @override
  String get selectVehicleYear => 'Seleccionar año del vehículo';

  @override
  String get selectItem => 'Seleccionar elemento';

  @override
  String get enterManufactureName => 'Ingresa la marca';

  @override
  String get enterModelName => 'Ingresa modelo o referencia';

  @override
  String get enterVehiclePlateNumber => 'Ingresa el número de placa';

  @override
  String get enterVehicleColor => 'Ingresa el color del vehículo';

  @override
  String get done => 'Listo';

  @override
  String get uploadVehicleImage => 'Subir imagen del vehículo';

  @override
  String get imageUploaded => 'Imagen subida';

  @override
  String get vehicleDetailsUploadedSuccessfully =>
      'Datos del vehículo subidos con éxito.';

  @override
  String get cancellationReason => 'Motivo de cancelación';

  @override
  String get trackRide => 'Rastrear viaje';

  @override
  String get verificationPending => 'Verificación pendiente';

  @override
  String get driverBlock => 'Conductor bloqueado por el administrador';

  @override
  String get pendingMessage =>
      'Gracias por tu solicitud. Te notificaremos por correo cuando revisemos tus documentos.';

  @override
  String get driverRejectedByAdmin =>
      'Conductor rechazado por el administrador';

  @override
  String get goToHome => 'Ir al inicio';

  @override
  String get hailModule => 'Ponte en línea para recibir viajes';

  @override
  String get noteFromCustomer => 'Nota del cliente';

  @override
  String get yourAdditionalNote => 'Tu nota adicional';

  @override
  String get passengerName => 'Nombre del pasajero';

  @override
  String get submitOTP => 'Enviar código';

  @override
  String get percentage => 'Porcentaje';

  @override
  String get cancelBy => 'Cancelado por';

  @override
  String get schedule => 'Programar';

  @override
  String get expiryDateValidation =>
      'La fecha de vencimiento parece ser en el pasado. Por favor verifícala.';

  @override
  String get selectScheduleDate => 'Seleccionar fecha programada';

  @override
  String get googleMapsLimitMessage =>
      'Alcanzaste el límite diario de uso de Google Maps. Inténtalo mañana.';

  @override
  String get usageLimitReached => 'Límite de uso alcanzado';

  @override
  String get processing => 'Procesando';

  @override
  String get faceVerification => 'Verificación facial';

  @override
  String get positionFaceInCircle => 'Coloca tu rostro en el círculo';

  @override
  String get blinkEyesNow => 'Ahora parpadea';

  @override
  String get verificationSuccessful => '¡Verificación exitosa!';

  @override
  String get onlyOneFaceAllowed => 'Solo se permite un rostro';

  @override
  String get cameraPermissionRequired => 'Se requiere permiso de cámara';

  @override
  String get cameraPermissionMessage =>
      'Esta app necesita acceso a la cámara para verificar tu identidad. Actívalo en ajustes.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get noCamerasFound => 'No se encontraron cámaras.';

  @override
  String get failedToCaptureImagePleaseTryAgain =>
      'No se pudo capturar la imagen. Inténtalo de nuevo.';

  @override
  String get loading => 'Cargando';

  @override
  String get pleaseAddProfileImage =>
      'Por favor agrega tu foto de perfil para continuar.';

  @override
  String get profilePictureUpload => 'Subir foto de perfil';

  @override
  String get profilePictureUploadMsg =>
      'Falta tu foto de perfil. Súbela para poder realizar pedidos.';

  @override
  String get platformCommission => 'Comisión plataforma (8%)';

  @override
  String get vatOnCommission => 'IVA sobre comisión (19%)';

  @override
  String get totalDeduction => 'Total descuentos';

  @override
  String get netDriverEarnings => 'Neto conductor';

  @override
  String get invalidMobileNumberCo => 'Ingresa un celular válido de 10 dígitos';

  @override
  String get invalidVehiclePlate =>
      'Ingresa una placa válida (5 a 8 caracteres)';
}
