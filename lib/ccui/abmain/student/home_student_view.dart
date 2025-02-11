// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/session_controll.dart';
import 'package:badminton_management_1/bbcontroll/state/list_learningprocess_provider.dart';
import 'package:badminton_management_1/bbcontroll/weather_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_weather.dart';
import 'package:badminton_management_1/ccui/abmain/home_header.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/abmain/student/list_video_learningprocess.dart';
import 'package:badminton_management_1/ccui/abmain/student/wellcome_text.dart';
import 'package:badminton_management_1/ccui/ccitem/slider_student.dart';
import 'package:badminton_management_1/ccui/ccitem/youtube_student_home_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeStudentView extends StatefulWidget {
  const HomeStudentView({super.key});

  @override
  State<HomeStudentView> createState() => _HomeStudentView();
}

class _HomeStudentView extends State<HomeStudentView>
    with SingleTickerProviderStateMixin {
  WeatherControll weatherControll = WeatherControll();
  final currentUser = MyCurrentUser();
  final currentWeather = MyCurrentWather();
  final sessionManager = SessionManager();

  String dateChoosed = "";
  double valueAnimate = 0;
  double footerTabBar = 50;

  ListLearningprocessProvider lpProvider = ListLearningprocessProvider();

  Future<void> initializeData() async {
    lpProvider =
        Provider.of<ListLearningprocessProvider>(context, listen: false);
    await lpProvider.setListWithStudentId(currentUser.id!);
    await lpProvider.setYoutubeList();
    lpProvider.setThisMonthList(context);
    lpProvider.setMonthList(context, dateChoosed.split("/")[0]);
    lpProvider.populateDateLists(lpProvider.thisMonthList);
  }

  Future<void> chooseDate() async {
    DateFormat formated = DateFormat('yyyy-MM-dd');
    DateTime dateStart = formated.parse(currentUser.startDay ?? "");

    DateTime? choosed = await showCustomMonthPicker(
        context: context, dateStart: dateStart, dateEnd: DateTime.now());
    if (choosed != null) {
      setState(() {
        dateChoosed = DateFormat('MM/yyyy').format(choosed);
      });
      await initializeData();
    }
  }

  Future<DateTime?> showCustomMonthPicker({context, dateStart, dateEnd}) async {
    DateTime? result = await showMonthPicker(
      context: context,
      initialDate: dateStart,
      firstDate: dateStart,
      lastDate: dateEnd,
      monthPickerDialogSettings: MonthPickerDialogSettings(
          headerSettings: const PickerHeaderSettings(
              headerBackgroundColor: AppColors.secondary),
          buttonsSettings: PickerButtonsSettings(
              unselectedMonthsTextColor: AppColors.secondary,
              unselectedYearsTextColor: AppColors.secondary,
              monthTextStyle: AppTextstyle.contentBlueSmallStyle
                  .copyWith(fontSize: AppMainsize.mainWidth(context) / 30),
              yearTextStyle: AppTextstyle.subTitleStyle
                  .copyWith(fontSize: AppMainsize.mainWidth(context) / 40),
              selectedDateRadius: 10,
              selectedMonthBackgroundColor: AppColors.secondary,
              selectedMonthTextColor: Colors.white)),
      confirmWidget: Text("OK", style: AppTextstyle.contentGreySmallStyle),
      cancelWidget: Text("Cancel", style: AppTextstyle.contentGreySmallStyle),
    );
    return result;
  }

  @override
  void initState() {
    initializeData();
    sessionManager.startSession(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeHeaderView(body: _body(context)));
  }

  Widget _body(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: AppMainsize.mainWidth(context),
            height: AppMainsize.mainHeight(context),
            color: AppColors.pageBackground,
          ),
          Container(
              width: AppMainsize.mainWidth(context),
              height: AppMainsize.mainHeight(context),
              padding: const EdgeInsets.all(10),
              child: Scrollbar(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionWelcome(),
                    _sectionVideoList(),
                  ],
                ),
              )))
        ],
      ),
    );
  }

  Widget _sectionWelcome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppMainsize.mainWidth(context),
          color: AppColors.pageBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppMainsize.mainWidth(context),
                child: const SliderStudent(),
              ),
              const SizedBox(height: 10),
              firstParagraph(context),
              const SizedBox(height: 10),
              secondParagraph(context),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: AppMainsize.mainWidth(context) - 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("vision_purpose"),
                      style: AppTextstyle.mainWhiteTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              thirdParagraph(context),
              const SizedBox(height: 10),
              fourthParagraph(context),
              const SizedBox(height: 10),
              fifthParagraph(context),
              const SizedBox(height: 30),
              Center(
                child: _buttonAlbum(context),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonAlbum(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = currentUser.linkURL;
        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          _showErrorDialog(context); // Hiển thị hộp thoại thông báo
        }
      },
      child: Container(
        width: AppMainsize.mainWidth(context) - 100,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context).translate("collection_img"),
            style: AppTextstyle.subWhiteTitleStyle,
          ),
        ),
      ),
    );
  }

// Hàm hiển thị hộp thoại thông báo khi không tìm thấy URL
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lỗi"),
          content: Text("Không thể mở đường link! Vui lòng kiểm tra lại."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionVideoList() {
    return Container(
      width: AppMainsize.mainWidth(context),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: footerTabBar),
      color: AppColors.pageBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppMainsize.mainWidth(context),
            child: Text(
              AppLocalizations.of(context).translate("study_process"),
              style: AppTextstyle.mainTitleStyle
                  .copyWith(color: AppColors.secondary, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          _thisMonthListWidget(context),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context).translate("another_month"),
            style: AppTextstyle.mainTitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          _chooseDateButton(context),
          const ListVideoLearningprocess(),
        ],
      ),
    );
  }

  Widget _thisMonthListWidget(BuildContext context) {
    return Consumer<ListLearningprocessProvider>(
      builder: (context, value, child) {
        return Shimmer(
          linearGradient: shimmerGradient,
          child: SizedBox(
            width: AppMainsize.mainWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate("this_month"),
                  style: AppTextstyle.mainTitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _buildLearningProcessList(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearningProcessList(BuildContext context) {
    return Consumer<ListLearningprocessProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          color: AppColors.pageBackground,
          child: SafeArea(
            child: ListView(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                if (value.todayLst.isNotEmpty)
                  _buildSection(context, "today", value.todayLst),
                if (value.yesterdayLst.isNotEmpty)
                  _buildSection(context, "yesterday", value.yesterdayLst),
                if (value.createdLst.isNotEmpty)
                  _buildSection(context, "created", value.createdLst),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
      BuildContext context, String titleKey, List<MyLearningProcess> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate(titleKey),
          style: AppTextstyle.subTitleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          width: AppMainsize.mainWidth(context),
          color: AppColors.pageBackground,
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return YoutubeStudentItem(lp: list[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _chooseDateButton(BuildContext context) {
    return Consumer<ListLearningprocessProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: value.isLoading
              ? null
              : () async {
                  await chooseDate();
                },
          child: Container(
            width: AppMainsize.mainWidth(context),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateChoosed == ""
                      ? ""
                      : "${AppLocalizations.of(context).translate("month")} $dateChoosed",
                  style: AppTextstyle.subWhiteTitleStyle,
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white,
                  size: 45,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
