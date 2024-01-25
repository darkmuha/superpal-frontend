import 'dart:io';
import 'dart:ui';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:superpal/components/common_layout.dart';
import 'package:superpal/helpers/constants.dart';
import 'dart:convert';

import '../components/custom_radio_button.dart';
import '../helpers/api_requests.dart';
import '../helpers/api_service.dart';
import '../helpers/enums.dart';
import '../helpers/image_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;

  DateTime? lastImageUploadTime;
  String? profilePicture;
  String? firstName;
  String? age;
  String? rank;
  String? workoutStreak;
  Difficulty? selectedDifficulty;
  Intensity? selectedIntensity;
  Difficulty? _tempSelectedDifficulty;
  Intensity? _tempSelectedIntensity;
  File? imageFile;
  List<Map<String, dynamic>> progressImages = [];
  Cloudinary cloudinary = AppConstants.cloudinary;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
    _loadUserDetailsAndUserData();
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

  bool _canUploadImage() {
    if (lastImageUploadTime == null) {
      return true;
    }

    final daysDifference =
        DateTime.now().difference(lastImageUploadTime!).inDays;
    return daysDifference >= 7;
  }

  Future<void> _uploadImage() async {
    if (_canUploadImage()) {
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
          final refreshToken = await storage.read(key: 'refresh');

          final Map<String, dynamic> decodedToken =
              JwtDecoder.decode(refreshToken!);
          final customerID = decodedToken['customer_id'];

          await apiRequests.postProgress(customerID!, imageUrl!);
          await apiRequests.getProgress(customerID);
          final progressDataString = await storage.read(key: 'progress');
          final progressData = jsonDecode(progressDataString!);

          progressImages = List<Map<String, dynamic>>.from(
            progressData.map((item) => {
                  'id': item['id'],
                  'progress_image': item['progress_image'],
                  'taken_at': item['taken_at'],
                  'user': item['user'],
                }),
          );

          if (progressImages.isNotEmpty) {
            print(progressImages.last['taken_at']);
            final firstItemTime =
                DateTime.parse(progressImages.last['taken_at']);
            lastImageUploadTime = firstItemTime;
          }
          setState(() {});
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    } else {
      print('You can only add an image every 7 days');
    }
  }

  Difficulty _parseDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'beginner':
        return Difficulty.beginner;
      case 'intermediate':
        return Difficulty.intermediate;
      case 'pro':
        return Difficulty.pro;
      default:
        print('Error: Unknown difficulty value: $value');
        return Difficulty.beginner;
    }
  }

  Intensity _parseIntensity(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return Intensity.low;
      case 'medium':
        return Intensity.medium;
      case 'high':
        return Intensity.high;
      default:
        print('Error: Unknown intensity value: $value');
        return Intensity.low;
    }
  }

  Future<void> _loadUserDetailsAndUserData() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      final Map<String, dynamic> decodedToken =
          JwtDecoder.decode(refreshToken!);
      final customerID = decodedToken['customer_id'];

      await apiRequests.getUserDetails(customerID);

      final userDetails = await storage.read(key: 'userDetails');

      if (userDetails != null) {
        Map<String, dynamic> userDetailsJson = jsonDecode(userDetails);

        profilePicture = userDetailsJson['profile_picture'];
        firstName = userDetailsJson['first_name'];
        age = userDetailsJson['age'].toString();
        rank = userDetailsJson['rank_named'];
        workoutStreak = userDetailsJson['workout_streak'].toString();
        selectedDifficulty =
            _parseDifficulty(userDetailsJson['workout_difficulty']);
        selectedIntensity =
            _parseIntensity(userDetailsJson['workout_intensity']);

        await apiRequests.getProgress(customerID);
        final progressDataString = await storage.read(key: 'progress');
        final progressData = jsonDecode(progressDataString!);

        progressImages = List<Map<String, dynamic>>.from(
          progressData.map((item) => {
                'id': item['id'],
                'progress_image': item['progress_image'],
                'taken_at': item['taken_at'],
                'user': item['user'],
              }),
        );

        if (progressImages.isNotEmpty) {
          final firstItemTime = DateTime.parse(progressImages.last['taken_at']);
          lastImageUploadTime = firstItemTime;
        }
        setState(() {});
      } else {
        print('User details not found.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 5,
      body: buildBody(context),
      imageUrl: "assets/images/account_background_cropped.png",
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.9 * MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 5),
            const Text(
              'PROFILE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: profilePicture != null
                      ? ClipOval(
                          child: Image.network(
                            profilePicture!,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41.0),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      firstName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      age ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      rank ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      workoutStreak ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'DIFFICULTY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedDifficulty == Difficulty.beginner,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = Difficulty.beginner;
                    _tempSelectedIntensity = null;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedDifficulty = Difficulty.beginner;
                      });
                    }, confirmationText: 'Difficulty to Beginner');
                  },
                  text: 'BEGINNER',
                ),
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedDifficulty == Difficulty.intermediate,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = Difficulty.intermediate;
                    _tempSelectedIntensity = null;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedDifficulty = Difficulty.intermediate;
                      });
                    }, confirmationText: 'Difficulty to Intermediate');
                  },
                  text: 'INTERMEDIATE',
                ),
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedDifficulty == Difficulty.pro,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = Difficulty.pro;
                    _tempSelectedIntensity = null;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedDifficulty = Difficulty.pro;
                      });
                    }, confirmationText: 'Difficulty to Pro');
                  },
                  text: 'PRO',
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'INTENSITY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedIntensity == Intensity.low,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = null;
                    _tempSelectedIntensity = Intensity.low;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedIntensity = Intensity.low;
                      });
                    }, confirmationText: 'Intensity to Low');
                  },
                  text: 'LOW',
                ),
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedIntensity == Intensity.medium,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = null;
                    _tempSelectedIntensity = Intensity.medium;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedIntensity = Intensity.medium;
                      });
                    }, confirmationText: 'Intensity to Medium');
                  },
                  text: 'MEDIUM',
                ),
                CustomRadioButton(
                  fontSize: 16,
                  highlight: 2,
                  selected: selectedIntensity == Intensity.high,
                  onChanged: (isSelected) {
                    _tempSelectedDifficulty = null;
                    _tempSelectedIntensity = Intensity.high;
                    _showConfirmationDialog(() {
                      setState(() {
                        selectedIntensity = Intensity.high;
                      });
                    }, confirmationText: 'Intensity to High');
                  },
                  text: 'HIGH',
                ),
              ],
            ),
            const SizedBox(height: 4.7),
            GestureDetector(
              onTap: () {
                Get.toNamed('/workout_requests');
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(41.0),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Text(
                      'SEE WORKOUT REQUESTS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'See all of your workout requests with your SuperPals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2.1),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41.0),
                color: Colors.black.withOpacity(0.7),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Text(
                    'MY WEEKLY PROGRESS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Track your progress from month to month click to add new image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  ...List.generate(
                    progressImages.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: GestureDetector(
                          onTap: () {
                            _showImageOverlay(
                                progressImages[index]['progress_image']);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SizedBox(
                              width: 136,
                              height: 149,
                              child: Image.network(
                                progressImages[index]['progress_image'],
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        _showAddImageOverlay();
                      },
                      child: Container(
                        width: 136,
                        height: 149,
                        decoration: BoxDecoration(
                          color: const Color(0xFF707070).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/add.svg',
                            color: const Color(0xFF6C7177),
                            width: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddImageOverlay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () async {
                await _pickImage();
                Get.back();
                await _uploadImage();
              },
              child: Container(
                width: 305,
                height: 334,
                decoration: BoxDecoration(
                  color: const Color(0xFF707070).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    SvgPicture.asset(
                      'assets/icons/add.svg',
                      color: const Color(0xFF6C7177).withOpacity(0.5),
                      width: 74,
                    ),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 30),
                      child: Text(
                        'Add an image \nfrom your Gallery',
                        style: TextStyle(
                          color: const Color(0xFF6C7177).withOpacity(0.8),
                          fontSize: 24,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageOverlay(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(Function()? onConfirmed,
      {String confirmationText = '', bool isUpdatingIntensity = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: Text(
              'Are you sure you want to change the ${confirmationText ?? ''}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final refreshToken = await storage.read(key: 'refresh');
                final Map<String, dynamic> decodedToken =
                    JwtDecoder.decode(refreshToken!);
                final customerID = decodedToken['customer_id'];

                await apiRequests.updateCustomer(
                  customerID: customerID,
                  intensity: isUpdatingIntensity
                      ? _tempSelectedIntensity?.value
                      : null,
                  difficulty: isUpdatingIntensity
                      ? null
                      : _tempSelectedDifficulty?.value,
                );

                onConfirmed?.call();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
