import 'package:cloudinary/cloudinary.dart';

class AppConstants {
  static const String apiUrl = 'http://192.168.0.32:8000';
  static const String googleApiKey = 'AIzaSyDcN6hGch_pwFXcSsZLCkIFrCSMDytB_N4';
  static final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: '894995559279246',
    apiSecret: 'CK9axl5nMdjHfVV_o6XAOpxzerU',
    cloudName: 'decb8gydy',
  );
}
