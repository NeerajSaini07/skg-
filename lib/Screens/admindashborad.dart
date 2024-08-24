// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePageController extends GetxController {
  var studentStrength = '633'.obs;
  var staffAttendance = 'P-0/31'.obs;
  var studentpAttendance = 'P-212'.obs;
  var studentaAttendance = 'A-3'.obs;
  var studentlAttendance = 'L-0'.obs;
  var payments = '0'.obs;
  var balanceFee = ''.obs;
  var busAverage = '0.38'.obs;
  var totalCollection = '0'.obs;
  var newAdmissions = '0'.obs;
  var newRegistrations = '0'.obs;
  var newEnquiries = '0'.obs;
}

class MyHomePage extends StatelessWidget {
  final MyHomePageController controller = Get.put(MyHomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo School'),
        backgroundColor: Color(0xFF344966),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
         
            end: Alignment.bottomRight,
            colors: [Color(0xFF132241),Color(0xFF7671e5),Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Dashboard',
                  style: TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height:18),
                // First Row
                Row(
                  children: [
                    Expanded(child: Obx(() => _buildCard(controller.studentStrength.value, 'Student Strength', 'assets/icon/student.png', Color(0xff2758b3)))),
                    SizedBox(width: 7),
                    Expanded(child: Obx(() => _buildCard(controller.staffAttendance.value, 'Staff Attendance', 'assets/icon/staff_attendance.png', Color(0xff6327b3)))),
                  ],
                ),
                SizedBox(height: 2),
                // Second Row (Single Card with full width)
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _buildCard(controller.studentpAttendance.value, 'Student Attendance', 'assets/icon/attendance.png', Colors.green,
                      //  additionalData: 'Absent: ${controller.studentaAttendance.value}, Late: ${controller.studentlAttendance.value}',
                                                  
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                // Third Row
                Row(
                  children: [
                    Expanded(child: Obx(() => _buildCard(controller.payments.value, 'Payments', 'assets/icon/fees.png', Colors.lightGreen))),
                    SizedBox(width: 7),
                    Expanded(child: Obx(() => _buildCard(controller.balanceFee.value, 'Balance Fee', 'assets/icon/fees.png', Colors.lightGreen))),
                  ],
                ),
                SizedBox(height: 2),
                // Fourth Row
                Row(
                  children: [
                    Expanded(child: Obx(() => _buildCard(controller.busAverage.value, 'Total Bus Average', 'assets/icon/bus-school.png', Colors.orange))),
                    SizedBox(width: 7),
                    Expanded(child: Obx(() => _buildCard(controller.totalCollection.value, 'Total Collection','assets/icon/fees.png', Color(0xff281dd3)))),
                  ],
                ),
                SizedBox(height: 10),
                // Fifth Row (Single Card full width)
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _buildCard(controller.newAdmissions.value, 'New Admissions','assets/icon/admission_status.png', Colors.red)),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                // Sixth Row (Two Cards below the full-width one)
                Row(
                  children: [
                    Expanded(child: Obx(() => _buildCard(controller.newRegistrations.value, 'New Registrations', 'assets/icon/checklist.png', Colors.green))),
                    SizedBox(width:7),
                    Expanded(child: Obx(() => _buildCard(controller.newEnquiries.value, 'New Enquiries', 'assets/icon/enquiry.png', Colors.orange))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildCard(String value, String title, String imagePath, Color iconColor) {
  return SizedBox(
    height: 80, 
    child: Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 30, // Adjust size to fit the design
              height:30 ,
               // Apply color if needed
            ),
            SizedBox(width: 8), // Add space between the image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(height:0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
  
