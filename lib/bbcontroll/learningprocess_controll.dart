// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/template/message_template.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_youtube_video.dart';
import 'package:badminton_management_1/bbdata/online/learning_process_api.dart';
import 'package:badminton_management_1/bbdata/online/youtube_html.dart';
import 'package:badminton_management_1/ccui/ccitem/learning_process_coach_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';

class LearningProcessControll {

  final MessageHandler messageHandler = MessageHandler();
  
  Future<void> handleGetLearningProcess(BuildContext context, MyStudent student) async{
    try{
      MyLearningProcess? learningProcess = await LearningProcessApi().getLearningProcess(student.id!, DateTime.now().toIso8601String());
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=>LearningProcessItem(student: student, learningProcess: learningProcess, isNullLP: learningProcess==null,)
        )
      );
    } 
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    } 
  }

  Future<MyLearningProcess> setYoutubeVideoLP(MyLearningProcess lp) async {
    String videoTitle = "Loading...";
    String imageUrl = "";

    videoTitle = await fetchVideoTitle(lp.linkWeb ?? "");
    imageUrl = await getVideoThumbnailUrl(lp.linkWeb ?? "");

    lp.youtubeVideo = MyYoutubeVideo(
      url: lp.linkWeb,
      videoTitle: videoTitle,
      imageUrl: imageUrl,
    );

    return lp;
  }

  Future<MyLearningProcess> handleCheckForAddUpdate(BuildContext context, MyLearningProcess? lp, MyStudent student) async{
    try{
      // MyLearningProcess? mylp = await LearningProcessApi().getLearningProcess(student.id!, lp.dateCreated);
      if(lp?.id!=null){lp?.savedLP();}
      if(lp?.isAlreadyAdd==null){
        await handleAddLearningProcess(context, lp!);
        lp.savedLP();
      }
      else{
        // lp.id = mylp.id;
        // lp.dateCreated = mylp.dateCreated;
        lp?.dateUpdated = DateTime.now().toIso8601String();
        if(lp?.id==null){
          lp = await LearningProcessApi().getLearningProcess(student.id!, lp?.dateCreated);
        }
        await handleUpdateLearningProcess(context, lp!);
      }
      return lp;
    }
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
      return MyLearningProcess();
    }
  }

  Future<void> handleUpdateLearningProcess(BuildContext context, MyLearningProcess lp) async{
    try{
      if(lp.comment=="" || lp.title==""){
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_empty_inputlp"));
        return;
      }
      else{
        await messageHandler.handleAction(
          context, 
          () => LearningProcessApi().updateProcess(lp), 
          "learningprocess_success", 
          "learningprocess_error"
        );
      }
    }
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    }
  }

  Future<void> handleAddLearningProcess(BuildContext context, MyLearningProcess lp) async{
    try{
      if(lp.comment=="" || lp.title==""){
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_empty_inputlp"));
        return;
      }
      else{
        await messageHandler.handleAction(
          context, 
          () => LearningProcessApi().addProcess(lp), 
          "learningprocess_success", 
          "learningprocess_error"
        );
      }
    }
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    }
  } 

  
}