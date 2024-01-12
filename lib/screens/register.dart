import 'dart:convert';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

import '../components/background_builder.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../components/custom_radio_button.dart';
import '../components/custom_text_field.dart';
import '../helpers/constants.dart';
import '../helpers/enums.dart';

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
  String? selectedGym;
  Intensity? selectedIntensity;
  String? currentLocation;
  File? imageFile;
  String? imageUrl;
  String? publicImageId;

  List<String> nearbyGyms = [];

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '894995559279246',
    apiSecret: 'CK9axl5nMdjHfVV_o6XAOpxzerU',
    cloudName: 'decb8gydy',
  );

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

  Future<void> _pickImage() async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;
      final imageTemp = File(imageFile.path);
      setState(() => this.imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> _compressImage(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync());

    final resizedImage = img.copyResize(image!, width: 400);

    final compressedImage = img.encodeJpg(resizedImage!, quality: 90);

    final compressedImageFile = File('${imageFile.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedImage);

    return compressedImageFile;
  }

  Future<void> _uploadImage() async {
    if (_areAllFieldsFilled()) {
      try {
        if (imageFile == null) {
          print('Image file is null. Please select an image.');
          return;
        }
        final compressedImageFile = await _compressImage(imageFile!);

        final response = await cloudinary.unsignedUpload(
          file: imageFile!.path,
          uploadPreset: 'superpal',
          fileBytes: compressedImageFile.readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          progressCallback: (count, total) {
            print('Uploading image with progress: $count/$total');
          },
        );

        if (response.isSuccessful) {
          print('Get your image from: ${response.secureUrl}');
          setState(() {
            imageUrl = response.secureUrl;
            publicImageId = response.publicId;
          });
        } else {
          print('Error uploading image. Please check Cloudinary setup.');
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
      if (imageUrl == null || imageUrl!.isEmpty) {
        print('Image URL is empty. Cannot delete.');
        return;
      }

      final response = await cloudinary.destroy(
        publicImageId,
        resourceType: CloudinaryResourceType.image,
        invalidate: false,
      );

      if (response.isSuccessful) {
        print('Image deleted successfully');
        setState(() {
          imageUrl = null;
          publicImageId = null;
        });
      } else {
        print('Error deleting image. Please check Cloudinary setup.');
      }
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

  Future<void> _register() async {
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
        Get.offAllNamed('/');
      } else {
        await _deleteImage();
        print('Registration failed: ${response.body}');
      }
    } catch (e) {
      await _deleteImage();
      print('Error during registration: $e');
    }
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
