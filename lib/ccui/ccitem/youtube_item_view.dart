

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/connection/check_connection.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/loading/loading_big_container.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeItemView extends StatefulWidget {
  final String videoUrl;

  const YoutubeItemView({super.key, required this.videoUrl});

  @override
  State<YoutubeItemView> createState() => _YoutubeItemViewState();
}

class _YoutubeItemViewState extends State<YoutubeItemView> {
  late WebViewController _controller;
  bool isValidUrl = false;
  bool isLoading = true;
  bool hasError = false;
  bool hasErrorLostConnect = false;

  Future<void> initControll(String videoUrl) async{
    try {
      if (isValidYoutubeUrl(videoUrl)) {
        isValidUrl = true;
        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(_formattedVideoUrl(videoUrl)))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                setState(() {
                  isLoading = true;
                  hasError = false; 
                });
              },
              onPageFinished: (_) {
                setState(() {
                  isLoading = false; 
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  hasError = true; 
                  isLoading = false; 
                });
              },
            ),
          );
        
        hasErrorLostConnect = !await ConnectionService().checkConnect();
        setState(() {});

      } else {
        isValidUrl = false;
        hasError = true; 
      }
    } catch (e) {
      setState(() {
        hasError = true; 
        isLoading = false;
      });
    }

  }

  bool isValidYoutubeUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.host == 'www.youtube.com' || uri.host == 'youtu.be') &&
        uri.pathSegments.isNotEmpty &&
        (uri.queryParameters.containsKey('v') || uri.host == 'youtu.be');
  }

  String _formattedVideoUrl(String url) {
    final uri = Uri.parse(url);
    final videoId = uri.queryParameters['v'] ?? '';
    return "https://www.youtube.com/embed/$videoId?autoplay=1&controls=1";
  }

  @override
  void initState() {
    super.initState();
    initControll(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant YoutubeItemView oldWidget) {
    if (oldWidget.videoUrl != widget.videoUrl) {
      initControll(widget.videoUrl);
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if(hasErrorLostConnect) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate("error_connect_lost"),
          textAlign: TextAlign.center,
          style: AppTextstyle.subRedTitleStyle,
        ),
      );
    }

    if(hasError){
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: AppMainsize.mainWidth(context),
      height: 250,
      child: Shimmer(
        linearGradient: shimmerGradient,
        child: isLoading?
          ShimmerLoading(isLoading: isLoading, child: LoadingBigContainerView(width: AppMainsize.mainWidth(context), height: 250)):
          ShimmerLoading(isLoading: isLoading, child: WebViewWidget(controller: _controller)),
      )
    );
  }
}

