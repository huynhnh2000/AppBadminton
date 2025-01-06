
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

List<String> splitContentByKeywords(String text, List<String> keywords) {
  List<String> result = [text];
    
  for (String keyword in keywords) {
    List<String> temp = [];
      
    for (String part in result) {

      // If contain keyword then split it
      if (part.contains(keyword)) {
        List<String> splitParts = part.split(keyword);

        for (int i = 0; i < splitParts.length; i++) {
          temp.add(splitParts[i]);
          if (i < splitParts.length - 1) temp.add(keyword);
        }
      } 
      else {
        temp.add(part);
      }
    }
      
    result = temp;
  }
    
  return result;
}

Widget firstParagraph(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "${AppLocalizations.of(context).translate("wellcome_title")} ",
          style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
        ),
        TextSpan(
          text: AppLocalizations.of(context).translate("title_name"),
          style: AppTextstyle.subTitleStyle.copyWith(fontWeight: FontWeight.bold, wordSpacing: 5),
        ),
        TextSpan(
          text: ".",
          style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
        ),
      ],
    ),
  );
}

Widget secondParagraph(BuildContext context) {
  List<InlineSpan> lstStyle = [];
  String content = AppLocalizations.of(context).translate("wellcome_content_1_1");
  List<String> keywords = [
    AppLocalizations.of(context).translate("wellcome_content_1_2"),
    AppLocalizations.of(context).translate("wellcome_content_1_3")
  ];

  List<String> lstString3 = splitContentByKeywords(content, keywords);

  for (String text in lstString3) {
    if (keywords.contains(text)) {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(fontWeight: FontWeight.bold, wordSpacing: 5),
        ),
      );
    } else {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
        ),
      );
    }
  }
  lstStyle.add(
    TextSpan(
      text: ".",
      style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
    ),
  );

  return RichText(
    text: TextSpan(
      children: lstStyle,
    ),
  );
}

Widget thirdParagraph(BuildContext context) {
  List<InlineSpan> lstStyle = [];
  String content = AppLocalizations.of(context).translate("wellcome_content_2_1");
  List<String> keywords = [
    AppLocalizations.of(context).translate("wellcome_content_2_2"),
    AppLocalizations.of(context).translate("wellcome_content_2_3")
  ];

  List<String> lstString3 = splitContentByKeywords(content, keywords);

  for (String text in lstString3) {
    if (text == keywords[0]) {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary, wordSpacing: 5),
        ),
      );
    } else if (text == keywords[1]) {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(fontWeight: FontWeight.bold, wordSpacing: 5),
        ),
      );
    } else {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
        ),
      );
    }
  }
  lstStyle.add(
    TextSpan(
      text: ".",
      style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
    ),
  );

  return RichText(
    text: TextSpan(
      children: lstStyle,
    ),
  );
}

Widget fourthParagraph(BuildContext context) {
  List<InlineSpan> lstStyle = [];
  String content = AppLocalizations.of(context).translate("wellcome_content_3_1");
  List<String> keywords = [
    AppLocalizations.of(context).translate("wellcome_content_3_2"),
  ];

  List<String> lstString3 = splitContentByKeywords(content, keywords);

  for (String text in lstString3) {
    if (keywords.contains(text)) {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(fontWeight: FontWeight.bold, wordSpacing: 5),
        ),
      );
    } else {
      lstStyle.add(
        TextSpan(
          text: text,
          style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
        ),
      );
    }
  }
  lstStyle.add(
    TextSpan(
      text: ".",
      style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
    ),
  );

  return RichText(
    text: TextSpan(
      children: lstStyle,
    ),
  );
}

Widget fifthParagraph(BuildContext context) {
  List<InlineSpan> lstStyle = [];
  String content = AppLocalizations.of(context).translate("wellcome_content_4_1");

  lstStyle.add(
    TextSpan(
      text: content,
      style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
    ),
  );
  lstStyle.add(
    TextSpan(
      text: ".",
      style: AppTextstyle.subTitleStyle.copyWith(wordSpacing: 5),
    ),
  );

  return RichText(
    text: TextSpan(
      children: lstStyle,
    ),
  );
}