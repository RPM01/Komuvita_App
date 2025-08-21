import 'dart:io';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/widgets/common_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/custum_textfeild.dart';

import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../controller/adm_my_profile_controller.dart';
import '../../modal/adm_countries.dart';

class AdmMyProfileScreen extends StatefulWidget {
  const AdmMyProfileScreen({super.key});

  @override
  State<AdmMyProfileScreen> createState() => _AdmMyProfileScreenState();
}

class _AdmMyProfileScreenState extends State<AdmMyProfileScreen> {
  late ThemeData theme;
  MyProfileController controller = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  String role = '';
  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(

      context: context,
      builder: (context) => CupertinoActionSheet(

        actions: [
          CupertinoActionSheetAction(
            child: Text(
              gallery,
              style: theme.primaryTextTheme.displayLarge?.copyWith(),
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              camera,
              style: theme.primaryTextTheme.displayLarge?.copyWith(),
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(image: more, context: context, theme: theme,text:userProfileText ),

      bottomNavigationBar: PrimaryButton(
        text: updateText,
        onTap: () {
          //Get.toNamed(MyRoute.bankDashboardScreen);
          if (controller.formKey.currentState?.validate() ??
              false) {

            Get.back();
          } else {
            // Form is not valid, auto-validate the form
            controller.formKey.currentState?.validate();
          }

        },
      ),
      body:  Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        _image == null
                            ? const CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(userImg),
                        )
                            : CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_image!),
                          // backgroundImage: FileImage(
                          //     File(_image,))
                        ),
                        Positioned(
                            right: -16,
                            bottom: 0,
                            child: SizedBox(
                                height: 46,
                                width: 46,
                                child: IconButton(
                                  onPressed: () {
                                    showOptions();
                                  },
                                  icon: SvgPicture.asset(edit),
                                )))
                      ],
                    ),
                  ),
                ),
                25.height,
                Text(
                  fullName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.height,
                CustomTextField(
                  textInputAction: TextInputAction.next,
                  //textEditingController: controller.passwordController.value,
                  hintText: fullName,
                  textEditingController: controller.nameController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return controller.validateName(value);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                20.height,
                Text(
                  email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.height,
                CustomTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(mail,
                        colorFilter: ColorFilter.mode(
                            Get.isDarkMode ? admWhiteColor : admTextColor,
                            BlendMode.srcIn),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  hintText: email,
                  textEditingController: controller.emailController,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return controller.validateEmail(value);
                  },
                ),
                20.height,
                Text(
                  phoneNumber,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.height,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Get.isDarkMode ? admDarkBorderColor : lightGreyColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      8.width,
                      Obx(
                            () => InkWell(
                          onTap: () {
                            showCountryDialog(context);
                          },
                          child: Flag.fromString(
                            controller.selectedCountryCode.value.code,
                            height: 25,
                            width: 35,
                            borderRadius: 5,
                          ),
                        ),
                      ),

                      InkWell(
                          onTap: (){
                            showCountryDialog(context);
                          },
                          child: Icon(Icons.keyboard_arrow_down,color: Get.isDarkMode?admWhiteColor:admTextColor,)),
                      8.width,
                      Obx(
                            () => InkWell(
                          child: Text(
                            controller.selectedCountryCode.value.dialCode,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode
                                  ? admWhiteColor
                                  : admTextColor, // Set your desired text color
                            ),
                          ),
                          onTap: () {
                            showCountryDialog(context);
                          },
                        ),
                      ),


                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode ? admWhiteColor : admTextColor),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          focusNode: controller.f1,
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                          },
                          validator: (k) {
                            return null;
                          },
                          onChanged: (value) {
                            controller.errorTextMobile.value =
                                controller.validatePhoneNumber(
                                    controller.phoneController.text);
                          },
                          controller: controller.phoneController,
                          decoration: InputDecoration(

                            fillColor: Get.isDarkMode ? admDarkBorderColor : lightGreyColor,
                            filled: true,
                            isDense: true,
                            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Get.isDarkMode ? admDarkColorGrey : darkGreyColor),
                            hintText: phoneHint,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 20),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(color: admColorPrimary),
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            // Set focus color for filled color
                            focusColor: admColorPrimary,
                          ),

                        ),
                      ), // Display the dialing code
                    ],
                  ),
                ),
                Obx(
                      () => Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Text(
                      controller.errorTextMobile.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                20.height,
                Text(
                  genderText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.height,
                DropdownButtonFormField<int>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Get.isDarkMode ? admWhiteColor : admTextColor,
                    size: 20,
                  ),
                  decoration: InputDecoration(
                    fillColor:
                    Get.isDarkMode ? admDarkBorderColor : lightGreyColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent)),
                  ),
                  value: 1,
                  items: [
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      value: 0,
                      enabled: false,
                      child: Text(
                        genderText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400, color: darkGreyColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        male,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        role = male;
                      },
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(
                        feMale,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        role = feMale;
                      },
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(
                        others,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        role = others;
                      },
                    ),
                  ],
                  onChanged: (value) {
                    value = value;
                  },
                ),
                20.height,
                Text(
                  birthdate,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.height,


                Obx(
                  () =>  CustomTextField(
                    onTap: () {
                      controller.selectDate(context);
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        // onTap: () async {
                        //   final DateTime? picked = await showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime(2000),
                        //     lastDate: DateTime(2100),
                        //     builder: (BuildContext context, Widget? child) {
                        //       return Theme(
                        //         data: ThemeData.light().copyWith(
                        //           colorScheme: const ColorScheme.light().copyWith(
                        //             primary: admColorPrimary, // Set your desired color here
                        //           ),
                        //         ),
                        //         child: child!,
                        //       );
                        //     },
                        //   );
                        //
                        //
                        //   if (picked != null && DateFormat('MM/dd/yyyy').format(picked) != controller.dateController.value.text) {
                        //     setState(() {
                        //       controller.dateController.text = DateFormat('MM/dd/yyyy').format(picked);
                        //     });
                        //   }
                        //
                        //
                        // },
                        onTap: () {
                          controller.selectDate(context);
                        },
                        child: SvgPicture.asset(calender,
                            colorFilter: ColorFilter.mode(
                                Get.isDarkMode ? admWhiteColor : admTextColor,
                                BlendMode.srcIn)),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    hintText: birthdate,
                    //textEditingController: controller.dateController,
                    textEditingController: TextEditingController(
                      text: controller.selectedDate.value.isEmpty
                          ? '12/5/2000'
                          : controller.selectedDate.value,
                    ),
                    obscureText: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  void showCountryDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    List<AdmCountries> filteredCountries = controller.listOfCountries;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Select a Country',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(

                        controller: searchController,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .transparent), // Customize the color and width of the error border
                            borderRadius: BorderRadius.circular(
                                12), // Optional: Customize the border radius
                          ),
                          //InputBorder.none,

                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: admColorPrimary),
                          ),
                          fillColor:
                          Get.isDarkMode ? admDarkBorderColor : lightGreyColor,
                          filled: true,
                          isDense: true,

                          hintStyle: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode ? admDarkColorGrey : darkGreyColor),
                          hintText: 'Search here...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: admColorPrimary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          // Set focus color for filled color
                          focusColor: admColorPrimary,
                        ),
                        onChanged: (value) {
                          setState(() {
                            // Filter the countries based on the search query
                            filteredCountries = controller.listOfCountries
                                .where((country) => country.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height *
                          0.5, // Adjust height as needed
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          var country = filteredCountries[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Flag.fromString(
                              country.code,
                              height: 30,
                              width: 50,
                            ),
                            title: Text(
                              country.name,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              // Do something when a country is selected
                              controller.selectedCountryCode.value = country;

                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
