import 'package:geolocator/geolocator.dart';
import 'package:google_maps/models/endereco.model.dart';
import 'package:location/location.dart';

class LocalizacaoBloc {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<Map<String, dynamic>> enderecoCoordenadas(latitude, longitude) async {
    try {
      List<Placemark> p =
          await geolocator.placemarkFromCoordinates(latitude, longitude);

      Placemark place = p[0];

      EnderecoModel _enderecoModel = new EnderecoModel(
        cep: place.postalCode,
        rua: place.thoroughfare,
        pais: place.country,
        bairro: place.subLocality,
        numero: place.subThoroughfare,
        cidade: place.subAdministrativeArea,
        estado: place.administrativeArea,
      );

      return _enderecoModel.toJson();
    } catch (e) {
      print(e);
    }
  }
}
