import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/background_builder.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../components/custom_radio_button.dart';
import '../components/custom_text_field.dart';
import '../helpers/api_requests.dart';
import '../helpers/api_service.dart';
import '../helpers/constants.dart';
import '../helpers/enums.dart';
import '../helpers/image_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnteredNewPasswordController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  Sex? selectedSex;
  String? selectedGym;
  String? currentLocation;
  File? imageFile;
  String? imageUrl;
  String? publicImageId;
  String? customerId;

  List<String> nearbyGyms = [];

  final cloudinary = AppConstants.cloudinary;

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    reEnteredNewPasswordController.dispose();
    weightController.dispose();
    heightController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
    _getUserDetails();
    _getLocationsAndGymsAndUserDetails();
  }

  bool _areAllFieldsFilled() {
    return usernameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        reEnteredNewPasswordController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        selectedSex != null &&
        selectedGym != null &&
        imageFile != null;
  }

  List<String> _getEmptyFields() {
    List<String> emptyFields = [];

    if (firstNameController.text.isEmpty) emptyFields.add("First Name");
    if (lastNameController.text.isEmpty) emptyFields.add("Last Name");
    if (oldPasswordController.text.isEmpty) emptyFields.add("Email");
    if (newPasswordController.text.isEmpty) emptyFields.add("Email");
    if (reEnteredNewPasswordController.text.isEmpty) {
      emptyFields.add("Password");
    }
    if (weightController.text.isEmpty) emptyFields.add("Weight");
    if (heightController.text.isEmpty) emptyFields.add("Height");
    if (selectedSex == null) emptyFields.add("Sex");
    if (selectedGym == null) emptyFields.add("Gym");
    if (imageFile == null) emptyFields.add("Profile Picture");

    return emptyFields;
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImageUtils.pickImage();
      if (pickedImage == null) return;
      final compressedImage = await ImageUtils.compressImage(pickedImage);

      setState(() {
        imageFile = compressedImage;
      });
    } catch (e) {
      print('Failed to pick or compress image: $e');
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (imageFile == null) {
        print('Image file is null. Please select an image.');
        return;
      }

      final response = await ImageUtils.uploadImage(
        cloudinary: cloudinary,
        imageFile: imageFile!,
      );

      if (response != null) {
        setState(() {
          imageUrl = response;
        });
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<void> _deleteImage() async {
    try {
      await ImageUtils.deleteImage(
        cloudinary: cloudinary,
        publicImageId: publicImageId,
      );
    } catch (error) {
      print('Error deleting image: $error');
    }
  }

  Sex _parseSex(String value) {
    switch (value.toLowerCase()) {
      case 'male':
        return Sex.male;
      case 'medium':
        return Sex.female;
      default:
        print('Error: Unknown sex value: $value');
        return Sex.male;
    }
  }

  Future<void> _getLocationsAndGymsAndUserDetails() async {
    await _requestLocationPermission();
    await _getLocation();
  }

  Future<void> _getUserDetails() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      final Map<String, dynamic> decodedToken =
          JwtDecoder.decode(refreshToken!);
      customerId = decodedToken['customer_id'];

      await apiRequests.getUserDetails(customerId!);

      final userDetails = await storage.read(key: 'userDetails');

      if (userDetails != null) {
        Map<String, dynamic> userDetailsJson = jsonDecode(userDetails);

        setState(() {
          imageUrl = userDetailsJson['profile_picture'];
          usernameController.text = userDetailsJson['user']['username'];
          firstNameController.text = userDetailsJson['first_name'];
          lastNameController.text = userDetailsJson['last_name'];
          selectedSex = _parseSex(userDetailsJson['sex']);
          weightController.text = userDetailsJson['weight'];
          heightController.text = userDetailsJson['height'];
          selectedGym = userDetailsJson['current_gym'];
        });
      } else {
        print('User details not found.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
  }

  Future<void> _getLocation() async {
    try {
      var status = await Permission.location.status;

      if (status == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placeMarks = await GeocodingPlatform.instance
            .placemarkFromCoordinates(position.latitude, position.longitude);

        if (placeMarks.isNotEmpty) {
          String cityName = placeMarks.first.locality ?? '';
          String country = placeMarks.first.country ?? '';

          await _fetchGymsInCity(cityName, AppConstants.googleApiKey);

          setState(() {
            currentLocation = '$cityName, $country';
          });
        }
      } else {
        print("Location permission denied");
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _fetchGymsInCity(String cityName, String apiKey) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';

    final response = await http.get(
      Uri.parse('$baseUrl?query=gym+in+$cityName&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      List<String> nearbyGyms = [];

      if (selectedGym != null) {
        nearbyGyms.insert(0, selectedGym!);
      }

      for (var result in results) {
        if (selectedGym != null && selectedGym == result['name']) {
          continue;
        }
        nearbyGyms.add(result['name']);
      }

      setState(() {
        this.nearbyGyms = nearbyGyms;
      });
    } else {
      throw Exception('Failed to fetch gyms in the city');
    }
  }

  void _dismissLoadingDialog() {
    Get.back();
  }

  Future<void> _updateCustomer() async {
    _showLoadingDialog();

    bool isAnyPasswordFilled = oldPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty ||
        reEnteredNewPasswordController.text.isNotEmpty;

    bool areAllPasswordsFilled = oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        reEnteredNewPasswordController.text.isNotEmpty;

    if (isAnyPasswordFilled && !areAllPasswordsFilled) {
      _dismissLoadingDialog();
      _showErrorDialog(
          "Please fill in all password fields or leave them all empty.");
      return;
    }

    await _uploadImage();

    try {
      final userData = {
        "user": {
          "old_password": oldPasswordController.text ?? '',
          "new_password": newPasswordController.text ?? '',
          "retype_new_password": reEnteredNewPasswordController.text ?? '',
          "username": usernameController.text
        },
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "sex": selectedSex?.value,
        "profile_picture": imageUrl,
        "weight": double.parse(weightController.text),
        "height": double.parse(heightController.text),
        "current_gym": selectedGym ?? "",
        "current_location": currentLocation ?? "City, Country",
      };

      final response = await http.put(
        Uri.parse('${AppConstants.apiUrl}/customers/$customerId/'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('User Update Successful');
        _dismissLoadingDialog();
        Get.offAllNamed('/account');
      } else {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage = errorResponse['detail'] ?? 'Updating user failed';
        await _deleteImage();
        _dismissLoadingDialog();
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      await _deleteImage();
      _dismissLoadingDialog();
      print('Error during updating user: $e');
    } finally {
      _dismissLoadingDialog();
    }
  }

  void _showErrorDialog(String errorMessage) {
    String detailMessage = '';
    try {
      Map<String, dynamic> errorData = json.decode(errorMessage);
      detailMessage = errorData['detail'] ?? '';
    } catch (e) {
      detailMessage = errorMessage;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(detailMessage),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundBuilder(
              imageUrl: "assets/images/barbell_cropped.png",
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                showAccountButton: false,
              ),
            ),
            Center(
              child: SizedBox(
                width: 0.9 * MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 90),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: imageFile != null
                                      ? ClipOval(
                                          child: Image.file(
                                            imageFile!,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : imageUrl != null
                                          ? ClipOval(
                                              child: Image.network(
                                                imageUrl!,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : null,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  icon: (imageFile != null || imageUrl != null)
                                      ? Container()
                                      : SvgPicture.asset(
                                          "assets/icons/camera.svg",
                                          width: 30,
                                          color: const Color(0xFF8B8B8B),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: firstNameController,
                                  hintText: "FIRST NAME",
                                  fontSize: 15,
                                ),
                                CustomTextField(
                                  controller: lastNameController,
                                  hintText: "LAST NAME",
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomRadioButton(
                            selected: selectedSex == Sex.male,
                            onChanged: (isSelected) {
                              setState(() {
                                selectedSex = isSelected! ? Sex.male : null;
                              });
                            },
                            svgAssetPath: "assets/icons/male.svg",
                            text: 'MALE',
                          ),
                          const SizedBox(width: 55),
                          CustomRadioButton(
                            selected: selectedSex == Sex.female,
                            onChanged: (isSelected) {
                              setState(() {
                                selectedSex = isSelected! ? Sex.female : null;
                              });
                            },
                            svgAssetPath: "assets/icons/female.svg",
                            text: 'FEMALE',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: usernameController,
                      hintText: "USERNAME",
                      fontSize: 15,
                    ),
                    CustomTextField(
                      controller: oldPasswordController,
                      hintText: "OLD PASSWORD",
                      fontSize: 15,
                      obscureText: true,
                    ),
                    CustomTextField(
                      controller: newPasswordController,
                      hintText: "NEW PASSWORD",
                      fontSize: 15,
                      obscureText: true,
                    ),
                    CustomTextField(
                      controller: reEnteredNewPasswordController,
                      hintText: "RE-ENTERED NEW PASSWORD",
                      fontSize: 15,
                      obscureText: true,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Password should include Min 8 Character, and 1 number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: CustomTextField(
                            controller: weightController,
                            hintText: "WEIGHT",
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(width: 65),
                        IntrinsicWidth(
                          child: CustomTextField(
                            controller: heightController,
                            hintText: "HEIGHT",
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'SELECT THE GYM YOU GO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: nearbyGyms.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 28),
                              child: CustomRadioButton(
                                selected: selectedGym == nearbyGyms[index],
                                onChanged: (isSelected) {
                                  setState(() {
                                    selectedGym =
                                        isSelected! ? nearbyGyms[index] : null;
                                  });
                                },
                                text: nearbyGyms[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    CustomButton(
                      onTap: () {
                        _updateCustomer();
                      },
                      buttonText: 'UPDATE',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
