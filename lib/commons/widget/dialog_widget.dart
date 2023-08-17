import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/main.dart';

class DialogWidget {
  //
  const DialogWidget._privateConstructor();
  static const DialogWidget _instance = DialogWidget._privateConstructor();
  static DialogWidget get instance => _instance;

  static bool isPopLoading = false;

  openContentDialog(
    VoidCallback? onClose,
    Widget child,
  ) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: 400,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child,
              ),
            ),
          );
        });
  }

  Future showFullModalBottomContent({
    BuildContext? context,
    required Widget widget,
  }) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false, // Ngăn người dùng kéo ModalBottomSheet
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: widget,
          );
        });
  }

  Future showModalBottomContent(
      {BuildContext? context,
      required Widget widget,
      required double height}) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false, // Ngăn người dùng kéo ModalBottomSheet
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: keyboardHeight,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: height + keyboardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: widget,
                ),
              ),
            ),
          );
        });
  }

  void openLoadingDialog() async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: NavigationService.navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: DefaultTheme.TRANSPARENT,
              child: Center(
                  child: Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: DefaultTheme.GREEN,
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Text(
                      'Đang tải',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  openMsgDialog(
      {required String title,
      required String msg,
      VoidCallback? function,
      BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
                child:
                    // (PlatformUtils.instance.isWeb())
                    //     ?
                    Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic-warning.png',
                    width: 80,
                    height: 80,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  ButtonWidget(
                    width: 250,
                    height: 40,
                    text: 'Đóng',
                    textColor: DefaultTheme.WHITE,
                    bgColor: DefaultTheme.GREEN,
                    borderRadius: 5,
                    function: (function != null)
                        ? function
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )),
          );
        });
  }

  openMsgSuccessDialog(
      {required String title,
      String? msg,
      VoidCallback? function,
      BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
                child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (msg != null) ...[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  ButtonWidget(
                    width: 250,
                    height: 35,
                    text: 'Đóng',
                    textColor: DefaultTheme.WHITE,
                    bgColor: DefaultTheme.GREEN,
                    borderRadius: 5,
                    function: (function != null)
                        ? function
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )),
          );
        });
  }

  openPopup(
      {required Widget child,
      required double width,
      required double height,
      Color barrierColor = Colors.black54}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      barrierColor: barrierColor,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
              child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          )),
        );
      },
    );
  }

  openWidgetDialog({required Widget child}) {
    final BuildContext context = NavigationService.navigatorKey.currentContext!;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
              child: Container(
            width: 800,
            height: 600,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          )),
        );
      },
    );
  }

  openTransactionDialog(String address, String body) {
    final ScrollController _scrollContoller = ScrollController();
    return showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              width: 325,
              height: 450,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  const Text(
                    'Giao dịch mới',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Từ: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            'Nội dung: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.GREY_TEXT,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          height: 250,
                          child: SingleChildScrollView(
                            controller: _scrollContoller,
                            child: Text(
                              body,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: DefaultTheme.GREEN,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: DefaultTheme.WHITE,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future showModelBottomSheet(
      {BuildContext? context,
      required Widget widget,
      required double height}) async {
    context ??= NavigationService.navigatorKey.currentContext!;
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      context: context,
      backgroundColor: DefaultTheme.TRANSPARENT,
      builder: (context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: ClipRRect(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: keyboardHeight,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: height + keyboardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                ),
                child: widget,
              ),
            ),
          ),
        );
      },
    );
  }

  openMsgDialogQuestion(
      {required String title,
      required String msg,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
      BuildContext? context}) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
                child: Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic-warning.png',
                    width: 80,
                    height: 80,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          width: 250,
                          height: 40,
                          text: 'Đóng',
                          textColor: DefaultTheme.GREEN,
                          bgColor: DefaultTheme.WHITE,
                          borderRadius: 5,
                          function: (onCancel != null)
                              ? onCancel
                              : () {
                                  Navigator.pop(context);
                                },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonWidget(
                          width: 250,
                          height: 40,
                          text: 'Xác nhận',
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.GREEN,
                          borderRadius: 5,
                          function: (onConfirm != null)
                              ? onConfirm
                              : () {
                                  Navigator.pop(context);
                                },
                        ),
                      ),
                    ],
                  ),

                  // const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            )),
          );
        });
  }
}
