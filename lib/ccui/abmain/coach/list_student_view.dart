
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/rollcall_controll.dart';
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbcontroll/student_controller.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_time.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/student_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ListStudentView extends StatefulWidget{
  const ListStudentView({super.key, required this.isConnect});
  final bool isConnect;

  @override
  State<ListStudentView> createState() => _ListStudentView();
}

class _ListStudentView extends State<ListStudentView>{

  double footerHeight = 70;
  bool isSaving = false;

  late ListStudentProvider listStudentProvider;

  Future<void> loadData() async{
    await StudentControll().handleGetStudents(context);
  }

  @override
  void initState() {
    listStudentProvider = Provider.of<ListStudentProvider>(context, listen: false);
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    listStudentProvider.disposeList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _body(context)
        )
      ),
      bottomNavigationBar: SafeArea(child: _saveButton(context)),
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      height: AppMainsize.mainHeight(context),
      padding: EdgeInsets.only(bottom: footerHeight+10),
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
                _timeBar(context)
              ],
            )
          ),

          Expanded(
            child: Consumer<ListStudentProvider>(
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
                          itemCount: value.lstStudentFilter.length,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: StudentItem(student: value.lstStudentFilter[index], isConnect: widget.isConnect,),
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

  Widget _saveButton(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      padding: const EdgeInsets.all(10),
      color: AppColors.pageBackground,
      child: GestureDetector(
        onTap: isSaving? null:
        () async{
          setState(() {
            isSaving = true;
          });

          await RollCallControll().handleSaveListRollCall(context);

          setState(() {
            isSaving = false;
          });
        },
        child: Container(
          width: double.infinity,
          height: footerHeight,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: isSaving? const Stack(children: [Center(child: CircularProgressIndicator(color: Colors.white,),)],):
          Center(
            child: Text(
              AppLocalizations.of(context).translate("save_rollcall"),
              style: AppTextstyle.subWhiteTitleStyle,
            ),
          ),
        ),
      )
    );
  }

  Widget _searchBar(BuildContext context){
    return Consumer<ListStudentProvider>(
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

  Widget _timeBar(BuildContext context){
    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          height: 100,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 55, 
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _dropdownButton(value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dropdownButton(ListStudentProvider provider) {
    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return DropdownButton<String>(
          value: provider.timeName,
          icon: const Icon(Icons.arrow_downward_rounded, size: 25, color: Colors.grey),
          elevation: 16,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(20),
          style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
          onChanged: (String? currentValue) {
            setState(() {
              provider.timeName = currentValue!;
              MyTime time = value.lstTime.firstWhere((time) => time.name == provider.timeName);
              provider.filterListTimeID(time.id!);
            });
          },
          items: value.lstTime.map<DropdownMenuItem<String>>(
            (MyTime time) {
              return DropdownMenuItem<String>(
                value: time.name,
                child: Text(
                  time.name!,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

}