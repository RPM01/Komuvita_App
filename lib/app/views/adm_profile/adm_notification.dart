import 'package:flutter/material.dart';
import 'package:administra/app/views/adm_profile/adm_custum_switch.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import 'package:get/get.dart';
import '../../controller/adm_my_profile_controller.dart'; 

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeData theme;
  MyProfileController controller = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  bool notifyBool1 = true;
  bool notifyBool2 = true;
  bool notifyBool3 = false;
  bool notifyBool4 = true;
  bool notifyBool5 = true;
  bool notifyBool6 = false;
  bool notifyBool7 = false;
  bool notifyBool8 = true;
  bool notifyBool9 = false;
  bool notifyBool10 = true;
  bool notifyBool11 = false;
  bool notifyBool12 = false;
  bool notifyBool13 = true;
  bool notifyBool14 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(
          image: '', context: context, theme: theme, text: notificationText),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSwitchRow(notifyText1, notifyBool1, (newValue) {
                setState(() {
                  notifyBool1 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText2, notifyBool2, (newValue) {
                setState(() {
                  notifyBool2 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText3, notifyBool3, (newValue) {
                setState(() {
                  notifyBool3 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText4, notifyBool4, (newValue) {
                setState(() {
                  notifyBool4 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText5, notifyBool5, (newValue) {
                setState(() {
                  notifyBool5 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText6, notifyBool6, (newValue) {
                setState(() {
                  notifyBool6 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText7, notifyBool7, (newValue) {
                setState(() {
                  notifyBool7 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText8, notifyBool8, (newValue) {
                setState(() {
                  notifyBool8 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText9, notifyBool9, (newValue) {
                setState(() {
                  notifyBool9 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText10, notifyBool10, (newValue) {
                setState(() {
                  notifyBool10 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText11, notifyBool11, (newValue) {
                setState(() {
                  notifyBool11 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText12, notifyBool12, (newValue) {
                setState(() {
                  notifyBool12 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText13, notifyBool13, (newValue) {
                setState(() {
                  notifyBool13 = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(notifyText14, notifyBool14, (newValue) {
                setState(() {
                  notifyBool14 = newValue;
                });
              }, theme),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSwitchRow(
    String title, bool value, void Function(bool) onChanged, ThemeData theme) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      CustomSwitch(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}
