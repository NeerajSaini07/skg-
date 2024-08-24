import 'package:campuspro/Controllers/appbar_controller.dart';
import 'package:campuspro/Controllers/bottombar_controller.dart';
import 'package:campuspro/Controllers/fcm_token_controller.dart';
import 'package:campuspro/Controllers/web_controller.dart';
import 'package:campuspro/Modal/drawer_model.dart';
import 'package:campuspro/Modal/usertype_model.dart';
import 'package:campuspro/Repository/usertype_repo.dart';
import 'package:campuspro/Utilities/constant.dart';
import 'package:campuspro/Utilities/routes.dart';
import 'package:campuspro/Utilities/sharedpref.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserTypeController extends GetxController {
  getUsers() async {
    await getBaseUrl();
    try {
      await UserTypeRepository.getuserstypeInRepo().then((value) async {
        if (value != null) {
          List<dynamic> data = value['Data'];
          UserTypeslist.userTypesDetails =
              data.map((json) => UserTypeModel.fromJson(json)).toList();
          // await Sharedprefdata.storeStringData(Sharedprefdata.userTypeData,
          //     jsonEncode(UserTypeslist.userTypesDetails));
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  getBaseUrl() async {
    try {
      await UserTypeRepository.getbaseUrlInRepo().then((value) async {
        if (value != null) {
          await Sharedprefdata.storeStringData(
              Sharedprefdata.baseUrl, value['Data']['BaseApiUrl']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

// selecting the user typ and redirecting to web dashborad ***************
  gotoDashBorad(String url, [Map<String, int>? indexMap]) async {
    final BottomBarController bottomBarController =
        Get.find<BottomBarController>();
    bottomBarController.checkToShowChatOption(indexMap?.values.first ?? -1);

    final FcmTokenController fcmTokenController =
        Get.find<FcmTokenController>();

    final WebController webController = Get.find<WebController>();

    final AppbarController appbarController = Get.find<AppbarController>();

    //  Putting Company Name on

    appbarController.appBarName.value = Constant.schoolName;
    Constant.dashBoardUrl = url;

    //  ************************  storig user details *******************

    await getUsers();
    // **********************************  Generat fcm Token **************
    int index = indexMap?.values.first ?? -1;
//  **************************** Stroing index of the currect user  ********************************
    await Sharedprefdata.storeIntegerData(Sharedprefdata.userTypeIndex, index);
    // *****************************************************************

//  **************************** Stroing fcm token  ********************************
    await fcmTokenController.getFCMToken();
    // *****************************************************************

    if (UserTypeslist.userTypesDetails[index].dashboardType == 'W') {
      try {
        // ********************* finding menu from user *************************************
        await UserTypeRepository.getDrawerData(index).then((value) {
          List<dynamic> data = value['Data'];
          MenuItemList.menuItemDetails =
              data.map((json) => DrawerMenu.fromJson(json)).toList();
        });

        // if (UserTypeslist.userTypesDetails[index].ouserType == "G") {
        //   Get.toNamed(Routes.visitorHistory);
        // } else {
        //   Get.toNamed(Routes.webview);
        // }

        Get.toNamed(Routes.webview);

// ************************************************************************
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    //webController.gotoWebview(url);
    webController.currentUrl.value = url;
  }
}
