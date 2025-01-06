import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/coach_controll.dart';
import 'package:badminton_management_1/bbcontroll/state/list_coach_provider.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/coach_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCoachView extends StatefulWidget{
  const ListCoachView({super.key, required this.isConnect});
  final bool isConnect;

  @override
  State<ListCoachView> createState() => _ListCoachView();
}

class _ListCoachView extends State<ListCoachView>{

  bool isSaving = false;

  Future<void> loadData() async{
    await CoachControll().handleGetAllCoach(context);
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _body(context)
        )
      ),
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      height: AppMainsize.mainHeight(context),
      color: AppColors.pageBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: Column(
              children: [
                _searchBar(context),
              ],
            )
          ),

          Expanded(
            child: Consumer<ListCoachProvider>(
              builder: (context, value, child) {
                return Shimmer(
                  linearGradient: shimmerGradient,
                  child: Container(
                  width: AppMainsize.mainWidth(context),
                    padding: const EdgeInsets.only(bottom: 50),
                    child: 
                    value.isLoading?
                      ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: const LoadingListView()
                      ):
                      ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: ListView.builder(
                          itemCount: value.lstCoachFilter.length,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: CoachItem(coach: value.lstCoachFilter[index], isConnect: widget.isConnect,),
                            );
                          }
                        )
                      ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context){
    return Consumer<ListCoachProvider>(
      builder: (context, provider, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          color: AppColors.pageBackground,
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            maxLines: 1 ,
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.transparent)),
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 25,),
              hintText: AppLocalizations.of(context).translate("hint_search"),
              hintStyle: AppTextstyle.contentGreySmallStyle,
              labelStyle: AppTextstyle.contentBlackSmallStyle
            ),
            onChanged: (value) async{
              provider.filterListSearch(value);
            },
          )
        );
      },
    );
  }

}