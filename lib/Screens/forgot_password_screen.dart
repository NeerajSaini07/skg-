// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:campuspro/Controllers/forgotpassword_controller.dart';
import 'package:campuspro/Screens/Wedgets/app_rights.dart';
import 'package:campuspro/Screens/Wedgets/common_button.dart';
import 'package:campuspro/Screens/Wedgets/common_form_component.dart';
import 'package:campuspro/Screens/Wedgets/customeheight.dart';
import 'package:campuspro/Screens/Wedgets/error_commponet.dart';
import 'package:campuspro/Services/InternetConnection/internet_connectivity.dart';
import 'package:campuspro/Utilities/colors.dart';
import 'package:campuspro/Utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ForgotPasswordController forgotPasswordController =
      Get.find<ForgotPasswordController>();
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      forgotPasswordController.clearvalue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: AppColors.loginscafoldcoolr,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColors.loginscafoldcoolr,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomeHeight(30.h),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  CustomeHeight(5.h),
                  Text(
                    "No Worries we'll send you The Reset Instruction",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                  CustomeHeight(30.h),
                  Center(
                    child: Card(
                        child: SizedBox(
                      width: double.infinity,
                      height: 360.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomeHeight(29.h),
                            Obx(() {
                              return forgotPasswordController
                                      .showerrortext.value
                                  ? errocommponent(
                                      fontsize: 12.sp,
                                      errorText:
                                          forgotPasswordController.errorText)
                                  : SizedBox();
                            }),
                            Obx(() {
                              return forgotPasswordController
                                      .showerrortext.value
                                  ? CustomeHeight(10.h)
                                  : SizedBox();
                            }),
                            buildTextField(
                              hintText: "Mobile",
                              controller: forgotPasswordController
                                  .mobileNumberController,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // initialValue:
                              //     forgotPasswordController.showDropDown.value
                              //         ? forgotPasswordController
                              //             .mobileForForgotPass.value
                              //         : null,
                              prefixIconData: Icons.call,
                              onChanged: (value) {
                                //  ********************************  for forget pass word filed empty and recalling the api ****************
                                forgotPasswordController.showerrortext.value =
                                    false;
                                forgotPasswordController
                                    .mobileForForgotPass.value = value;
                                forgotPasswordController.items.clear();
                                forgotPasswordController.showDropDown.value =
                                    false;
                                forgotPasswordController
                                    .selectedDropDownId.value = '';
                                forgotPasswordController.selectedvalue.value =
                                    '';
                                if (value.length == 10) {
                                  forgotPasswordController.items.clear();
                                  forgotPasswordController
                                      .forgotpassForFetchSchool();
                                  FocusScope.of(context).unfocus();
                                }
                              },
                            ),
                            CustomeHeight(8.h),
                            Obx(() => (forgotPasswordController
                                        .showDropDown.value &&
                                    forgotPasswordController
                                        .mobileForForgotPass.isNotEmpty)
                                ? Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 17.h, horizontal: 14.w),
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        value: forgotPasswordController
                                                .selectedvalue.value.isEmpty
                                            ? null
                                            : forgotPasswordController
                                                .selectedvalue.value,
                                        isExpanded: true,
                                        underline: Container(),
                                        hint: Text(
                                          'Select School Name',
                                          style: TextStyle(
                                            color: Colors.black,
                                            // fontSize: 14.sp
                                          ),
                                        ),
                                        items: forgotPasswordController.items
                                            .map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value[1],
                                            child: Text(value[1]),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          forgotPasswordController
                                              .selectedvalue.value = val!;

                                          for (var element
                                              in forgotPasswordController
                                                  .items) {
                                            if (element[1] ==
                                                forgotPasswordController
                                                    .selectedvalue.value) {
                                              forgotPasswordController
                                                  .selectedDropDownId
                                                  .value = element[0];
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox()),
                            CustomeHeight(13.h),
                            Obx(
                              () => appCommonbutton(
                                  onpressed: () {
                                    if (connectivityService.isConnected.value) {
                                      if (forgotPasswordController
                                              .mobileForForgotPass
                                              .value
                                              .length <
                                          10) {
                                        forgotPasswordController
                                            .showerrortext.value = true;
                                        forgotPasswordController
                                            .errorText.value = '';
                                        forgotPasswordController
                                                .errorText.value =
                                            'Please enter a valid mobile no.';
                                      } else {
                                        forgotPasswordController
                                            .forgetPasswordForSendotp();
                                      }
                                    } else {
                                      connectivityService
                                          .showNoConnectionBottomSheet();
                                    }
                                  },
                                  disable: (forgotPasswordController
                                              .mobileForForgotPass
                                              .value
                                              .length <
                                          10 &&
                                      forgotPasswordController
                                          .selectedvalue.isEmpty),
                                  text: "Send OTP"),
                            ),
                            CustomeHeight(8.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: () {
                                    Get.offAllNamed(Routes.login);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 12.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          " Login ",
                                          style: TextStyle(
                                              color: AppColors.primarytextcolor,
                                              fontSize: 16.sp,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.primarytextcolor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                  CustomeHeight(50.h),
                  appRights(),
                ],
              ),
            ),
          )),
    );
  }
}
