import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../components/background_builder.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../components/custom_radio_button.dart';
import '../components/custom_text_field.dart';
import '../helpers/constants.dart';
import '../helpers/enums.dart';
import '../helpers/image_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  Sex? selectedSex;
  Difficulty? selectedDifficulty;
  Intensity? selectedIntensity;
  String? selectedGym;
  String? currentLocation;
  File? imageFile;
  String? imageUrl;
  String? publicImageId;

  List<String> nearbyGyms = [];

  final cloudinary = AppConstants.cloudinary;

  @override
  void initState() {
    super.initState();
    _getLocationAndGyms();
  }

  bool _areAllFieldsFilled() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        selectedSex != null &&
        selectedDifficulty != null &&
        selectedIntensity != null &&
        selectedGym != null &&
        imageFile != null;
  }

  List<String> _getEmptyFields() {
    List<String> emptyFields = [];

    if (firstNameController.text.isEmpty) emptyFields.add("First Name");
    if (lastNameController.text.isEmpty) emptyFields.add("Last Name");
    if (emailController.text.isEmpty) emptyFields.add("Email");
    if (passwordController.text.isEmpty) emptyFields.add("Password");
    if (weightController.text.isEmpty) emptyFields.add("Weight");
    if (heightController.text.isEmpty) emptyFields.add("Height");
    if (ageController.text.isEmpty) emptyFields.add("Age");
    if (selectedSex == null) emptyFields.add("Sex");
    if (selectedDifficulty == null) emptyFields.add("Difficulty");
    if (selectedIntensity == null) emptyFields.add("Intensity");
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
    if (_areAllFieldsFilled()) {
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
    } else {
      print('Please fill in all required fields before uploading the image.');
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

  Future<void> _getLocationAndGyms() async {
    await _requestLocationPermission();
    await _getLocation();
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

      for (var result in results) {
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

  Future<void> _register() async {
    _showLoadingDialog();

    List<String> emptyFields = _getEmptyFields();

    if (emptyFields.isNotEmpty) {
      String errorMessage =
          "Please fill in the following fields:\n${emptyFields.join(', ')}";
      _dismissLoadingDialog();
      _showErrorDialog(errorMessage);

      return;
    }

    await _uploadImage();

    try {
      final userData = {
        "user": {
          "email": emailController.text,
          "username": "${firstNameController.text}${lastNameController.text}",
          "password": passwordController.text,
        },
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "sex": selectedSex?.value,
        "profile_picture": imageUrl,
        "weight": double.parse(weightController.text),
        "height": double.parse(heightController.text),
        "age": int.parse(ageController.text),
        "workout_selected": null,
        "workout_streak": 0,
        "workout_intensity": selectedIntensity?.value,
        "workout_difficulty": selectedDifficulty?.value,
        "rank": 1,
        "current_gym": selectedGym ?? "",
        "current_location": currentLocation ?? "City, Country",
        "is_admin": "False",
      };

      final response = await http.post(
        Uri.parse('${AppConstants.apiUrl}/authentication/register/'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('Registration successful');
        _dismissLoadingDialog();
        Get.offAllNamed('/login');
      } else {
        Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage = errorResponse['detail'] ?? 'Registration failed';
        await _deleteImage();
        _dismissLoadingDialog();
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      await _deleteImage();
      _dismissLoadingDialog();
      print('Error during registration: $e');
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
                Navigator.of(context).pop();
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
                    const SizedBox(height: 100),
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
                                      : null,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  icon: imageFile != null
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
                    const SizedBox(height: 40),
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
                    CustomTextField(
                      controller: emailController,
                      hintText: "EMAIL",
                      fontSize: 15,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: passwordController,
                      hintText: "PASSWORD",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicWidth(
                          child: CustomTextField(
                            controller: weightController,
                            hintText: "WEIGHT",
                            fontSize: 19,
                          ),
                        ),
                        IntrinsicWidth(
                          child: CustomTextField(
                            controller: heightController,
                            hintText: "HEIGHT",
                            fontSize: 19,
                          ),
                        ),
                        IntrinsicWidth(
                          child: CustomTextField(
                            controller: ageController,
                            hintText: "AGE",
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    const Text(
                      'SELECT YOUR DIFFICULTY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRadioButton(
                          selected: selectedDifficulty == Difficulty.beginner,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedDifficulty =
                                  isSelected! ? Difficulty.beginner : null;
                            });
                          },
                          text: 'BEGINNER',
                        ),
                        CustomRadioButton(
                          selected:
                              selectedDifficulty == Difficulty.intermediate,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedDifficulty =
                                  isSelected! ? Difficulty.intermediate : null;
                            });
                          },
                          text: 'INTERMEDIATE',
                        ),
                        CustomRadioButton(
                          selected: selectedDifficulty == Difficulty.pro,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedDifficulty =
                                  isSelected! ? Difficulty.pro : null;
                            });
                          },
                          text: 'PRO',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SELECT YOUR INTENSITY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRadioButton(
                          selected: selectedIntensity == Intensity.low,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedIntensity =
                                  isSelected! ? Intensity.low : null;
                            });
                          },
                          text: 'LOW',
                        ),
                        CustomRadioButton(
                          selected: selectedIntensity == Intensity.medium,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedIntensity =
                                  isSelected! ? Intensity.medium : null;
                            });
                          },
                          text: 'MEDIUM',
                        ),
                        CustomRadioButton(
                          selected: selectedIntensity == Intensity.high,
                          onChanged: (isSelected) {
                            setState(() {
                              selectedIntensity =
                                  isSelected! ? Intensity.high : null;
                            });
                          },
                          text: 'HIGH',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SELECT THE GYM YOU GO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 60,
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
                        _register();
                      },
                      buttonText: 'JOIN',
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
