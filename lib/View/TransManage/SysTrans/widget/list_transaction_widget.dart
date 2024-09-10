// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:linked_scroll_controller/linked_scroll_controller.dart';
// import 'package:vietqr_admin/View/TransManage/SysTrans/bloc/transaction_bloc.dart';
// import 'package:vietqr_admin/View/TransManage/SysTrans/state/transaction_state.dart';
// import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
// import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
// import 'package:vietqr_admin/models/DTO/transaction_dto.dart';

// // ignore: must_be_immutable
// class ListTransactionWidget extends StatefulWidget {
//   int pageSize;
//   ListTransactionWidget({
//     super.key,
//     required this.pageSize,
//   });

//   @override
//   State<ListTransactionWidget> createState() => _ListTransactionWidgetState();
// }

// class _ListTransactionWidgetState extends State<ListTransactionWidget> {
//   late LinkedScrollControllerGroup _linkedScrollControllerGroup;
//   late ScrollController _horizontal;
//   late ScrollController _vertical;
//   late ScrollController _vertical2;
//   List<TransactionDTO> transactionList = [];
//   bool isCalling = true;
//   // ignore: unused_field

//   @override
//   void initState() {
//     super.initState();
//     _linkedScrollControllerGroup = LinkedScrollControllerGroup();

//     _vertical = _linkedScrollControllerGroup.addAndGet();
//     _vertical2 = _linkedScrollControllerGroup.addAndGet();

//     _horizontal = ScrollController();
//   }

//   @override
//   void dispose() {
//     _vertical.dispose();
//     _vertical2.dispose();
//     _horizontal.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<TransactionBloc, TransactionState>(
//       listener: (context, state) {
//         if (state is TransactionGetListLoadingState) {
//           DialogWidget.instance.openLoadingDialog();
//         }
//         if (state is TransactionGetListSuccessState) {
//           if (state.isLoadMore) {
//             transactionList.addAll(state.result);
//             if (state.result.isNotEmpty) {
//               isCalling = true;
//             }
//           } else {
//             if (state.isPopLoading) {
//               Navigator.pop(context);
//             }
//             transactionList = state.result;
//           }
//         }
//       },
//       builder: (context, state) {
//         if (state is TransactionLoadingState) {
//           return const Padding(
//             padding: EdgeInsets.only(top: 40),
//             child: Center(child: Text('Đang tải...')),
//           );
//         }
//         List<Widget> buildItemList(
//             List<BankSystemItem>? list, MetaDataDTO metadata) {
//           if (list == null || list.isEmpty) {
//             return [];
//           }

//           return list
//               .asMap()
//               .map((index, e) {
//                 int calculatedIndex =
//                     index + ((metadata.page! - 1) * widget.pageSize);
//                 return MapEntry(
//                     index,
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ItemBankWidget(
//                           dto: e,
//                           index: calculatedIndex,
//                         ),
//                         if (index + 1 != list.length)
//                           const SizedBox(
//                               width: 1520,
//                               child: MySeparator(color: AppColor.GREY_DADADA)),
//                       ],
//                     ));
//               })
//               .values
//               .toList();
//         }

//         return Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return Stack(
//                 children: [
//                   Positioned.fill(
//                     right: 150,
//                     child: SizedBox(
//                       width: 1520,
//                       child: RawScrollbar(
//                         thumbVisibility: true,
//                         controller: _horizontal,
//                         child: ScrollConfiguration(
//                           behavior: MyCustomScrollBehavior(),
//                           child: SingleChildScrollView(
//                             physics: const ClampingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             controller: _horizontal,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // TitleItemBankWidget(
//                                 //     width: constraints.maxWidth),
//                                 const TitleItemBankWidget(),
//                                 if (model.status == ViewStatus.Loading)
//                                   Expanded(
//                                     child: Container(
//                                       width: constraints.maxWidth,
//                                       alignment: Alignment.center,
//                                       child: const CircularProgressIndicator(),
//                                     ),
//                                   )
//                                 else if (model.bankSystemDTO != null)
//                                   Expanded(
//                                       child: ScrollConfiguration(
//                                     behavior: ScrollConfiguration.of(context)
//                                         .copyWith(scrollbars: false),
//                                     child: SingleChildScrollView(
//                                       controller: _vertical,
//                                       physics: const ClampingScrollPhysics(),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           ...buildItemList(
//                                               model.bankSystemDTO!.items,
//                                               model.metadata!)
//                                         ],
//                                       ),
//                                     ),
//                                   ))
//                                 else
//                                   const SizedBox.shrink()
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 1740,
//                     child: Row(
//                       children: [
//                         const Expanded(child: SizedBox()),
//                         // const Spacer(),
//                         // SizedBox(width: constraints.maxWidth),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AppColor.WHITE,
//                             boxShadow: [
//                               BoxShadow(
//                                   color: AppColor.BLACK.withOpacity(0.1),
//                                   blurRadius: 5,
//                                   spreadRadius: 1,
//                                   offset: const Offset(-1, 0)),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Container(
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: AppColor.BLUE_TEXT.withOpacity(0.3),
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                         height: 40,
//                                         width: 120,
//                                         alignment: Alignment.center,
//                                         child: const Text(
//                                           'Trạng thái',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: AppColor.BLACK,
//                                               fontWeight: FontWeight.bold),
//                                         )),
//                                     Container(
//                                         height: 40,
//                                         width: 100,
//                                         alignment: Alignment.center,
//                                         child: const Text(
//                                           'Thao tác',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: AppColor.BLACK,
//                                               fontWeight: FontWeight.bold),
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                               if (model.status == ViewStatus.Loading)
//                                 const SizedBox.shrink()
//                               else if (model.bankSystemDTO != null)
//                                 Expanded(
//                                     child: SingleChildScrollView(
//                                   controller: _vertical2,
//                                   physics: const ClampingScrollPhysics(),
//                                   child: Column(
//                                     children: [
//                                       ...model.bankSystemDTO!.items.map(
//                                         (e) {
//                                           return Column(
//                                             children: [
//                                               _rightItem(e),
//                                               // if (index + 1 != list.length)
//                                               const SizedBox(
//                                                   width: 220,
//                                                   child: MySeparator(
//                                                       color: AppColor
//                                                           .GREY_DADADA)),
//                                             ],
//                                           );
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 ))
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _rightItem(BankSystemItem e) {
//     return Container(
//       alignment: Alignment.center,
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(right: 10),
//             alignment: Alignment.center,
//             height: 40,
//             width: 120,
//             child: SelectionArea(
//                 child: Text(
//               !e.status ? 'Chưa liên kết' : 'Đã liên kết',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: !e.status ? AppColor.ORANGE_DARK : AppColor.GREEN_STATUS,
//               ),
//             )),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             alignment: Alignment.centerLeft,
//             // decoration: BoxDecoration(
//             //   // border: Border(
//             //   //   // left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
//             //   //   bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
//             //   //   right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)),
//             //   // ),
//             // ),
//             height: 40,
//             width: 100,
//             child: Row(
//               children: [
//                 const SizedBox(width: 4),
//                 PopupMenuButton<Actions>(
//                   padding: const EdgeInsets.all(0),
//                   onSelected: (Actions result) {
//                     switch (result) {
//                       case Actions.copy:
//                         onCopy(dto: e);
//                         break;
//                       case Actions.detail:
//                         onDetail(dto: e);
//                         break;
//                       // case Actions.check:
//                       //   onCheckActiveKey(dto: e);
//                       //   break;
//                     }
//                   },
//                   itemBuilder: (BuildContext context) => _buildMenuItems(e),
//                   icon: Container(
//                     width: 30,
//                     height: 30,
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: AppColor.BLUE_TEXT.withOpacity(0.3),
//                     ),
//                     child: const Icon(
//                       size: 18,
//                       Icons.more_vert,
//                       color: AppColor.BLUE_TEXT,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 if (e.bankCode == 'MB' || e.bankCode == 'BIDV')
//                   Tooltip(
//                     message: 'Check LOG',
//                     child: InkWell(
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return PopupCheckLogWidget(
//                               dto: e,
//                               bankAccount: e.phoneNo,
//                             );
//                           },
//                         );
//                       },
//                       child: BoxLayout(
//                         width: 30,
//                         height: 30,
//                         borderRadius: 100,
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(0),
//                         bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
//                         child: const Icon(
//                           Icons.lightbulb_outline,
//                           size: 12,
//                           color: AppColor.BLUE_TEXT,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void onCopy({required BankSystemItem dto}) async {
//     await FlutterClipboard.copy(ShareUtils.instance.getBankSharing(dto)).then(
//       (value) => Fluttertoast.showToast(
//         msg: 'Đã sao chép',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Theme.of(context).cardColor,
//         textColor: Colors.black,
//         fontSize: 15,
//         webBgColor: 'rgba(255, 255, 255)',
//         webPosition: 'center',
//       ),
//     );
//   }

//   void onDetail({required BankSystemItem dto}) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return PopupBankDetailWidget(
//           dto: dto,
//         );
//       },
//     );
//   }

//   // void onCheckActiveKey({required BankSystemItem dto}) async {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return PopupCheckKeyWidget(
//   //         dto: dto,
//   //       );
//   //     },
//   //   );
//   // }

//   List<PopupMenuEntry<Actions>> _buildMenuItems(BankSystemItem e) {
//     List<PopupMenuEntry<Actions>> items = [
//       const PopupMenuItem<Actions>(
//         value: Actions.copy,
//         child: Text('Copy'),
//       ),
//       PopupMenuItem<Actions>(
//         value: Actions.detail,
//         child: e.validService
//             ? const Text('Gia hạn Key')
//             : const Text('Kích hoạt Key'),
//       ),
//       // const PopupMenuItem<Actions>(
//       //   value: Actions.check,
//       //   child: Text('Kiểm tra Key'),
//       // ),
//     ];
//     return items;
//   }
// }
