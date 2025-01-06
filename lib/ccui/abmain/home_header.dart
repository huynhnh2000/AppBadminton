import 'dart:math';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/ccuser/profile_view.dart';
import 'package:flutter/material.dart';

class HomeHeaderView extends StatefulWidget{
  const HomeHeaderView({super.key, required this.body});

  final Widget body;

  @override
  State<HomeHeaderView> createState() => _HomeHeaderView();
}

class _HomeHeaderView extends State<HomeHeaderView>{

  final currentUser = MyCurrentUser();
  double valueAnimate = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            // Detect horizontal drag
            if (details.delta.dx > 0) {
              setState(() {
                valueAnimate = 0;
              });
            }
          },
          child: _sideMenu(context),
        ),
      );
  }

  Widget _sideMenu(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context),
      height: AppMainsize.mainHeight(context),
      color: AppColors.secondary,
      child: Stack(
        children: [
          // Sidebar content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile
                Container(
                  width: AppMainsize.mainWidth(context),
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: currentUser.imageAssets == null && currentUser.image != null
                              ? Image.network(currentUser.image!, fit: BoxFit.cover)
                              : Image.asset(currentUser.imageAssets!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile and Settings options
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.person, color: Colors.white, size: 30),
                  title: Text("Profile", style: AppTextstyle.subWhiteTitleStyle, textAlign: TextAlign.end),
                ),
                // ListTile(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const AccountInformationView(),
                //       ),
                //     );
                //   },
                //   trailing: const Icon(Icons.settings, color: Colors.white, size: 30),
                //   title: Text("Settings", style: subWhiteTitleStyle, textAlign: TextAlign.end),
                // ),
              ],
            ),
          ),

          // 3D Slide Animation
          Positioned.fill(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: valueAnimate),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, double val, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Depth effect
                    ..translate(200 * val, -20 * val) // Horizontal and vertical movement
                    ..scale(1 - (0.1 * val)) // Slight scaling down
                    ..rotateX((pi / 24) * val) // Top tilting effect
                    ..rotateY((pi / 10) * val), // Horizontal rotation for 3D effect
                  child: Opacity(
                    opacity: val.clamp(1.0, 1.0),
                    child: ClipRRect(
                      borderRadius: val==0?BorderRadius.circular(0):BorderRadius.circular(25),
                      child: _body(context, val),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context, double val){

    double headerHeight = 190;

    return Container(
      width: AppMainsize.mainWidth(context),
      color: AppColors.pageBackground,
      child: Stack(
        children: [
          

          //--------------------------------
          Positioned.fill(
            top: headerHeight+10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(
                //   flex: 0,
                //   child: SafeArea(child: _titleWellcome(context))
                // ),
                Expanded(
                  flex: 15,
                  child: val==0?widget.body:
                  SizedBox(
                    width: AppMainsize.mainWidth(context),
                    height: AppMainsize.mainHeight(context),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        // Detect horizontal drag
                        if (details.delta.dx > 0) {
                          setState(() {
                            valueAnimate = 0;
                          });
                        }
                      },
                      child: widget.body,
                    ),
                  )
                ),
              ],
            ),
          ),

          //
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: AppMainsize.mainWidth(context),
              height: headerHeight,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(color: AppColors.primary, offset: Offset(0, 0), blurRadius: 20)
                ],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
              ),
              child: SafeArea(child: _titleWellcome(context)),
            )
          ),

        ],
      )
    );
  }

  Widget _titleWellcome(BuildContext context){
    return SizedBox(
      width: AppMainsize.mainWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //
          Container(
            width: AppMainsize.mainWidth(context),
            padding: const EdgeInsets.only(left: 20, top: 20),
            clipBehavior: Clip.none,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70, height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: currentUser.image==null?
                      Image.asset(currentUser.imageAssets!, fit: BoxFit.cover,):
                      Image.network(currentUser.image??"", fit: BoxFit.cover,)
                  ),
                ),
                const SizedBox(width: 20,),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: AppMainsize.mainWidth(context)-300,
                      child: Text(
                        AppLocalizations.of(context).translate("wellcome_home"),
                        style: AppTextstyle.subWhiteTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: AppMainsize.mainWidth(context)-200,
                      child: Text(
                        AppFormat.removeParentheses(currentUser.username??""),
                        style: AppTextstyle.mainWhiteTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20,),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                          valueAnimate == 0 ? valueAnimate = -1 : valueAnimate = 0;
                        });
                      }, 
                      icon: const Icon(Icons.settings, size: 20, color: Colors.white,)
                    ),
                  )
                )

              ],
            ),
          )
        ],
      ),
    );
  }

}