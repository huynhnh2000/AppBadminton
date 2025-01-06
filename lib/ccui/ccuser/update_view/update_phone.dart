
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/auth_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

class UpdatePhoneView extends StatefulWidget{
  UpdatePhoneView({super.key, required this.child});
  Widget child;
  bool isLoading = false;

  @override
  State<UpdatePhoneView> createState() => _UpdatePhoneView();
}

class _UpdatePhoneView extends State<UpdatePhoneView>{

  MyCurrentUser currentUser =MyCurrentUser();
  TextEditingController phoneControll = TextEditingController();


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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate("phone_old"), style: AppTextstyle.contentGreySmallStyle),
                            Text(AppFormat.formatPhoneNumberVN(currentUser.phone??""), style: AppTextstyle.subTitleStyle),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate("phone_new"), style: AppTextstyle.contentGreySmallStyle),
                            inputPhone(context),
                          ],
                        ),
                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: widget.isLoading?null:
                          () async{
                            setState(() {
                              widget.isLoading = true;
                            });

                            await AuthControll().handleUpdatePhone(context, phoneControll.text);
                            
                            setState(() {
                              widget.isLoading = false;
                            });
                          },
                          child: Container(
                            width: AppMainsize.mainWidth(context),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: widget.isLoading?
                              const Stack(children: [CircularProgressIndicator(color: AppColors.contentColorWhite,)],):
                              Text(
                                AppLocalizations.of(context).translate("update_phone"),
                                style: AppTextstyle.subWhiteTitleStyle,
                              ),
                            ),
                          ),
                        )
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

  Widget inputPhone(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      color: AppColors.pageBackground,
      child: TextFormField(
        controller: phoneControll,
        maxLength: 10,
        maxLines: 1 ,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          prefixIcon: const Icon(Icons.phone, color: Colors.grey, size: 25,),
          hintStyle: AppTextstyle.contentGreySmallStyle,
          labelStyle: AppTextstyle.contentBlackSmallStyle
        ),
      )
    );
  }

}