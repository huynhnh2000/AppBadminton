
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/auth_controll.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

class ChangePasswordSecondView extends StatefulWidget{
  const ChangePasswordSecondView({super.key});

  @override
  State<ChangePasswordSecondView> createState() => _ChangePasswordSecondView();
}

class _ChangePasswordSecondView extends State<ChangePasswordSecondView>{

  TextEditingController newPassControll = TextEditingController();
  TextEditingController confirmPassControll = TextEditingController();

  bool isUpdate = false;
  bool isHide = true;
  double passwordStrength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: [
        Container(
          width: AppMainsize.mainWidth(context),
          height: AppMainsize.mainHeight(context),
          color: AppColors.pageBackground,
        ),

        Container(
          width: AppMainsize.mainWidth(context),
          height: AppMainsize.mainHeight(context),
          color: AppColors.pageBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //------------------
              Container(
                width: AppMainsize.mainWidth(context),
                height: AppMainsize.mainHeight(context)/4,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
                ),
                child: SafeArea(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("select_input_newpass"),
                      style: AppTextstyle.mainWhiteTitleStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                )
              ),
              const SizedBox(height: 20,),

              //------------------
              Container(
                width: AppMainsize.mainWidth(context),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("New Password", style: AppTextstyle.subTitleStyle,),
                        TextFormField(
                          controller: newPassControll,
                          maxLines: 1,
                          obscureText: isHide,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  isHide=!isHide;
                                });
                              }, 
                              icon: Icon(isHide?Icons.remove_red_eye:Icons.remove_red_eye_outlined, size: 25, color: Colors.grey,),
                            ),
                            border: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.grey)),
                            labelStyle: AppTextstyle.contentBlackSmallStyle
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Confirm Password", style: AppTextstyle.subTitleStyle,),
                        TextFormField(
                          controller: confirmPassControll,
                          maxLines: 1,
                          obscureText: isHide,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  isHide=!isHide;
                                });
                              }, 
                              icon: Icon(isHide?Icons.remove_red_eye:Icons.remove_red_eye_outlined, size: 25, color: Colors.grey,),
                            ),
                            border: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.grey)),
                            labelStyle: AppTextstyle.contentBlackSmallStyle
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              
              //------------------
              Center(
                child: Container(
                  width: AppMainsize.mainWidth(context)-100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: GestureDetector(
                    onTap: () async{
                      setState(() {
                        isUpdate = true;
                      });

                      await AuthControll().handleUpdatePassword(context, newPassControll.text, confirmPassControll.text);

                      setState(() {
                        isUpdate = false;
                      });
                    },
                    child: Center(
                      child: isUpdate?
                      const CircularProgressIndicator(color: Colors.white,):
                      Text(
                        AppLocalizations.of(context).translate("update_password"),
                        style: AppTextstyle.subWhiteTitleStyle,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        )
      ],
    );
  }

}