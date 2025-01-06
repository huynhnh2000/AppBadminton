
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_learningprocess_provider.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/youtube_student_home_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListVideoLearningprocess extends StatefulWidget{
  const ListVideoLearningprocess({super.key});

  @override
  State<ListVideoLearningprocess> createState() => _ListVideoLearningprocess();
}

class _ListVideoLearningprocess extends State<ListVideoLearningprocess> {
  // MyWeek? currentWeek;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListLearningprocessProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          padding: const EdgeInsets.all(10),
          child: Shimmer(
            linearGradient: shimmerGradient,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                value.isLoading
                    ? ShimmerLoading(
                        isLoading: value.isLoading,
                        child: const LoadingListView(),
                      )
                    : ShimmerLoading(
                        isLoading: value.isLoading,
                        child: _listItem(context),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _listItem(BuildContext context) {
    return Consumer<ListLearningprocessProvider>(
      builder: (context, value, child) {
        if (value.monthList.isEmpty) {
          return _buildEmptyState(context);
        }

        return Container(
            width: AppMainsize.mainWidth(context),
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sortDropdown(context),

                ListView.builder(
                  itemCount: value.monthList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (value.monthList.isNotEmpty) {
                      return YoutubeStudentItem(lp: value.monthList[index]);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            )
          );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context),
      height: AppMainsize.mainHeight(context),
      padding: const EdgeInsets.all(20),
      color: AppColors.pageBackground,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: AppMainsize.mainWidth(context) - 100,
              child: Image.asset(
                'assets/logo_icon/empty-box-icon.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate("empty_list"), style: AppTextstyle.mainTitleStyle, textAlign: TextAlign.center,),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate("empty_sublist"), style: AppTextstyle.subTitleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sortDropdown(BuildContext context){
    return Consumer<ListLearningprocessProvider>(
      builder: (context, provider, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          padding: const EdgeInsets.all(10),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                AppLocalizations.of(context).translate("sort_list"),
                style: AppTextstyle.subTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10,),

              Container(
                width: AppMainsize.mainWidth(context),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: DropdownButton<String>(
                  value: provider.currentDropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_rounded, size: 45, color: Colors.grey),
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  style: AppTextstyle.contentBlackSmallStyle,
                  onChanged: (currentValue) {
                    provider.currentDropdownValue = currentValue;
                    provider.sortListMonthStudent(context);
                  },
                  items: provider.lstDropdown(context).map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: value,
                              style: AppTextstyle.contentBlackSmallStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
            ],
          )
        );
      },
    );
  }
}
