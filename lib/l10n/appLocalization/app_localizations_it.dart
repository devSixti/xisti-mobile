// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'XISTI';

  @override
  String get tagline => 'Facile e Sicuro';

  @override
  String get splashScreenMsg =>
      'Facile e Sicuro — negozia la tariffa a Medellín.';

  @override
  String get year => 'anno';

  @override
  String get years => 'anni';

  @override
  String get month => 'mese';

  @override
  String get months => 'mesi';

  @override
  String get week => 'settimana';

  @override
  String get weeks => 'settimane';

  @override
  String get day => 'giorno';

  @override
  String get days => 'giorni';

  @override
  String get hour => 'ora';

  @override
  String get hours => 'ore';

  @override
  String get minute => 'minuto';

  @override
  String get minutes => 'Minuti';

  @override
  String get seconds => 'secondi';

  @override
  String get justNow => 'proprio ora';

  @override
  String get ago => 'fa';

  @override
  String get serverError => 'Errore del server';

  @override
  String get connectionLost => 'Connessione persa';

  @override
  String get ok => 'Ok';

  @override
  String get retry => 'Riprova';

  @override
  String get serverErrorMessage =>
      'Sembra esserci un problema\ncon il nostro server. Per favore riprova più tardi.';

  @override
  String get internetConnLostMessage =>
      'Impossibile connettersi a Internet.\nControlla la tua connessione e riprova.';

  @override
  String get apiErrorCancelMsg =>
      'La richiesta al server API è stata annullata';

  @override
  String get apiErrorConnectTimeoutMsg =>
      'Timeout di connessione con il server API';

  @override
  String get apiErrorOtherMsg =>
      'Sei offline. Controlla la tua connessione a internet.';

  @override
  String get apiErrorReceiveTimeoutMsg =>
      'Timeout di ricezione nella connessione con il server API';

  @override
  String get apiErrorResponseMsg => 'Codice di stato non valido ricevuto';

  @override
  String get apiErrorSendTimeoutMsg =>
      'Timeout di invio nella connessione con il server API';

  @override
  String get apiErrorUnexpectedErrorMsg =>
      'Si è verificato un errore imprevisto';

  @override
  String get apiErrorCommunicationMsg =>
      'Si è verificato un errore durante la comunicazione con il server con StatusCode';

  @override
  String get newUpdateAvailable => 'Nuovo aggiornamento disponibile!';

  @override
  String get newUpdateMsg =>
      'Aggiorna la nuova app dallo store per continuare ad accedere.';

  @override
  String get update => 'Aggiorna';

  @override
  String get locationMessageTitle => 'Informativa';

  @override
  String get locationMessage =>
      'Questa app raccoglie dati sulla posizione per consentire di ricevere nuove corse taxi, anche quando l\'app è chiusa o non in uso.\n\nFunzione: App di Servizio di Trasporto\n\nRaccoglie i dati di posizione del conducente per tracciare la posizione in tempo reale. Quando l\'app è chiusa, utilizzerà la posizione in background per ottenere la posizione in tempo reale del conducente, permettendogli di ricevere nuove richieste di corsa.\n\nConsenti a questa app di accedere \"Sempre\"';

  @override
  String get preferences => 'Preferenze';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get selectCurrency => 'Seleziona Valuta';

  @override
  String get preferenceMsg =>
      'Puoi modificare queste impostazioni in seguito nell\'app.';

  @override
  String get obTitle1 => 'La tua città, il tuo percorso';

  @override
  String get obMsg1 =>
      'Imposta la destinazione a Medellín e trova un autista urbano in pochi minuti.';

  @override
  String get obTitle2 => 'Negozia la tariffa';

  @override
  String get obMsg2 =>
      'Offri a step di 500 COP e concorda un prezzo urbano equo.';

  @override
  String get obTitle3 => 'Viaggia sicuro';

  @override
  String get obMsg3 =>
      'Autisti verificati, pagamenti flessibili e la fiducia XISTI: Facile e Sicuro.';

  @override
  String get login => 'Accedi';

  @override
  String get welcomeTo => 'Benvenuto su';

  @override
  String get loginYourAccount => 'Accedi al tuo Account';

  @override
  String get contactNumber => 'Numero di Contatto';

  @override
  String get enterContactNumber => 'Inserisci il Numero di Contatto';

  @override
  String get sendOTP => 'Invia OTP';

  @override
  String get orLoginWith => 'Oppure accedi con';

  @override
  String get loginWithTouchID => 'Accedi con Touch ID/Face ID';

  @override
  String get enableTouchID => 'Abilita Touch ID/Face ID';

  @override
  String get bioMetricsDisableMsg =>
      'Puoi attivare questa opzione dopo aver effettuato l\'accesso all\'applicazione.';

  @override
  String get bioMetricsPopupMsg =>
      'Scansiona la tua impronta digitale o il tuo viso per autenticarti.';

  @override
  String get authenticationRequired => 'Autenticazione richiesta!';

  @override
  String get verifyIdentity => 'Verifica identità';

  @override
  String get noThanks => 'No, grazie';

  @override
  String get enterOTPSendNumber => 'Inserisci l\'OTP inviato al tuo numero';

  @override
  String get enterOTPVerifyAccount =>
      'inserisci l\'OTP per verificare il tuo account.';

  @override
  String get continueTxt => 'Continua';

  @override
  String get resend => 'Reinvia';

  @override
  String get startYour => 'Inizia il tuo';

  @override
  String get journeyWithUs => 'viaggio con noi';

  @override
  String get registerAndStart => 'Registrati e inizia ad esplorare!';

  @override
  String get haveNotCode => 'Non hai ricevuto un codice?';

  @override
  String get ifNotGetCode =>
      'Se non hai ricevuto un codice, prova una delle opzioni seguenti.';

  @override
  String get retryIn => 'Riprova tra';

  @override
  String get changeNumber => 'Cambia Numero';

  @override
  String get sendAgain => 'Invia di Nuovo';

  @override
  String get resendOtpSuccessMsg =>
      'Un nuovo OTP è stato inviato al tuo numero di telefono registrato';

  @override
  String get resendOtpWhatsappSuccessMsg => 'OTP reinviato tramite WhatsApp.';

  @override
  String get otpSentViaWhatsappHint =>
      'Possiamo inviare il codice anche tramite WhatsApp.';

  @override
  String get yourName => 'Il tuo Nome';

  @override
  String get failed => 'Échoué';

  @override
  String get email => 'Indirizzo email';

  @override
  String get referralCode => 'Codice Referral';

  @override
  String get enterYourName => 'Inserisci il tuo Nome';

  @override
  String get enterValidFullName =>
      'Inserisci un nome valido usando solo lettere e spazi';

  @override
  String get enterEmailAddress => 'Inserisci l\'Indirizzo Email';

  @override
  String get invalidEmailAddress => 'Indirizzo Email non valido';

  @override
  String get byRegisterYouAgree => 'registrandoti accetti i nostri';

  @override
  String get termsCondition => 'Termini e Condizioni';

  @override
  String get privacyPolicy =>
      'Informativa sulla privacy e sul trattamento dei dati personali';

  @override
  String get platformConnectionNotice =>
      'Comprendo che si tratta di una piattaforma tecnologica che collega utenti e conducenti indipendenti, senza fornire servizi di trasporto né gestire veicoli.';

  @override
  String get driverIndependentNotice =>
      'Dichiaro di agire come conducente indipendente e che l\'uso della piattaforma non crea alcun rapporto di lavoro, subordinazione, rappresentanza commerciale o esclusività.';

  @override
  String get deliveryLegalNotice =>
      'Le consegne sono passaggi di pacchi gestiti tra utenti tramite la piattaforma. L\'app facilita solo il collegamento e non fornisce servizi di trasporto passeggeri o merci.';

  @override
  String get agreeAndContinue => 'Accetta e continua';

  @override
  String get marketingOptIn =>
      'Autorizzo a ricevere comunicazioni, novità e promozioni.';

  @override
  String get account => 'Account';

  @override
  String get driverMode => 'Modalità Conducente';

  @override
  String get passengerMode => 'Modalità Passeggero';

  @override
  String get rideHistory => 'Cronologia Corse';

  @override
  String get notification => 'Notifica';

  @override
  String get myWallet => 'Il mio Portafoglio';

  @override
  String get referHistory => 'Cronologia Referral';

  @override
  String get liveChat => 'Chat dal Vivo';

  @override
  String get liveTrackingBadge => 'In diretta';

  @override
  String get estimatedArrival => 'Arrivo stimato';

  @override
  String get myPreference => 'Le mie Preferenze';

  @override
  String get emergencyContact => 'Contatto di Emergenza';

  @override
  String get inviteFriend => 'Invita un Amico';

  @override
  String get reportIssue => 'Segnala Problema';

  @override
  String get help => 'Aiuto';

  @override
  String get manageAccount => 'Gestisci Account';

  @override
  String get agree => 'Accetta';

  @override
  String get pickUpLocation => 'Luogo di Partenza';

  @override
  String get dropLocation => 'Luogo di Destinazione';

  @override
  String get cash => 'Contanti';

  @override
  String get card => 'Carta';

  @override
  String get wallet => 'Portafoglio';

  @override
  String get offerMyFare => 'Proponi la mia Tariffa';

  @override
  String get fetchingLocation => 'Recupero Posizione';

  @override
  String get stopPoint => 'Punto di Sosta';

  @override
  String get selectVehicle => 'Seleziona Veicolo';

  @override
  String get setRoute => 'Imposta Percorso';

  @override
  String get setLocationOnMap => 'Imposta Posizione dalla Mappa';

  @override
  String get confirmLocation => 'Conferma Posizione';

  @override
  String get searchLocation => 'Cerca Posizione';

  @override
  String get selectYourLocation => 'Seleziona la tua Posizione';

  @override
  String get selectLocation => 'Seleziona Posizione';

  @override
  String get comments => 'Commenti';

  @override
  String get writeYourComment => 'Scrivi il tuo commento';

  @override
  String get childSeatSafety => 'Seggiolino di Sicurezza per Bambini';

  @override
  String get handicapAccess => 'Accessibilità per Disabili';

  @override
  String get bookForOther => 'Prenota per Altri';

  @override
  String get selectContactNumber => 'Seleziona Numero di Contatto';

  @override
  String get stop => 'Ferma';

  @override
  String get km => 'Km';

  @override
  String get selectPickup => 'Seleziona Luogo di Partenza';

  @override
  String get selectDrop => 'Seleziona Luogo di Destinazione';

  @override
  String get selectStop => 'Seleziona Luogo di Sosta';

  @override
  String get offerAmount => 'Importo dell\'Offerta';

  @override
  String get enterFareValue => 'Inserisci il Valore della Tariffa';

  @override
  String offerFareMin(String amount) {
    return 'Devi pagare un minimo di $amount';
  }

  @override
  String offerFareMax(String amount) {
    return 'Puoi offrire un massimo di $amount';
  }

  @override
  String get scheduleRide => 'Pianifica una Corsa';

  @override
  String get autoAcceptDriverRide =>
      'Accetta automaticamente il conducente più vicino per la tua tariffa';

  @override
  String get findDrive => 'Trova un Conducente';

  @override
  String get recommendedFare => 'Tariffa consigliata';

  @override
  String get minFare => 'Tariffa min.';

  @override
  String get maxFare => 'Tariffa max.';

  @override
  String get fareEstimateDisclaimer =>
      'Stima in base a percorso, tempo e tariffa del veicolo.';

  @override
  String get recipientName => 'Nome del Destinatario';

  @override
  String get recipientNumber => 'Numero del Destinatario';

  @override
  String get parcelEstimatedPrice => 'Valore Stimato del Pacco';

  @override
  String get parcelNote => 'Nota sul Pacco';

  @override
  String get enterRecipientName => 'Inserisci il Nome del Destinatario';

  @override
  String get enterRecipientNumber => 'Inserisci il Numero del Destinatario';

  @override
  String get enterParcelEstimatedPrice =>
      'Inserisci il Valore Stimato del Pacco';

  @override
  String get enterParcelNote => 'Inserisci la Nota sul Pacco';

  @override
  String get systemSelected => 'Automatico';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get selectAppTheme => 'Seleziona Tema App';

  @override
  String get currentFare => 'Tariffa Attuale';

  @override
  String get cancelRide => 'Annulla Corsa';

  @override
  String get raiseFare => 'Aumenta Tariffa';

  @override
  String get myDetails => 'I miei Dettagli';

  @override
  String get camera => 'Fotocamera';

  @override
  String get gallery => 'Galleria';

  @override
  String get cropper => 'Ritaglia';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String kmAway(String km) {
    return '$km km di distanza';
  }

  @override
  String get noRecordFound => 'Spiacenti !!\nNessun Record Trovato';

  @override
  String get manageDistance => 'Gestisci Distanza';

  @override
  String get reset => 'Reimposta';

  @override
  String get apply => 'Applica';

  @override
  String get reject => 'Rifiuta';

  @override
  String get accept => 'Accetta';

  @override
  String get pleaseSelectADistance => 'Seleziona una distanza.';

  @override
  String get trackLocationInBackground => 'Traccia posizione in background';

  @override
  String changeRideFare(String name) {
    return '$name ha modificato la tariffa della corsa.';
  }

  @override
  String get emailAddress => 'Indirizzo Email';

  @override
  String permissionText1(String appName) {
    return 'Consenti a $appName di visualizzarsi sopra le altre app';
  }

  @override
  String permissionText2(String appName) {
    return 'Consenti a $appName di visualizzarsi sopra le altre app per ricevere richieste di corsa quando sei online.';
  }

  @override
  String get permissionText3 =>
      'Tocca Consenti e attiva il pulsante nella schermata Impostazioni.';

  @override
  String get permissionText4 =>
      'Imposta l\'icona di Accesso Rapido su attivo per vederla sopra le altre app';

  @override
  String get quickAccessIcon => 'Icona di Accesso Rapido';

  @override
  String get settingsPermission => 'Vai alle Impostazioni';

  @override
  String get yourDriverIsOnWay => 'Il tuo conducente è in arrivo';

  @override
  String get driverIsAtPickup => 'Il conducente è al punto di partenza';

  @override
  String get driverHeadingDestination => 'Conducente diretto alla destinazione';

  @override
  String get reachYourDestination => 'Raggiunta la destinazione';

  @override
  String get call => 'Chiama';

  @override
  String get shareOTP => 'Condividi OTP';

  @override
  String get proceedToPay => 'Procedi al pagamento';

  @override
  String get pay => 'Paga';

  @override
  String get payment => 'Pagamento';

  @override
  String get insufficientWalletBalance =>
      'Non puoi pagare la corsa con il Portafoglio perché il saldo è insufficiente.';

  @override
  String get onlinePayment => 'Pagamento Online';

  @override
  String get shareFeedBack => 'Condividi Feedback';

  @override
  String get writeYourFeedBack => 'Scrivi il tuo feedback';

  @override
  String get submit => 'Invia';

  @override
  String get giveFeedbackErrorMsg => 'Dai il tuo feedback!';

  @override
  String get rideDetail => 'Dettagli Corsa';

  @override
  String get downloadInvoice => 'Scarica Fattura';

  @override
  String get completed => 'Completato';

  @override
  String get pending => 'In attesa';

  @override
  String get cancelled => 'Annullato';

  @override
  String get accepted => 'Accettato';

  @override
  String get running => 'In corso';

  @override
  String get rideDateTime => 'Data e Ora della Corsa';

  @override
  String get paymentMethod => 'Metodo di Pagamento';

  @override
  String get paymentStatus => 'Stato del Pagamento';

  @override
  String get bookingId => 'ID Prenotazione';

  @override
  String get invoiceDetail => 'Dettagli Fattura';

  @override
  String get okay => 'Ok';

  @override
  String get vehicleInformation => 'Informazioni Veicolo';

  @override
  String get driverDetails => 'Dettagli Conducente';

  @override
  String get profileUpdateSuccessfully => 'Profilo aggiornato con successo.';

  @override
  String get txtToday => 'Oggi';

  @override
  String get txtUpcoming => 'Prossime';

  @override
  String get txtLast7Days => 'Ultimi 7 Giorni';

  @override
  String get txtThisMonth => 'Ultimi 30 Giorni';

  @override
  String get txtYear => 'Quest\'Anno';

  @override
  String get txtAll => 'Tutte';

  @override
  String get sortByDays => 'Ordina per Giorni';

  @override
  String get ongoing => 'In corso';

  @override
  String get itemDesc => 'Descrizione Articolo';

  @override
  String get courierDetail => 'Dettagli Corriere';

  @override
  String get courierDateTime => 'Data e Ora del Corriere';

  @override
  String get rideCompleteByAdminMsg => 'Corsa Completata dall\'Amministratore';

  @override
  String get rideCancelByAdminMsg => 'Corsa Annullata dall\'Amministratore';

  @override
  String get startRide => 'Inizia Corsa';

  @override
  String get collectAmount => 'Riscuoti Importo';

  @override
  String collectAmountMsg(String collectionAmount) {
    return 'Sei sicuro di aver riscosso $collectionAmount dal cliente?';
  }

  @override
  String get rideOTPVerifyMsg => 'Chiedi l\'OTP al Cliente e inseriscilo qui.';

  @override
  String get start => 'Inizia';

  @override
  String get collectPayment => 'Riscuoti Pagamento';

  @override
  String get rateUser => 'Valuta Utente';

  @override
  String get completeRide => 'Completa la corsa';

  @override
  String get errorMessageCommon =>
      'Qualcosa è andato storto. Riprova tra poco?';

  @override
  String get notifications => 'Notifiche';

  @override
  String get min => 'min';

  @override
  String get other => 'Altro';

  @override
  String get offerFare => 'Offri Tariffa';

  @override
  String get requiredMess => 'Per favore inserisci i dettagli richiesti.';

  @override
  String get cancel => 'Annulla';

  @override
  String get accountDelete => 'Elimina Account';

  @override
  String get accountDeleteDialogMsg =>
      'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get logout => 'Esci';

  @override
  String get logOutDialogMsg => 'Sei sicuro di voler uscire dal tuo account?';

  @override
  String get arrived => 'Arrivato';

  @override
  String get enterOtp => 'Inserisci OTP';

  @override
  String get numberOfToll => 'Numero di Pedaggi';

  @override
  String get tollAmount => 'Importo del Pedaggio';

  @override
  String get enterTollAmount => 'Inserisci l\'importo del pedaggio';

  @override
  String get enterNumberOfToll => 'Inserisci il numero di pedaggi';

  @override
  String get reviewUser => 'Valuta Utente';

  @override
  String get reviewUserMsg => 'Valuta l\'Utente da 1 a 5 Stelle';

  @override
  String get showMore => 'Altro';

  @override
  String get showLess => 'Meno';

  @override
  String get amount => 'Importo';

  @override
  String get claimed => 'Richiesto';

  @override
  String get rejected => 'Rifiutato';

  @override
  String get manageAddress => 'Gestisci Indirizzo';

  @override
  String get home => 'Casa';

  @override
  String get work => 'Lavoro';

  @override
  String get addressDeletedSuccessMsg => 'Indirizzo eliminato con successo';

  @override
  String get contactName => 'Nome Contatto';

  @override
  String get enterContactName => 'Inserisci il Nome del Contatto';

  @override
  String get sureToCancel => 'Sei sicuro di voler annullare la tua corsa?';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get rideCancel => 'Annulla Corsa';

  @override
  String get from => 'Da';

  @override
  String get at => 'A';

  @override
  String get currentBalance => 'Saldo Attuale';

  @override
  String get history => 'Cronologia';

  @override
  String get transfer => 'Trasferisci';

  @override
  String get topUp => 'Ricarica';

  @override
  String get cashOut => 'Preleva';

  @override
  String get all => 'Tutti';

  @override
  String get credit => 'Credito';

  @override
  String get debit => 'Debito';

  @override
  String get transactionNotFound => 'Transazione non trovata';

  @override
  String get success => 'Successo';

  @override
  String get successTransaction => 'Hai trasferito con successo';

  @override
  String get selectUser => 'Seleziona Utente';

  @override
  String get searchByContactOrEmail => 'Cerca per Contatto o Email';

  @override
  String get beneficial => 'Beneficiario';

  @override
  String get beneficialContactNumber => 'Numero di Contatto del Beneficiario';

  @override
  String get beneficialEmail => 'Email del Beneficiario';

  @override
  String get amountToTransfer => 'Importo da trasferire';

  @override
  String get enterAmount => 'Inserisci l\'Importo';

  @override
  String get youCantTransfer => 'Non puoi trasferire più di';

  @override
  String get invalidAmountMsg => 'Inserisci un importo valido';

  @override
  String get customer => 'Cliente';

  @override
  String get driver => 'Conducente';

  @override
  String get enterContactOrEmailToSearchPerson =>
      'Inserisci il numero di contatto o l\'email per cercare la persona.';

  @override
  String get proceedToAddMoney => 'Procedi ad aggiungere denaro';

  @override
  String get chooseAmount => 'Scegli Importo';

  @override
  String get walletMinTopupNotice =>
      'Ricarica minima 13.000 COP. Commissione XISTI 8% — margine equo per i conducenti.';

  @override
  String get pleaseEnterAmount => 'Inserisci o seleziona l\'importo.';

  @override
  String get walletAddSuccessful =>
      'Importo aggiunto al portafoglio con successo';

  @override
  String get invalidRequestCashOutAmountMsg =>
      'Non puoi richiedere un prelievo superiore al tuo saldo nel portafoglio';

  @override
  String get pleaseEnterRequestCashOutAmount =>
      'Inserisci l\'importo del prelievo richiesto';

  @override
  String get enterValidRequestCashOutAmount =>
      'Inserisci un importo di prelievo valido';

  @override
  String get cashOutSuccess => 'Richiesta di Prelievo effettuata con successo!';

  @override
  String get requestToCash => 'Richiedi prelievo';

  @override
  String get cashOutAmount => 'Importo del prelievo';

  @override
  String get newRequest => 'Nuova Richiesta';

  @override
  String get goBack => 'Torna Indietro';

  @override
  String get searchingForRideRequests => 'Ricerca richieste di corsa\n';

  @override
  String get yourOfferIsBeingReviewedByCustomer =>
      'La tua Offerta è in fase di\nRevisione da parte del Cliente';

  @override
  String distanceKm(String km) {
    return 'Distanza: $km km ';
  }

  @override
  String get reqRejectCustomer =>
      'La tua Richiesta è stata Rifiutata dal Cliente.';

  @override
  String get enterCancelReason => 'Inserisci il Motivo dell\'Annullamento';

  @override
  String get away => 'di distanza';

  @override
  String get otp => 'OTP';

  @override
  String get rideCompleted => 'Corsa Completata';

  @override
  String get rideCompletedMsg =>
      'La tua Corsa è stata Completata con successo.';

  @override
  String rideCancelBy(String name) {
    return 'Corsa Annullata da $name!';
  }

  @override
  String get rateDriver => 'Valuta Conducente';

  @override
  String get rideFare => 'Tariffa Corsa';

  @override
  String get totalPay => 'Totale da Pagare';

  @override
  String get referDiscount => 'Sconto Referral';

  @override
  String get inviteFriends => 'Invita Amici';

  @override
  String get shareInvite => 'Condividi Invito';

  @override
  String get referFriendAndGetBenefits => 'Invita un Amico e Ottieni Vantaggi';

  @override
  String get inviteFriendsMsg =>
      'Invita il tuo Amico con questo\nCodice Referral per Ottenere Più Vantaggi';

  @override
  String get use => 'Usa';

  @override
  String get referCodeGetDiscount => 'Codice Referral e ottieni uno Sconto';

  @override
  String get download => 'Scarica';

  @override
  String get emergencyContactNumber => 'Numero di Contatto di Emergenza';

  @override
  String get emergencyContactAddMsg =>
      'Puoi aggiungere un Numero di Contatto\ndi Emergenza dal tuo Profilo.';

  @override
  String get emergencyContactMsg =>
      'Puoi modificare il Numero di Contatto\ndi Emergenza dal tuo Profilo.';

  @override
  String get emergencyCall => 'Chiamata di Emergenza';

  @override
  String get addEmergencyContact => 'Aggiungi Contatto di Emergenza';

  @override
  String get manageVehicle => 'Gestisci Veicolo';

  @override
  String get addAddress => 'Aggiungi Indirizzo';

  @override
  String get editAddress => 'Modifica Indirizzo';

  @override
  String maxAddressMsg(int maxLimit) {
    return 'Puoi aggiungere al massimo $maxLimit indirizzi. Elimina quello precedente prima di aggiungerne uno nuovo';
  }

  @override
  String get saveAddress => 'Salva Indirizzo';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteAddress => 'Elimina Indirizzo?';

  @override
  String get deleteAddressDialogMsg =>
      'Sei sicuro di voler eliminare questo indirizzo?';

  @override
  String get noAnyAddressMsg =>
      'Non hai aggiunto nessun indirizzo. Aggiungi un indirizzo da usare durante la prenotazione di una corsa.';

  @override
  String get heatMap => 'Mappa di Calore';

  @override
  String get writeAMessageHere => 'Scrivi un messaggio qui';

  @override
  String get enterValidateNoTolls => 'Inserisci il numero valido di pedaggi';

  @override
  String get enterValidateTollCharge =>
      'Inserisci l\'importo valido del pedaggio';

  @override
  String get whatWouldYouLikeToChoose => 'Cosa vorresti scegliere?';

  @override
  String get downloading => 'Download in corso...';

  @override
  String get downloadingComplete => 'Download Completato';

  @override
  String get downloadingFailed => 'Download Fallito';

  @override
  String get pdfDownloadSuccessful => 'Download PDF Completato con Successo!';

  @override
  String get downloadCancelled => 'Download Fallito!';

  @override
  String get fillYourInformation => 'Inserisci le tue Informazioni';

  @override
  String driverRegisterMsg(String appName) {
    return 'Compila le tue informazioni personali per iniziare a guadagnare con $appName';
  }

  @override
  String get close => 'Chiudi';

  @override
  String get proceed => 'Procedi';

  @override
  String get manageInformation => 'Gestisci Informazioni';

  @override
  String get drivingLicence => 'Patente di Guida';

  @override
  String get addDocument => 'Aggiungi Documento';

  @override
  String get uploadImage => 'Carica Immagine';

  @override
  String get selectExpiryDateHere => 'Seleziona la data di scadenza qui...';

  @override
  String get uploadDocument => 'Carica Documento';

  @override
  String get updateDocument => 'Aggiorna Documento';

  @override
  String get selectDocument => 'Seleziona il documento';

  @override
  String get expiryDate => 'Data di Scadenza';

  @override
  String get selectExpiryDate => 'Seleziona Data di Scadenza';

  @override
  String get emptyDocument =>
      'Il documento non è richiesto per questo servizio';

  @override
  String get document => 'Documento';

  @override
  String get upload => 'Carica';

  @override
  String get add => 'Aggiungi';

  @override
  String get approved => 'Approvato';

  @override
  String get noDocument => 'Nessun Documento';

  @override
  String get expired => 'Scaduto';

  @override
  String get customerDetails => 'Dettagli Cliente';

  @override
  String get rideEstimation => 'Stima Corsa';

  @override
  String get customerName => 'Nome Cliente';

  @override
  String get customerNumber => 'Numero Cliente';

  @override
  String get confirm => 'Conferma';

  @override
  String get addCustomerDetails => 'Aggiungi Dettagli Cliente';

  @override
  String get bankDetails => 'Dettagli Bancari';

  @override
  String get updateBankDetailSuccessMsg =>
      'I tuoi dettagli bancari sono stati aggiornati con successo!';

  @override
  String get enterAccountNumber => 'Inserisci il Numero di Conto';

  @override
  String get accountNumber => 'Numero di Conto';

  @override
  String get enterAccountHolderName =>
      'Inserisci il Nome del Titolare del Conto';

  @override
  String get accountHolderName => 'Nome del Titolare del Conto';

  @override
  String get enterBankName => 'Inserisci il Nome della Banca';

  @override
  String get bankName => 'Nome della Banca';

  @override
  String get enterBankLocation => 'Inserisci la Sede della Banca';

  @override
  String get bankLocation => 'Sede della Banca';

  @override
  String get enterSwiftCode => 'Inserisci il Codice BIC/SWIFT';

  @override
  String get swiftCode => 'Codice BIC/SWIFT';

  @override
  String get feedback => 'Feedback';

  @override
  String get rating => 'Valutazione';

  @override
  String get viewRide => 'Visualizza Corsa';

  @override
  String get addIssue => 'Aggiungi Problema';

  @override
  String get myReportedIssue => 'Il mio Problema Segnalato';

  @override
  String get faq => 'Domande Frequenti';

  @override
  String get chooseAnOrderWithIssue => 'Scegli un ordine con problema';

  @override
  String get reportGeneralIssue => 'Segnala Problema Generale';

  @override
  String get resolved => 'Risolto';

  @override
  String get unResolved => 'Non Risolto';

  @override
  String get general => 'Generale';

  @override
  String get issueNotFound => 'Problema Non Trovato';

  @override
  String get ticketId => 'ID Ticket';

  @override
  String get description => 'Descrizione';

  @override
  String get enterDescription => 'Inserisci la Descrizione';

  @override
  String get deleteImage => 'Elimina Immagine';

  @override
  String get deleteImageMsg => 'Sei sicuro di voler eliminare questa immagine?';

  @override
  String get rideId => 'ID Corsa';

  @override
  String get orderNotFound => 'Ordine Non Trovato';

  @override
  String uploadMinImagesMsg(int minIssueImageCount) {
    return 'Carica almeno $minIssueImageCount immagini.';
  }

  @override
  String get chat => 'Chat';

  @override
  String get submitIssue => 'Invia Problema';

  @override
  String get manufactureName => 'Nome Produttore';

  @override
  String get modelName => 'Nome Modello';

  @override
  String get vehiclePlateNumber => 'Numero di Targa';

  @override
  String get vehicleColor => 'Colore del Veicolo';

  @override
  String get vehicleYear => 'Anno del Veicolo';

  @override
  String get selectVehicleType => 'Seleziona Tipo di Veicolo';

  @override
  String get selectVehicleYear => 'Seleziona Anno del Veicolo';

  @override
  String get selectItem => 'Seleziona Elemento';

  @override
  String get enterManufactureName => 'Inserisci il Nome del Produttore';

  @override
  String get enterModelName => 'Inserisci il Nome del Modello';

  @override
  String get enterVehiclePlateNumber => 'Inserisci il Numero di Targa';

  @override
  String get enterVehicleColor => 'Inserisci il Colore del Veicolo';

  @override
  String get done => 'Fatto';

  @override
  String get uploadVehicleImage => 'Carica Immagine del Veicolo';

  @override
  String get imageUploaded => 'Immagine Caricata';

  @override
  String get vehicleDetailsUploadedSuccessfully =>
      'Dettagli Veicolo Caricati con Successo.';

  @override
  String get cancellationReason => 'Motivo dell\'Annullamento';

  @override
  String get trackRide => 'Traccia Corsa';

  @override
  String get verificationPending => 'Verifica in Attesa';

  @override
  String get driverBlock => 'Conducente Bloccato dall\'Amministratore';

  @override
  String get pendingMessage =>
      'Grazie per la tua candidatura. Ti notificheremo via email una volta esaminati i tuoi documenti.';

  @override
  String get driverRejectedByAdmin =>
      'Conducente rifiutato dall\'amministratore';

  @override
  String get goToHome => 'Vai alla Home';

  @override
  String get hailModule => 'Vai online per accettare la corsa';

  @override
  String get noteFromCustomer => 'Nota dal Cliente';

  @override
  String get yourAdditionalNote => 'La tua nota aggiuntiva';

  @override
  String get passengerName => 'Nome Passeggero';

  @override
  String get submitOTP => 'Invia OTP';

  @override
  String get percentage => 'Percentuale';

  @override
  String get cancelBy => 'Annullato da';

  @override
  String get schedule => 'Pianifica';

  @override
  String get expiryDateValidation =>
      'La data di scadenza sembra essere nel passato. Per favore controllala.';

  @override
  String get selectScheduleDate => 'Seleziona Data di Pianificazione';

  @override
  String get googleMapsLimitMessage =>
      'Hai raggiunto il limite giornaliero di utilizzo di Google Maps. Per favore riprova domani.';

  @override
  String get usageLimitReached => 'Limite di Utilizzo Raggiunto';

  @override
  String get processing => 'Elaborazione';

  @override
  String get faceVerification => 'Verifica del Volto';

  @override
  String get positionFaceInCircle => 'Posiziona il tuo viso nel cerchio';

  @override
  String get blinkEyesNow => 'Ora sbatti le palpebre';

  @override
  String get verificationSuccessful => 'Verifica Riuscita!';

  @override
  String get onlyOneFaceAllowed => 'È consentito solo un volto';

  @override
  String get cameraPermissionRequired => 'Autorizzazione Fotocamera Richiesta';

  @override
  String get cameraPermissionMessage =>
      'Questa app ha bisogno dell\'accesso alla fotocamera per verificare la tua identità. Abilitalo nelle impostazioni.';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get noCamerasFound => 'Nessuna fotocamera trovata.';

  @override
  String get failedToCaptureImagePleaseTryAgain =>
      'Acquisizione immagine fallita. Per favore riprova.';

  @override
  String get loading => 'Caricamento';

  @override
  String get pleaseAddProfileImage =>
      'Aggiungi la tua foto del profilo per continuare.';

  @override
  String get profilePictureUpload => 'Carica foto profilo';

  @override
  String get profilePictureUploadMsg =>
      'La foto del profilo è mancante, carica una foto del profilo per procedere con gli ordini.';

  @override
  String get platformCommission => 'Commissione piattaforma (8%)';

  @override
  String get vatOnCommission => 'IVA sulla commissione (19%)';

  @override
  String get totalDeduction => 'Totale detrazioni';

  @override
  String get netDriverEarnings => 'Netto autista';

  @override
  String get invalidMobileNumberCo =>
      'Inserisci un numero mobile valido di 10 cifre';

  @override
  String get invalidVehiclePlate =>
      'Inserisci una targa valida (5-8 caratteri alfanumerici)';

  @override
  String get vehicleCarroEconomico => 'Auto economica';

  @override
  String get vehicleCarroElectrico => 'Auto elettrica';

  @override
  String get vehicleCarroComodo => 'Auto confort';

  @override
  String get vehicleMotoBajo => 'Moto a bassa cilindrata';

  @override
  String get vehicleMotoAlto => 'Moto ad alta cilindrata';

  @override
  String get vehicleMoto => 'Moto';

  @override
  String get vehicleCarro => 'Auto';

  @override
  String get vehicleBicicleta => 'Bicicletta';

  @override
  String get vehicleTrip => 'Viaggio';

  @override
  String get whereToBuy => 'Dove acquistare';

  @override
  String get whereToDeliver => 'Dove consegnare';

  @override
  String get selectWhereToBuy => 'Seleziona dove acquistare';

  @override
  String get selectWhereToDeliver => 'Seleziona dove consegnare';

  @override
  String get whatToBuyHint => 'Cosa devono comprare?';

  @override
  String get priceCapHint => 'Limite di prezzo (COP)';

  @override
  String get indicateWhatToBuy => 'Indica cosa vuoi che acquistino';

  @override
  String get indicatePriceCap => 'Indica il limite di prezzo';

  @override
  String get vehicleForErrand => 'Veicolo per l\'encargo';

  @override
  String get transportMediumForDelivery => 'Mezzo di trasporto per la consegna';

  @override
  String get transportMediumForErrand => 'Mezzo di trasporto per l\'encargo';

  @override
  String get rideCachedReconnecting =>
      'Viaggio in cache — riconnessione quando c\'è segnale.';

  @override
  String get uploadVehiclePhotosThreeAngles =>
      'Carica le foto frontale, laterale e posteriore del veicolo.';

  @override
  String get noCountryFound => 'Nessun paese trovato';

  @override
  String get backToShop => 'Torna al negozio';

  @override
  String get emergencyContactName => 'Nome del contatto di emergenza';

  @override
  String get sendOtpViaWhatsapp => 'Invia tramite WhatsApp';

  @override
  String regionConfirmTitle(Object city) {
    return 'Sei a $city?';
  }

  @override
  String regionConfirmCountryMessage(Object country, Object currency) {
    return 'Abbiamo rilevato $country. Aggiorneremo la valuta ($currency) e le tariffe minime.';
  }

  @override
  String regionConfirmCityMessage(Object city, Object country) {
    return 'Aggiorneremo le zone della mappa per $city, $country.';
  }

  @override
  String get tecnomecanicaExpiryOptional =>
      'Revisione tecnica — scadenza (opzionale)';

  @override
  String get photoFront => 'Foto frontale';

  @override
  String get photoSide => 'Foto laterale';

  @override
  String get photoRear => 'Foto posteriore';

  @override
  String get operateAsTaxiOptional => 'Opero come taxi (opzionale)';

  @override
  String get alsoTransportPassengers => 'Vuoi anche trasportare passeggeri?';

  @override
  String get passengerTransportToggleOn =>
      'Potrai ricevere richieste di passeggeri.';

  @override
  String get passengerTransportToggleOff =>
      'Riceverai solo richieste di consegna.';

  @override
  String get googleSignInUnavailable =>
      'Google Sign-In non è disponibile su questo dispositivo.';

  @override
  String get invalidNationalId => 'Documento non valido (6-10 cifre)';

  @override
  String get descriptionOrComments => 'Descrizione o commenti';

  @override
  String get phoneAtPickup => 'Telefono al ritiro';

  @override
  String get storeOrPurchasePlaceHint =>
      'Negozio o luogo d\'acquisto (es. Éxito Calle 80)';

  @override
  String get errandDescription => 'Descrizione del trasporto';

  @override
  String get proposedValueRequired => 'Valore proposto (obbligatorio)';

  @override
  String get selectSharedRideDate => 'Seleziona data del viaggio';

  @override
  String get contributionPerPersonCop => 'Contributo a persona (COP)';

  @override
  String get scheduledRequest => 'Richiesta programmata';

  @override
  String get availableSharedRides => 'Corse condivise disponibili';

  @override
  String get noSharedRidesAvailable =>
      'Non ci sono corse condivise su questo percorso. Prova un\'altra data o pubblica la tua.';

  @override
  String get contributionToAgree => 'Contributo da concordare';

  @override
  String get seatsAvailableSuffix => 'posto/i';

  @override
  String get joinRide => 'Unisciti al viaggio';

  @override
  String get createSharedRide => 'Crea corsa condivisa';

  @override
  String get availableSeats => 'Posti disponibili';

  @override
  String get publishRide => 'Pubblica viaggio';

  @override
  String get whereToPickupPackage => 'Dove ritirare il pacco';

  @override
  String get whereToDeliverYourAddress => 'Dove consegnare (il tuo indirizzo)';

  @override
  String get searchSharedRides => 'Cerca corse condivise';

  @override
  String get sendHaulingRequest => 'Invia richiesta di trasporto';

  @override
  String get goOnlineToPublishSharedRides =>
      'Vai online per pubblicare corse condivise';

  @override
  String get sharedRide => 'Corsa condivisa';

  @override
  String get serviceModeTrips => 'Viaggi';

  @override
  String get serviceModeDelivery => 'Consegna';

  @override
  String get serviceModeShare => 'Condividi';

  @override
  String get serviceModeErrand => 'Commissione';

  @override
  String get serviceModeHauling => 'Traslochi';

  @override
  String get serviceModeShareSubtitle => 'Paese a paese o paese a città';

  @override
  String get serviceModeErrandSubtitle => 'Acquisti in negozio per te';

  @override
  String get serviceModeHaulingSubtitle => 'Traslochi e carichi pesanti';

  @override
  String get sharedRideTownToCity => 'Paese a città';

  @override
  String get sharedRideTownToTown => 'Paese a paese';

  @override
  String get sharedRideOriginTownHint => 'Comune di partenza';

  @override
  String get sharedRideDestinationCityHint => 'Città di destinazione';

  @override
  String get sharedRideDestinationTownHint => 'Comune di destinazione';

  @override
  String get sharedRideDestinationRequiredCity =>
      'Inserisci la città di destinazione';

  @override
  String get sharedRideDestinationRequiredTown =>
      'Inserisci il comune di destinazione';

  @override
  String get sharedRideContributionNotice =>
      'Il contributo è volontario e concordato tra passeggeri e conducente.';

  @override
  String get sharedRideMatchNotifyWhenAvailable =>
      'Ti avviseremo quando ci saranno corse su questo percorso.';

  @override
  String get perPersonSuffix => 'a persona';

  @override
  String get estimatedServiceDate => 'Data stimata del servizio';

  @override
  String get errandPickup => 'Ritiri';

  @override
  String get errandPurchases => 'Acquisti';

  @override
  String get haulTruck => 'Camion';

  @override
  String get haulCage => 'Camion gabbia';

  @override
  String get haulMotocarguero => 'Motocarro';

  @override
  String get chipErrand => 'Commissione';

  @override
  String get chipShare => 'Condividi';

  @override
  String get chipHauling => 'Traslochi';

  @override
  String get chipDelivery => 'Consegna';

  @override
  String get chipMotoraton => 'Motoratón';

  @override
  String get chipRide => 'Corsa';

  @override
  String get deliveryNotPassengerTransport =>
      'Consegna pacchi — non è trasporto passeggeri';

  @override
  String get genericErrorTryAgain => 'Si è verificato un errore. Riprova.';

  @override
  String get selectContributionAmount => 'Indica il contributo';

  @override
  String get selectSeatsAvailable => 'Indica i posti disponibili';

  @override
  String get selectPickupLocationErrand => 'Seleziona il punto di ritiro';

  @override
  String get selectDropLocationErrand => 'Seleziona il punto di consegna';

  @override
  String get taxiYellowTag => 'Giallo';

  @override
  String get passengerModeBannerUser =>
      'Modalità utente — richiedi viaggi e consegne';

  @override
  String get passengerModeBannerDriver =>
      'Modalità conducente — guadagna con il tuo veicolo';

  @override
  String get searchCardSubtitleTransport => 'Dove vuoi andare?';

  @override
  String get searchCardSubtitleDelivery => 'Invia un pacco';

  @override
  String get searchCardSubtitleErrand => 'Richiedi un acquisto in negozio';

  @override
  String get packageWeightHint => 'Peso (kg)';

  @override
  String get enterPackageWeight => 'Inserisci il peso in kg';

  @override
  String get packageHeightHint => 'Altezza (cm)';

  @override
  String get packageWidthHint => 'Larghezza (cm)';

  @override
  String get packageLengthHint => 'Lunghezza (cm)';

  @override
  String get packageDetailsTitle => 'Dettagli del pacco';

  @override
  String get packageSizeLabel => 'Dimensioni del pacco';

  @override
  String get packageLabel => 'Pacco';

  @override
  String get driverOfflineActionSaved =>
      'Nessun segnale: azione salvata. Verrà inviata alla riconnessione.';

  @override
  String get serviceModeTransportCardSubtitle => 'Il tuo percorso, a modo tuo';

  @override
  String get serviceModeDeliveryCardSubtitle => 'Consegne urbane';

  @override
  String repeatActivityTitle(Object serviceLabel) {
    return 'Ripeti $serviceLabel';
  }

  @override
  String get paymentBancolombia => 'Bancolombia';

  @override
  String get paymentNequi => 'Nequi';

  @override
  String get paymentDaviplata => 'Daviplata';

  @override
  String get taxiLabel => 'Taxi';

  @override
  String get homeHeroSubtitleTransport => 'Viaggio urbano · Facile e sicuro';

  @override
  String get homeHeroSubtitleDelivery => 'Pacchi e consegne a Medellín';

  @override
  String get homeHeroSubtitleErrand => 'Compriamo e consegniamo per te';

  @override
  String get homeHeroSubtitleExpreso => 'Viaggi intercomunali';

  @override
  String get modeBannerTransport =>
      'Viaggi · Negozia la tariffa a step di 500 COP';

  @override
  String get modeBannerDelivery =>
      'Consegna urbana · Pagamento a destinazione disponibile';

  @override
  String get modeBannerErrand => 'Commissioni · Compriamo e consegniamo';

  @override
  String get modeBannerExpreso => 'Condividi · Percorsi intercomunali';

  @override
  String get offlineShowingLastKnownLocation =>
      'Nessun segnale — mostra l\'ultima posizione nota.';

  @override
  String get deliveryOnlyServiceHint =>
      'Riceverai richieste di consegna per il mezzo selezionato sopra.';

  @override
  String get passengerTransportToggleHint =>
      'Le consegne dipendono dal veicolo registrato. Attiva solo se trasporti anche passeggeri.';

  @override
  String get demoProductSubtitle =>
      'Facile e sicuro — mobilità urbana con negoziazione tariffa e wallet prepagato.';

  @override
  String get demoProductBody =>
      'Richiedi corse, proponi la tariffa e connettiti con conducenti verificati a Medellín.';

  @override
  String get demoProductSupport => 'Supporto XISTI';

  @override
  String get securityWarningTitle => 'Avviso di sicurezza';

  @override
  String get securityWarningOfficial =>
      'XISTI è gestito ufficialmente dal team xistiapp.com.';

  @override
  String get securityWarningBody =>
      'Se qualcuno tenta di venderti una copia di questa app o chiede pagamenti fuori dai canali ufficiali, segnalalo a soporte@xistiapp.com. Scarica XISTI solo da Google Play, App Store o link pubblicati su xistiapp.com.';

  @override
  String get understood => 'Capito';

  @override
  String get sessionExpired => 'La sessione è scaduta. Accedi di nuovo.';

  @override
  String get userNotFound => 'Utente non trovato';

  @override
  String get emailAlreadyRegistered => 'Questa email è già registrata';

  @override
  String get phoneAlreadyRegistered =>
      'Questo numero di telefono è già registrato';
}
