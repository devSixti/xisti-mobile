// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'XISTI';

  @override
  String get tagline => 'Fácil e Seguro';

  @override
  String get splashScreenMsg =>
      'Fácil e Seguro — negocie sua tarifa em Medellín.';

  @override
  String get year => 'ano';

  @override
  String get years => 'anos';

  @override
  String get month => 'mês';

  @override
  String get months => 'meses';

  @override
  String get week => 'semana';

  @override
  String get weeks => 'semanas';

  @override
  String get day => 'dia';

  @override
  String get days => 'dias';

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
  String get justNow => 'agora mesmo';

  @override
  String get ago => 'atrás';

  @override
  String get serverError => 'Erro no servidor';

  @override
  String get connectionLost => 'Conexão perdida';

  @override
  String get ok => 'Ok';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get serverErrorMessage =>
      'Parece haver um problema\ncom nosso servidor. Por favor, tente novamente mais tarde.';

  @override
  String get internetConnLostMessage =>
      'Não é possível conectar à internet.\nVerifique sua conexão e tente novamente.';

  @override
  String get apiErrorCancelMsg =>
      'A solicitação ao servidor da API foi cancelada';

  @override
  String get apiErrorConnectTimeoutMsg =>
      'Tempo limite de conexão com o servidor da API';

  @override
  String get apiErrorOtherMsg =>
      'Você está offline. Verifique sua conexão com a internet.';

  @override
  String get apiErrorReceiveTimeoutMsg =>
      'Tempo limite de recebimento na conexão com o servidor da API';

  @override
  String get apiErrorResponseMsg => 'Código de status inválido recebido';

  @override
  String get apiErrorSendTimeoutMsg =>
      'Tempo limite de envio na conexão com o servidor da API';

  @override
  String get apiErrorUnexpectedErrorMsg => 'Ocorreu um erro inesperado';

  @override
  String get apiErrorCommunicationMsg =>
      'Ocorreu um erro ao comunicar com o servidor com StatusCode';

  @override
  String get newUpdateAvailable => 'Nova atualização disponível!';

  @override
  String get newUpdateMsg =>
      'Por favor, atualize o aplicativo na loja para continuar.';

  @override
  String get update => 'Atualizar';

  @override
  String get locationMessageTitle => 'Divulgação';

  @override
  String get locationMessage =>
      'Este aplicativo coleta dados de localização para permitir o recebimento de novas corridas de táxi, mesmo quando o aplicativo está fechado ou não está em uso.\n\nRecurso: Aplicativo de Serviço de Transporte\n\nColeta dados de localização do motorista para rastrear a localização em tempo real. Quando o aplicativo está fechado, usará localização em segundo plano para obter a posição em tempo real do motorista, permitindo receber novas solicitações de corrida.\n\nPermita que este aplicativo acesse \"Sempre\"';

  @override
  String get preferences => 'Preferências';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get selectCurrency => 'Selecionar Moeda';

  @override
  String get preferenceMsg =>
      'Você pode alterar essas configurações mais tarde no aplicativo.';

  @override
  String get obTitle1 => 'Sua cidade, sua rota';

  @override
  String get obMsg1 =>
      'Defina seu destino em Medellín e encontre um motorista urbano em minutos.';

  @override
  String get obTitle2 => 'Negocie sua tarifa';

  @override
  String get obMsg2 =>
      'Ofereça em passos de 500 COP e combine um preço justo de mobilidade urbana.';

  @override
  String get obTitle3 => 'Viaje com confiança';

  @override
  String get obMsg3 =>
      'Motoristas verificados, pagamentos flexíveis e a confiança XISTI: Fácil e Seguro.';

  @override
  String get login => 'Entrar';

  @override
  String get welcomeTo => 'Bem-vindo ao';

  @override
  String get loginYourAccount => 'Entre na sua conta';

  @override
  String get contactNumber => 'Número de Contato';

  @override
  String get enterContactNumber => 'Digite o Número de Contato';

  @override
  String get sendOTP => 'Enviar OTP';

  @override
  String get orLoginWith => 'Ou entre com';

  @override
  String get loginWithTouchID => 'Entrar com Touch ID/Face ID';

  @override
  String get enableTouchID => 'Ativar Touch ID/Face ID';

  @override
  String get bioMetricsDisableMsg =>
      'Você pode ativar esta opção após fazer login no aplicativo.';

  @override
  String get bioMetricsPopupMsg =>
      'Escaneie sua impressão digital ou rosto para autenticar.';

  @override
  String get authenticationRequired => 'Autenticação necessária!';

  @override
  String get verifyIdentity => 'Verificar identidade';

  @override
  String get noThanks => 'Não, obrigado';

  @override
  String get enterOTPSendNumber => 'Digite o OTP enviado para seu número';

  @override
  String get enterOTPVerifyAccount => 'digite o OTP para verificar sua conta.';

  @override
  String get continueTxt => 'Continuar';

  @override
  String get resend => 'Reenviar';

  @override
  String get startYour => 'Comece sua';

  @override
  String get journeyWithUs => 'jornada conosco';

  @override
  String get registerAndStart => 'Registre-se e comece a explorar!';

  @override
  String get haveNotCode => 'Não recebeu um código?';

  @override
  String get ifNotGetCode =>
      'Se você não recebeu um código, tente uma das opções abaixo.';

  @override
  String get retryIn => 'Tentar em';

  @override
  String get changeNumber => 'Alterar Número';

  @override
  String get sendAgain => 'Enviar Novamente';

  @override
  String get resendOtpSuccessMsg =>
      'Um novo OTP foi enviado para seu número de telefone registrado';

  @override
  String get resendOtpWhatsappSuccessMsg =>
      'Enviamos um novo código pelo WhatsApp';

  @override
  String get otpSentViaWhatsappHint =>
      'Se sua operadora bloquear SMS, o código pode chegar pelo WhatsApp.';

  @override
  String get yourName => 'Seu Nome';

  @override
  String get failed => 'Fracassado';

  @override
  String get email => 'Endereço de e-mail';

  @override
  String get referralCode => 'Código de Indicação';

  @override
  String get enterYourName => 'Digite Seu Nome';

  @override
  String get enterValidFullName =>
      'Digite um nome válido usando apenas letras e espaços';

  @override
  String get enterEmailAddress => 'Digite o Endereço de E-mail';

  @override
  String get invalidEmailAddress => 'Endereço de E-mail Inválido';

  @override
  String get byRegisterYouAgree => 'ao se registrar você concorda com nossos';

  @override
  String get termsCondition => 'Termos e Condições';

  @override
  String get privacyPolicy => 'Privacy and Personal Data Processing Policy';

  @override
  String get platformConnectionNotice =>
      'I understand that XISTI is a technology platform connecting users with independent drivers, and does not provide transportation services or operate vehicles.';

  @override
  String get driverIndependentNotice =>
      'I declare that I act as an independent driver and that using the XISTI platform does not create any employment, subordination, commercial representation, or exclusivity relationship with XISTI.';

  @override
  String get deliveryLegalNotice =>
      'Deliveries are package handoffs managed between users through the platform. XISTI only facilitates the connection and does not provide passenger or freight transport services.';

  @override
  String get agreeAndContinue => 'Agree and continue';

  @override
  String get marketingOptIn =>
      'I authorize receiving communications, news and promotions from XISTI.';

  @override
  String get account => 'Conta';

  @override
  String get driverMode => 'Modo Motorista';

  @override
  String get passengerMode => 'Modo Passageiro';

  @override
  String get rideHistory => 'Histórico de Corridas';

  @override
  String get notification => 'Notificação';

  @override
  String get myWallet => 'Minha Carteira';

  @override
  String get referHistory => 'Histórico de Indicações';

  @override
  String get liveChat => 'Chat ao Vivo';

  @override
  String get myPreference => 'Minhas Preferências';

  @override
  String get emergencyContact => 'Contato de Emergência';

  @override
  String get inviteFriend => 'Convidar Amigo';

  @override
  String get reportIssue => 'Reportar Problema';

  @override
  String get help => 'Ajuda';

  @override
  String get manageAccount => 'Gerenciar Conta';

  @override
  String get agree => 'Concordar';

  @override
  String get pickUpLocation => 'Local de Partida';

  @override
  String get dropLocation => 'Local de Destino';

  @override
  String get cash => 'Dinheiro';

  @override
  String get card => 'Cartão';

  @override
  String get wallet => 'Carteira';

  @override
  String get offerMyFare => 'Oferecer Minha Tarifa';

  @override
  String get fetchingLocation => 'Obtendo Localização';

  @override
  String get stopPoint => 'Ponto de Parada';

  @override
  String get selectVehicle => 'Selecionar Veículo';

  @override
  String get setRoute => 'Definir Rota';

  @override
  String get setLocationOnMap => 'Definir Localização no Mapa';

  @override
  String get confirmLocation => 'Confirmar Localização';

  @override
  String get searchLocation => 'Pesquisar Localização';

  @override
  String get selectYourLocation => 'Selecione Sua Localização';

  @override
  String get selectLocation => 'Selecionar Localização';

  @override
  String get comments => 'Comentários';

  @override
  String get writeYourComment => 'Escreva seu comentário';

  @override
  String get childSeatSafety => 'Cadeirinha de Segurança Infantil';

  @override
  String get handicapAccess => 'Acessibilidade para Deficientes';

  @override
  String get bookForOther => 'Reservar para Outro';

  @override
  String get selectContactNumber => 'Selecionar Número de Contato';

  @override
  String get stop => 'Parar';

  @override
  String get km => 'Km';

  @override
  String get selectPickup => 'Selecionar Local de Partida';

  @override
  String get selectDrop => 'Selecionar Local de Destino';

  @override
  String get selectStop => 'Selecionar Local de Parada';

  @override
  String get offerAmount => 'Valor da Oferta';

  @override
  String get enterFareValue => 'Digite o Valor da Tarifa';

  @override
  String offerFareMin(String amount) {
    return 'Você deve pagar no mínimo $amount';
  }

  @override
  String offerFareMax(String amount) {
    return 'Você pode oferecer no máximo $amount';
  }

  @override
  String get scheduleRide => 'Agendar uma Corrida';

  @override
  String get autoAcceptDriverRide =>
      'Aceitar automaticamente o motorista mais próximo para sua tarifa';

  @override
  String get findDrive => 'Encontrar um Motorista';

  @override
  String get recommendedFare => 'Tarifa recomendada';

  @override
  String get minFare => 'Tarifa mín.';

  @override
  String get maxFare => 'Tarifa máx.';

  @override
  String get recipientName => 'Nome do Destinatário';

  @override
  String get recipientNumber => 'Número do Destinatário';

  @override
  String get parcelEstimatedPrice => 'Valor Estimado do Pacote';

  @override
  String get parcelNote => 'Observação do Pacote';

  @override
  String get enterRecipientName => 'Digite o Nome do Destinatário';

  @override
  String get enterRecipientNumber => 'Digite o Número do Destinatário';

  @override
  String get enterParcelEstimatedPrice => 'Digite o Valor Estimado do Pacote';

  @override
  String get enterParcelNote => 'Digite a Observação do Pacote';

  @override
  String get systemSelected => 'Automático';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get selectAppTheme => 'Selecionar Tema do Aplicativo';

  @override
  String get currentFare => 'Tarifa Atual';

  @override
  String get cancelRide => 'Cancelar Corrida';

  @override
  String get raiseFare => 'Aumentar Tarifa';

  @override
  String get myDetails => 'Meus Dados';

  @override
  String get camera => 'Câmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get cropper => 'Recortar';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String kmAway(String km) {
    return '$km km de distância';
  }

  @override
  String get noRecordFound => 'Desculpe !!\nNenhum Registro Encontrado';

  @override
  String get manageDistance => 'Gerenciar Distância';

  @override
  String get reset => 'Redefinir';

  @override
  String get apply => 'Aplicar';

  @override
  String get reject => 'Rejeitar';

  @override
  String get accept => 'Aceitar';

  @override
  String get pleaseSelectADistance => 'Por favor, selecione uma distância.';

  @override
  String get trackLocationInBackground =>
      'Rastrear localização em segundo plano';

  @override
  String changeRideFare(String name) {
    return '$name alterou a tarifa da corrida.';
  }

  @override
  String get emailAddress => 'Endereço de E-mail';

  @override
  String permissionText1(String appName) {
    return 'Permitir que $appName exiba sobre outros aplicativos';
  }

  @override
  String permissionText2(String appName) {
    return 'Permita que $appName exiba sobre outros aplicativos para receber solicitações de corrida quando estiver online.';
  }

  @override
  String get permissionText3 =>
      'Toque em Permitir e ative o botão na tela de Configurações.';

  @override
  String get permissionText4 =>
      'Ative o ícone de Acesso Rápido para vê-lo sobre outros aplicativos';

  @override
  String get quickAccessIcon => 'Ícone de Acesso Rápido';

  @override
  String get settingsPermission => 'Ir para Configurações';

  @override
  String get yourDriverIsOnWay => 'Seu motorista está a caminho';

  @override
  String get driverIsAtPickup => 'O motorista está no seu ponto de partida';

  @override
  String get driverHeadingDestination => 'Motorista a caminho do destino';

  @override
  String get reachYourDestination => 'Chegou ao destino';

  @override
  String get call => 'Ligar';

  @override
  String get shareOTP => 'Compartilhar OTP';

  @override
  String get proceedToPay => 'Prosseguir para pagamento';

  @override
  String get pay => 'Pagar';

  @override
  String get payment => 'Pagamento';

  @override
  String get insufficientWalletBalance =>
      'Você não pode pagar a corrida pela Carteira porque o saldo é insuficiente.';

  @override
  String get onlinePayment => 'Pagamento Online';

  @override
  String get shareFeedBack => 'Compartilhar Avaliação';

  @override
  String get writeYourFeedBack => 'Escreva sua avaliação';

  @override
  String get submit => 'Enviar';

  @override
  String get giveFeedbackErrorMsg => 'Dê sua avaliação!';

  @override
  String get rideDetail => 'Detalhes da Corrida';

  @override
  String get downloadInvoice => 'Baixar Fatura';

  @override
  String get completed => 'Concluído';

  @override
  String get pending => 'Pendente';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get accepted => 'Aceito';

  @override
  String get running => 'Em andamento';

  @override
  String get rideDateTime => 'Data e Hora da Corrida';

  @override
  String get paymentMethod => 'Método de Pagamento';

  @override
  String get paymentStatus => 'Status do Pagamento';

  @override
  String get bookingId => 'ID da Reserva';

  @override
  String get invoiceDetail => 'Detalhes da Fatura';

  @override
  String get okay => 'Ok';

  @override
  String get vehicleInformation => 'Informações do Veículo';

  @override
  String get driverDetails => 'Detalhes do Motorista';

  @override
  String get profileUpdateSuccessfully => 'Perfil atualizado com sucesso.';

  @override
  String get txtToday => 'Hoje';

  @override
  String get txtUpcoming => 'Próximas';

  @override
  String get txtLast7Days => 'Últimos 7 Dias';

  @override
  String get txtThisMonth => 'Últimos 30 Dias';

  @override
  String get txtYear => 'Este Ano';

  @override
  String get txtAll => 'Todos';

  @override
  String get sortByDays => 'Ordenar por Dias';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get itemDesc => 'Descrição do Item';

  @override
  String get courierDetail => 'Detalhes do Courier';

  @override
  String get courierDateTime => 'Data e Hora do Courier';

  @override
  String get rideCompleteByAdminMsg => 'Corrida Concluída pelo Administrador';

  @override
  String get rideCancelByAdminMsg => 'Corrida Cancelada pelo Administrador';

  @override
  String get startRide => 'Iniciar Corrida';

  @override
  String get collectAmount => 'Cobrar Valor';

  @override
  String collectAmountMsg(String collectionAmount) {
    return 'Tem certeza de que coletou $collectionAmount do cliente?';
  }

  @override
  String get rideOTPVerifyMsg =>
      'Por favor, obtenha o OTP do Cliente e insira-o aqui.';

  @override
  String get start => 'Iniciar';

  @override
  String get collectPayment => 'Cobrar Pagamento';

  @override
  String get rateUser => 'Avaliar Usuário';

  @override
  String get completeRide => 'Concluir a corrida';

  @override
  String get errorMessageCommon => 'Algo deu errado. Tente novamente em breve?';

  @override
  String get notifications => 'Notificações';

  @override
  String get min => 'min';

  @override
  String get other => 'Outro';

  @override
  String get offerFare => 'Oferecer Tarifa';

  @override
  String get requiredMess => 'Por favor, preencha os detalhes abaixo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get accountDelete => 'Excluir Conta';

  @override
  String get accountDeleteDialogMsg =>
      'Tem certeza de que deseja excluir sua conta?';

  @override
  String get logout => 'Sair';

  @override
  String get logOutDialogMsg => 'Tem certeza de que deseja sair da sua conta?';

  @override
  String get arrived => 'Chegou';

  @override
  String get enterOtp => 'Digite o OTP';

  @override
  String get numberOfToll => 'Número de Pedágios';

  @override
  String get tollAmount => 'Valor do Pedágio';

  @override
  String get enterTollAmount => 'Digite o valor do pedágio';

  @override
  String get enterNumberOfToll => 'Digite o número de pedágios';

  @override
  String get reviewUser => 'Avaliar Usuário';

  @override
  String get reviewUserMsg => 'Avalie o Usuário de 1 a 5 Estrelas';

  @override
  String get showMore => 'Mais';

  @override
  String get showLess => 'Menos';

  @override
  String get amount => 'Valor';

  @override
  String get claimed => 'Reivindicado';

  @override
  String get rejected => 'Rejeitado';

  @override
  String get manageAddress => 'Gerenciar Endereço';

  @override
  String get home => 'Casa';

  @override
  String get work => 'Trabalho';

  @override
  String get addressDeletedSuccessMsg => 'Endereço excluído com sucesso';

  @override
  String get contactName => 'Nome do Contato';

  @override
  String get enterContactName => 'Digite o Nome do Contato';

  @override
  String get sureToCancel => 'Tem certeza de que deseja cancelar sua corrida?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get rideCancel => 'Cancelar Corrida';

  @override
  String get from => 'De';

  @override
  String get at => 'Em';

  @override
  String get currentBalance => 'Saldo Atual';

  @override
  String get history => 'Histórico';

  @override
  String get transfer => 'Transferir';

  @override
  String get topUp => 'Recarregar';

  @override
  String get cashOut => 'Sacar';

  @override
  String get all => 'Todos';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get transactionNotFound => 'Transação não encontrada';

  @override
  String get success => 'Sucesso';

  @override
  String get successTransaction => 'Você transferiu com sucesso';

  @override
  String get selectUser => 'Selecionar Usuário';

  @override
  String get searchByContactOrEmail => 'Pesquisar por Contato ou E-mail';

  @override
  String get beneficial => 'Beneficiário';

  @override
  String get beneficialContactNumber => 'Número de Contato do Beneficiário';

  @override
  String get beneficialEmail => 'E-mail do Beneficiário';

  @override
  String get amountToTransfer => 'Valor a transferir';

  @override
  String get enterAmount => 'Digite o Valor';

  @override
  String get youCantTransfer => 'Você não pode transferir mais de';

  @override
  String get invalidAmountMsg => 'Digite um valor válido';

  @override
  String get customer => 'Cliente';

  @override
  String get driver => 'Motorista';

  @override
  String get enterContactOrEmailToSearchPerson =>
      'Por favor, insira o número de contato ou e-mail para buscar a pessoa.';

  @override
  String get proceedToAddMoney => 'Prosseguir para adicionar dinheiro';

  @override
  String get chooseAmount => 'Escolher Valor';

  @override
  String get walletMinTopupNotice =>
      'Minimum top-up COP 13,000. XISTI commission is 8% — fair margin for drivers.';

  @override
  String get pleaseEnterAmount => 'Por favor, insira ou selecione o valor.';

  @override
  String get walletAddSuccessful => 'Valor adicionado à carteira com sucesso';

  @override
  String get invalidRequestCashOutAmountMsg =>
      'Você não pode solicitar saque de valor maior que seu saldo na carteira';

  @override
  String get pleaseEnterRequestCashOutAmount =>
      'Por favor, insira o valor de saque solicitado';

  @override
  String get enterValidRequestCashOutAmount =>
      'Digite um valor de saque válido';

  @override
  String get cashOutSuccess => 'Solicitação de Saque realizada com sucesso!';

  @override
  String get requestToCash => 'Solicitar saque';

  @override
  String get cashOutAmount => 'Valor do saque';

  @override
  String get newRequest => 'Nova Solicitação';

  @override
  String get goBack => 'Voltar';

  @override
  String get searchingForRideRequests => 'Procurando solicitações de corrida\n';

  @override
  String get yourOfferIsBeingReviewedByCustomer =>
      'Sua Oferta está sendo\nAnalisada pelo Cliente';

  @override
  String distanceKm(String km) {
    return 'Distância: $km km ';
  }

  @override
  String get reqRejectCustomer => 'Sua Solicitação foi Rejeitada pelo Cliente.';

  @override
  String get enterCancelReason => 'Digite o Motivo do Cancelamento';

  @override
  String get away => 'de distância';

  @override
  String get otp => 'OTP';

  @override
  String get rideCompleted => 'Corrida Concluída';

  @override
  String get rideCompletedMsg => 'Sua Corrida foi Concluída com sucesso.';

  @override
  String rideCancelBy(String name) {
    return 'Corrida Cancelada por $name!';
  }

  @override
  String get rateDriver => 'Avaliar Motorista';

  @override
  String get rideFare => 'Tarifa da Corrida';

  @override
  String get totalPay => 'Total a Pagar';

  @override
  String get referDiscount => 'Desconto de Indicação';

  @override
  String get inviteFriends => 'Convidar Amigos';

  @override
  String get shareInvite => 'Compartilhar Convite';

  @override
  String get referFriendAndGetBenefits =>
      'Indique um Amigo e Obtenha Benefícios';

  @override
  String get inviteFriendsMsg =>
      'Convide seu Amigo com este\nCódigo de Indicação para Obter Mais Benefícios';

  @override
  String get use => 'Usar';

  @override
  String get referCodeGetDiscount =>
      'Código de Indicação e obtenha um Desconto';

  @override
  String get download => 'Baixar';

  @override
  String get emergencyContactNumber => 'Número de Contato de Emergência';

  @override
  String get emergencyContactAddMsg =>
      'Você pode adicionar um Número de Contato\nde Emergência no seu Perfil.';

  @override
  String get emergencyContactMsg =>
      'Você pode alterar o Número de Contato\nde Emergência no seu Perfil.';

  @override
  String get emergencyCall => 'Chamada de Emergência';

  @override
  String get addEmergencyContact => 'Adicionar Contato de Emergência';

  @override
  String get manageVehicle => 'Gerenciar Veículo';

  @override
  String get addAddress => 'Adicionar Endereço';

  @override
  String get editAddress => 'Editar Endereço';

  @override
  String maxAddressMsg(int maxLimit) {
    return 'Você pode adicionar no máximo $maxLimit endereços. Exclua o anterior antes de adicionar um novo';
  }

  @override
  String get saveAddress => 'Salvar Endereço';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteAddress => 'Excluir Endereço?';

  @override
  String get deleteAddressDialogMsg =>
      'Tem certeza de que deseja excluir este endereço?';

  @override
  String get noAnyAddressMsg =>
      'Você não adicionou nenhum endereço. Por favor, adicione um endereço para usar ao reservar uma corrida.';

  @override
  String get heatMap => 'Mapa de Calor';

  @override
  String get writeAMessageHere => 'Escreva uma mensagem aqui';

  @override
  String get enterValidateNoTolls => 'Digite o número válido de pedágios';

  @override
  String get enterValidateTollCharge => 'Digite o valor válido do pedágio';

  @override
  String get whatWouldYouLikeToChoose => 'O que você gostaria de escolher?';

  @override
  String get downloading => 'Baixando...';

  @override
  String get downloadingComplete => 'Download Concluído';

  @override
  String get downloadingFailed => 'Falha no Download';

  @override
  String get pdfDownloadSuccessful => 'Download do PDF realizado com sucesso!';

  @override
  String get downloadCancelled => 'Download Falhou!';

  @override
  String get fillYourInformation => 'Preencha Suas Informações';

  @override
  String driverRegisterMsg(String appName) {
    return 'Por favor, preencha suas informações pessoais para começar a ganhar com $appName';
  }

  @override
  String get close => 'Fechar';

  @override
  String get proceed => 'Prosseguir';

  @override
  String get manageInformation => 'Gerenciar Informações';

  @override
  String get drivingLicence => 'Carteira de Motorista';

  @override
  String get addDocument => 'Adicionar Documento';

  @override
  String get uploadImage => 'Enviar Imagem';

  @override
  String get selectExpiryDateHere => 'Selecione a data de validade aqui...';

  @override
  String get uploadDocument => 'Enviar Documento';

  @override
  String get updateDocument => 'Atualizar Documento';

  @override
  String get selectDocument => 'Por favor, selecione o documento';

  @override
  String get expiryDate => 'Data de Validade';

  @override
  String get selectExpiryDate => 'Selecionar Data de Validade';

  @override
  String get emptyDocument => 'O documento não é necessário para este serviço';

  @override
  String get document => 'Documento';

  @override
  String get upload => 'Enviar';

  @override
  String get add => 'Adicionar';

  @override
  String get approved => 'Aprovado';

  @override
  String get noDocument => 'Sem Documento';

  @override
  String get expired => 'Expirado';

  @override
  String get customerDetails => 'Detalhes do Cliente';

  @override
  String get rideEstimation => 'Estimativa da Corrida';

  @override
  String get customerName => 'Nome do Cliente';

  @override
  String get customerNumber => 'Número do Cliente';

  @override
  String get confirm => 'Confirmar';

  @override
  String get addCustomerDetails => 'Adicionar Detalhes do Cliente';

  @override
  String get bankDetails => 'Dados Bancários';

  @override
  String get updateBankDetailSuccessMsg =>
      'Seus dados bancários foram atualizados com sucesso!';

  @override
  String get enterAccountNumber => 'Digite o Número da Conta';

  @override
  String get accountNumber => 'Número da Conta';

  @override
  String get enterAccountHolderName => 'Digite o Nome do Titular da Conta';

  @override
  String get accountHolderName => 'Nome do Titular da Conta';

  @override
  String get enterBankName => 'Digite o Nome do Banco';

  @override
  String get bankName => 'Nome do Banco';

  @override
  String get enterBankLocation => 'Digite a Localização do Banco';

  @override
  String get bankLocation => 'Localização do Banco';

  @override
  String get enterSwiftCode => 'Digite o Código BIC/SWIFT';

  @override
  String get swiftCode => 'Código BIC/SWIFT';

  @override
  String get feedback => 'Avaliação';

  @override
  String get rating => 'Classificação';

  @override
  String get viewRide => 'Ver Corrida';

  @override
  String get addIssue => 'Adicionar Problema';

  @override
  String get myReportedIssue => 'Meu Problema Reportado';

  @override
  String get faq => 'Perguntas Frequentes';

  @override
  String get chooseAnOrderWithIssue => 'Escolha um pedido com problema';

  @override
  String get reportGeneralIssue => 'Reportar Problema Geral';

  @override
  String get resolved => 'Resolvido';

  @override
  String get unResolved => 'Não Resolvido';

  @override
  String get general => 'Geral';

  @override
  String get issueNotFound => 'Problema Não Encontrado';

  @override
  String get ticketId => 'ID do Ticket';

  @override
  String get description => 'Descrição';

  @override
  String get enterDescription => 'Digite a Descrição';

  @override
  String get deleteImage => 'Excluir Imagem';

  @override
  String get deleteImageMsg => 'Tem certeza de que deseja excluir esta imagem?';

  @override
  String get rideId => 'ID da Corrida';

  @override
  String get orderNotFound => 'Pedido Não Encontrado';

  @override
  String uploadMinImagesMsg(int minIssueImageCount) {
    return 'Por favor, envie pelo menos $minIssueImageCount imagens.';
  }

  @override
  String get chat => 'Chat';

  @override
  String get submitIssue => 'Enviar Problema';

  @override
  String get manufactureName => 'Nome do Fabricante';

  @override
  String get modelName => 'Nome do Modelo';

  @override
  String get vehiclePlateNumber => 'Número da Placa do Veículo';

  @override
  String get vehicleColor => 'Cor do Veículo';

  @override
  String get vehicleYear => 'Ano do Veículo';

  @override
  String get selectVehicleType => 'Selecionar Tipo de Veículo';

  @override
  String get selectVehicleYear => 'Selecionar Ano do Veículo';

  @override
  String get selectItem => 'Selecionar Item';

  @override
  String get enterManufactureName => 'Digite o Nome do Fabricante';

  @override
  String get enterModelName => 'Digite o Nome do Modelo';

  @override
  String get enterVehiclePlateNumber => 'Digite o Número da Placa do Veículo';

  @override
  String get enterVehicleColor => 'Digite a Cor do Veículo';

  @override
  String get done => 'Concluído';

  @override
  String get uploadVehicleImage => 'Enviar Imagem do Veículo';

  @override
  String get imageUploaded => 'Imagem Enviada';

  @override
  String get vehicleDetailsUploadedSuccessfully =>
      'Detalhes do Veículo Enviados com Sucesso.';

  @override
  String get cancellationReason => 'Motivo do Cancelamento';

  @override
  String get trackRide => 'Rastrear Corrida';

  @override
  String get verificationPending => 'Verificação Pendente';

  @override
  String get driverBlock => 'Motorista Bloqueado pelo Administrador';

  @override
  String get pendingMessage =>
      'Obrigado pela sua inscrição. Você será notificado por e-mail quando revisarmos seus documentos enviados.';

  @override
  String get driverRejectedByAdmin => 'Motorista rejeitado pelo administrador';

  @override
  String get goToHome => 'Ir para Início';

  @override
  String get hailModule => 'Por favor, fique online para aceitar a corrida';

  @override
  String get noteFromCustomer => 'Nota do Cliente';

  @override
  String get yourAdditionalNote => 'Sua nota adicional';

  @override
  String get passengerName => 'Nome do Passageiro';

  @override
  String get submitOTP => 'Enviar OTP';

  @override
  String get percentage => 'Porcentagem';

  @override
  String get cancelBy => 'Cancelado por';

  @override
  String get schedule => 'Agendar';

  @override
  String get expiryDateValidation =>
      'Parece que sua data de validade está no passado. Por favor, verifique.';

  @override
  String get selectScheduleDate => 'Selecionar Data de Agendamento';

  @override
  String get googleMapsLimitMessage =>
      'Você atingiu seu limite diário de uso do Google Maps. Por favor, tente novamente amanhã.';

  @override
  String get usageLimitReached => 'Limite de Uso Atingido';

  @override
  String get processing => 'Processando';

  @override
  String get faceVerification => 'Verificação Facial';

  @override
  String get positionFaceInCircle => 'Posicione seu rosto no círculo';

  @override
  String get blinkEyesNow => 'Agora pisque os olhos';

  @override
  String get verificationSuccessful => 'Verificação Bem-sucedida!';

  @override
  String get onlyOneFaceAllowed => 'Apenas um rosto é permitido';

  @override
  String get cameraPermissionRequired => 'Permissão de Câmera Necessária';

  @override
  String get cameraPermissionMessage =>
      'Este aplicativo precisa de acesso à câmera para verificar sua identidade. Por favor, ative nas configurações.';

  @override
  String get openSettings => 'Abrir Configurações';

  @override
  String get noCamerasFound => 'Nenhuma câmera encontrada.';

  @override
  String get failedToCaptureImagePleaseTryAgain =>
      'Falha ao capturar imagem. Por favor, tente novamente.';

  @override
  String get loading => 'Carregando';

  @override
  String get pleaseAddProfileImage =>
      'Por favor, adicione sua foto de perfil para continuar.';

  @override
  String get profilePictureUpload => 'Carregar foto de perfil';

  @override
  String get profilePictureUploadMsg =>
      'A foto de perfil está ausente, carregue uma foto de perfil para prosseguir com os pedidos.';

  @override
  String get platformCommission => 'Comissão da plataforma (8%)';

  @override
  String get vatOnCommission => 'IVA sobre comissão (19%)';

  @override
  String get totalDeduction => 'Total de descontos';

  @override
  String get netDriverEarnings => 'Líquido do motorista';

  @override
  String get invalidMobileNumberCo => 'Digite um celular válido com 10 dígitos';

  @override
  String get invalidVehiclePlate =>
      'Digite uma placa válida (5 a 8 caracteres alfanuméricos)';
}
