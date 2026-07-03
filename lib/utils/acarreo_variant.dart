import '../main.dart';

class AcarreoVariant {
  static const String motocarguero = 'motocarguero';
  static const String camion = 'camion';
  static const String jaula = 'jaula';

  static String label(String? variant) {
    switch (variant) {
      case camion:
        return languages.haulTruck;
      case jaula:
        return languages.haulCage;
      case motocarguero:
      default:
        return languages.haulMotocarguero;
    }
  }
}
