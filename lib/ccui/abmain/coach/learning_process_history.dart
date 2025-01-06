
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_learningprocess_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/ccui/ccresource/app_resources.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/learning_process_history_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningProcessHistoryView extends StatefulWidget{
  const LearningProcessHistoryView({super.key, required this.student});
  final MyStudent student;

  @override
  State<LearningProcessHistoryView> createState() => _LearningProcessHistoryView();
}

class _LearningProcessHistoryView extends State<LearningProcessHistoryView>{

  ListLearningprocessProvider lstLP = ListLearningprocessProvider();
  
  final FocusNode _focusNode = FocusNode();
  bool _showList = false;

  Future<void> initData() async{
    await lstLP.setAllListSortStudentId(widget.student.id!);
    lstLP.populateDateLists(lstLP.lstLP);
  }

  @override
  void initState() {
    lstLP = Provider.of<ListLearningprocessProvider>(context, listen: false);
    initData();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showList = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    lstLP.clearList();
    super.dispose();
  }

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

        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(context),

              Shimmer(
                linearGradient: shimmerGradient,
                child: Consumer<ListLearningprocessProvider>(
                  builder: (context, value, child) {
                    if(value.isLoading){
                      return ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: SizedBox(
                          width: AppMainsize.mainWidth(context),
                          height: AppMainsize.mainHeight(context),
                          child: const SafeArea(child: LoadingListView()),
                        )
                      );
                    }
                    else{
                      return ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: value.todayLst.isEmpty && value.yesterdayLst.isEmpty && value.createdLst.isEmpty
                          ? _buildEmptyState(context)
                          : _buildLearningProcessList(context, value)
                      );
                    }
                  },
                ),
              )
            ],
          )
        )
      ],
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text(AppLocalizations.of(context).translate("empty_list"), style: AppTextstyle.mainTitleStyle),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate("empty_sublist"), style: AppTextstyle.subTitleStyle),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget _buildLearningProcessList(BuildContext context, ListLearningprocessProvider value) {
  //   return Container(
  //     width: AppMainsize.mainWidth(context),
  //     height: AppMainsize.mainHeight(context),
  //     padding: const EdgeInsets.all(10),
  //     color: AppColors.pageBackground,
  //     child: SingleChildScrollView(
  //       physics: const NeverScrollableScrollPhysics(),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           value.todayLst.isNotEmpty?_buildSection(context, "today", value.todayLst):const SizedBox.shrink(),
  //           const SizedBox(height: 10,),
            
  //           value.yesterdayLst.isNotEmpty?_buildSection(context, "yesterday", value.yesterdayLst):const SizedBox.shrink(),
  //           const SizedBox(height: 10,),
            
  //           value.createdLst.isNotEmpty?_buildSection(context, "created", value.createdLst):const SizedBox.shrink(),
  //           const SizedBox(height: 10,),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLearningProcessList(BuildContext context, ListLearningprocessProvider value) {
    List<Widget> sections = [];
    if (value.todayLst.isNotEmpty) {
      sections.add(_buildSection(context, "today", value.todayLst));
    }
    if (value.yesterdayLst.isNotEmpty) {
      sections.add(_buildSection(context, "yesterday", value.yesterdayLst));
    }
    if (value.createdLst.isNotEmpty) {
      sections.add(_buildSection(context, "created", value.createdLst));
    }

    return Container(
      width: AppMainsize.mainWidth(context),
      padding: const EdgeInsets.all(10),
      color: AppColors.pageBackground,
      child: ListView.builder(
        itemCount: sections.length,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index){
          return sections[index];
        }
      )
    );
  }

  Widget _buildSection(BuildContext context, String titleKey, List<MyLearningProcess> list) {
    return SizedBox(
      width: AppMainsize.mainWidth(context),
      child: Column(
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return LearningProcessHistoryItem(
                    myLP: list[index],
                    myStudent: widget.student,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context){
    return Consumer<ListLearningprocessProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              width: AppMainsize.mainWidth(context),
              color: AppColors.pageBackground,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                focusNode: _focusNode,
                maxLines: 1,
                decoration: InputDecoration(
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.transparent)
                  ),
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 25),
                  hintText: AppLocalizations.of(context).translate("hint_search"),
                  hintStyle: AppTextstyle.contentGreySmallStyle,
                  labelStyle: AppTextstyle.contentBlackSmallStyle,
                ),
                onChanged: (value) async {
                  provider.filterListSearch(value);
                },
                onTap: () {
                  setState(() {
                    _showList = true;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    _showList = false;
                  });
                },
              ),
            ),
            if (_showList)
              Container(
                color: Colors.white,
                width: AppMainsize.mainWidth(context),
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.filterList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return LearningProcessHistoryItem(
                      myLP: provider.filterList[index],
                      myStudent: widget.student,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

}