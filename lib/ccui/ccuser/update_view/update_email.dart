
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/auth_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

class UpdateEmailView extends StatefulWidget{
  UpdateEmailView({super.key, required this.child});
  Widget child;
  bool isLoading = false;

  @override
  State<UpdateEmailView> createState() => _UpdateEmailView();
}

class _UpdateEmailView extends State<UpdateEmailView>{

  MyCurrentUser currentUser =MyCurrentUser();
  TextEditingController emailControll = TextEditingController();


  Future<void> showBottomNavigate() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: !widget.isLoading,
      elevation: 20,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: AppMainsize.mainWidth(context),
                height: AppMainsize.mainHeight(context) / 2.3,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.pageBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate("email_old"),
                              style: AppTextstyle.contentGreySmallStyle,
                            ),
                            Text(
                              currentUser.email ?? "",
                              style: AppTextstyle.subTitleStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate("email_new"),
                              style: AppTextstyle.contentGreySmallStyle,
                            ),
                            inputEmail(context),
                          ],
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: widget.isLoading
                              ? null
                              : () async {
                                  setModalState(() {
                                    widget.isLoading = true;
                                  });
                                  
                                  await AuthControll().handleUpdateEmail(context, emailControll.text);

                                  setModalState(() {
                                    widget.isLoading = false;
                                  });
                                },
                          child: Container(
                            width: AppMainsize.mainWidth(context),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: widget.isLoading
                                  ? const CircularProgressIndicator(color: AppColors.contentColorWhite)
                                  : Text(
                                      AppLocalizations.of(context).translate("update_email"),
                                      style: AppTextstyle.subWhiteTitleStyle,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await showBottomNavigate();
      },
      child: widget.child,
    );
  }

  Widget inputEmail(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      color: AppColors.pageBackground,
      child: TextFormField(
        controller: emailControll,
        maxLines: 1 ,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          prefixIcon: const Icon(Icons.email, color: Colors.grey, size: 25,),
          hintStyle: AppTextstyle.contentGreySmallStyle,
          labelStyle: AppTextstyle.contentBlackSmallStyle
        ),
      )
    );
  }

}