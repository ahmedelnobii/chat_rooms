import 'package:chat_rooms/core/consts/app_colors.dart';
import 'package:chat_rooms/core/routes/app_routs.dart';
import 'package:chat_rooms/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50.h),

            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/151', // Replace with your profile image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ), // Replace with user's profile image

                  Text(
                    textAlign: .center,
                    "Ahmed",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textAlign: .center,
                    "email@example.com",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // CustomButton(
                  //   backgroundColor: Colors.grey.shade200,
                  //   forgroundColor: AppColors.primiary,
                  //   weight: FontWeight.w500,
                  //   fontsize: 14.sp,
                  //   onPressed: () {
                  //     // Handle edit profile action
                  //   },
                  //   text: "edit profile",
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Activities",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),

              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.history, color: Colors.blue),
                  title: Text("Go to History"),
                  subtitle: Text("35 rooms"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Accoount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),

              child: InkWell(
                onTap: () {
                  context.go(AppRouts.loginScreen);
                },
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Sign out", style: TextStyle(color: Colors.red)),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
