import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/filter_bank_button.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/widgets/list_bank_system_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';
import 'package:vietqr_admin/models/DTO/metadata_dto.dart';

enum Actions {
  copy,
}

class BankSystemScreen extends StatefulWidget {
  const BankSystemScreen({super.key});

  @override
  State<BankSystemScreen> createState() => _BankSystemScreenState();
}

class _BankSystemScreenState extends State<BankSystemScreen> {
  TextEditingController _textController = TextEditingController(text: '');
  late SystemViewModel _model;
  int type = 1;
  int _choiceChipSelected = 0;
  int pageSize = 20;
  late ScrollController controllerHorizontal;
  late ScrollController controller1;
  late ScrollController controller2;
  bool isScrollingDown1 = false;
  bool isScrollingDown2 = false;

  List<FilterBankSystem> listFilter = [
    FilterBankSystem(title: 'Thời gian kích hoạt DV', type: 1),
    FilterBankSystem(title: 'Thêm gần đây', type: 2),
  ];

  FilterBankSystem filterSelect =
      FilterBankSystem(title: 'Thời gian kích hoạt DV', type: 1);

  List<ChoiceChipItem> listChoiceChips = [
    ChoiceChipItem(title: 'Số TK', value: 0),
    ChoiceChipItem(title: 'Chủ TK', value: 1),
    ChoiceChipItem(title: 'SĐT xác thực', value: 2),
    ChoiceChipItem(title: 'CCCD/CMND', value: 3),
  ];

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    initController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() {
    _model.filterListBank(
        size: pageSize,
        type: type,
        value: '',
        searchType: (_choiceChipSelected + 3));
  }

  void initController() {
    controller1 = ScrollController();
    controller2 = ScrollController();
    controllerHorizontal = ScrollController();
    controller1.addListener(() {
      if (!isScrollingDown2) {
        isScrollingDown1 = true;
        controller2.jumpTo(controller1.offset);
      }
      isScrollingDown1 = false;
    });

    controller2.addListener(() {
      if (!isScrollingDown1) {
        isScrollingDown2 = true;
        controller1.jumpTo(controller2.offset);
      }
      isScrollingDown2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: ScopedModel<SystemViewModel>(
        model: _model,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              const Divider(
                color: AppColor.GREY_DADADA,
              ),
              Expanded(
                child: _bodyWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lọc theo:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.BLACK.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _choiceChip(),
                  _filter(),
                  _filterWidget(),
                  // _buildList(),
                  ListBankSystemWidget(
                    pageSize: pageSize,
                  ),
                  const MySeparator(color: AppColor.GREY_DADADA),
                  _pagingWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.GREY_DADADA))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...listFilter.map(
                (e) {
                  bool isSelect = filterSelect.type == e.type;
                  return FilterBankSystemButton(
                    text: e.title,
                    isSelect: isSelect,
                    onTap: () {
                      setState(() {
                        filterSelect = e;
                        _textController = TextEditingController();
                        type = e.type;
                      });
                      // _model.changeTypeInvoice(0);

                      _model.filterListBank(
                          size: pageSize,
                          page: 1,
                          type: type,
                          value: '',
                          searchType: (_choiceChipSelected + 3));
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tìm kiếm theo:",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Wrap(
                    spacing: 4.0,
                    children: List<Widget>.generate(
                      4,
                      (int index) {
                        return ChoiceChip(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          selectedColor: Colors.transparent,
                          side: const BorderSide(color: Colors.transparent),
                          backgroundColor: Colors.transparent,
                          showCheckmark: false,
                          label: Container(
                            decoration: BoxDecoration(
                              gradient: _choiceChipSelected == index
                                  ? VietQRTheme.gradientColor.brightBlueLinear
                                  : null,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                _choiceChipSelected == index
                                    ? Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Center(
                                            child: Icon(
                                          Icons.check,
                                          color: AppColor.BLUE_TEXT,
                                          size: 15,
                                        )),
                                      )
                                    : const SizedBox.shrink(),
                                Text(
                                  listChoiceChips[index].title,
                                  style: TextStyle(
                                    color: _choiceChipSelected == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          selected: _choiceChipSelected == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _choiceChipSelected = (selected ? index : null)!;
                            });
                            _model.filterListBank(
                                size: pageSize,
                                type: type,
                                searchType: (_choiceChipSelected + 3));
                          },
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 280,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.GREY_DADADA)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 260,
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: _choiceChipSelected != 1
                                      ? TextInputType.number
                                      : TextInputType.name,
                                  inputFormatters: [
                                    _choiceChipSelected != 1
                                        ? FilteringTextInputFormatter.digitsOnly
                                        : FilteringTextInputFormatter.allow(
                                            RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                                  ],
                                  onSubmitted: (value) {
                                    if (value == '') {
                                      _model.filterListBank(
                                          type: type,
                                          size: pageSize,
                                          value: value,
                                          searchType:
                                              (_choiceChipSelected + 3));
                                    } else {
                                      _model.filterListBank(
                                          type: type,
                                          searchType: (_choiceChipSelected + 3),
                                          size: pageSize,
                                          value: value);
                                    }
                                  },
                                  onChanged: (value) {
                                    _textController.value = TextEditingValue(
                                      text: value,
                                      selection: TextSelection.collapsed(
                                          offset: value.length),
                                    );
                                    setState(() {});
                                  },
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 6),
                                    border: InputBorder.none,
                                    hintText:
                                        'Tìm kiếm theo ${_choiceChipSelected == 0 ? 'số tài khoản' : _choiceChipSelected == 1 ? 'chủ tài khoản' : _choiceChipSelected == 2 ? 'SĐT xác thực' : 'CCCD/CMND'}',
                                    hintStyle: const TextStyle(
                                        fontSize: 13,
                                        color: AppColor.GREY_TEXT),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 15,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          _textController.clear();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: AppColor.GREY_TEXT,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: () {
              if (_textController.text == '') {
                _model.filterListBank(
                    type: type,
                    size: pageSize,
                    value: _textController.text,
                    searchType: (_choiceChipSelected + 3));
              } else {
                _model.filterListBank(
                    type: type,
                    searchType: (_choiceChipSelected + 3),
                    size: pageSize,
                    value: _textController.text);
              }
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: AppColor.WHITE,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tìm kiếm',
                    style: TextStyle(fontSize: 15, color: AppColor.WHITE),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagingWidget() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        bool isPaging = false;
        if (model.status == ViewStatus.Loading ||
            model.status == ViewStatus.Error) {
          return const SizedBox.shrink();
        }

        if (model.metadata != null) {
          MetaDataDTO paging = model.metadata!;
          if (paging.page! != paging.totalPage!) {
            isPaging = true;
          }
          double indexTotal =
              paging.page != 1 ? ((pageSize * paging.page!) / 2) + 1 : 1;
          int totalOfCurrentPage = (pageSize * paging.page!) > paging.total!
              ? paging.total!
              : pageSize * paging.page!;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Số hàng:',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 15),
                Container(
                    width: 50,
                    height: 25,
                    padding: const EdgeInsets.fromLTRB(5, 2, 7, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      isDense: true,
                      value: pageSize,
                      borderRadius: BorderRadius.circular(10),
                      // dropdownColor: AppColor.WHITE,
                      underline: const SizedBox.shrink(),
                      iconSize: 12,
                      elevation: 16,
                      dropdownColor: Colors.white,

                      icon: const RotatedBox(
                        quarterTurns: 5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColor.GREY_TEXT,
                          size: 10,
                        ),
                      ),
                      items: <int>[20, 50, 100]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return [20, 50, 100].map<Widget>((int item) {
                          return Text(
                            item.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            pageSize = value;
                          });
                        }
                        _model.filterListBank(
                            size: pageSize,
                            type: type,
                            searchType: (_choiceChipSelected + 3));
                      },
                    )),
                const SizedBox(width: 30),
                Text(
                  '$indexTotal-$totalOfCurrentPage của ${paging.total}',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () async {
                    if (paging.page != 1) {
                      await _model.filterListBank(
                          page: paging.page! - 1,
                          type: type,
                          size: pageSize,
                          searchType: (_choiceChipSelected + 3),
                          value: _textController.text);
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 25,
                    color: paging.page != 1
                        ? AppColor.BLACK
                        : AppColor.GREY_TEXT.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () async {
                    if (isPaging) {
                      await _model.filterListBank(
                          size: pageSize,
                          page: paging.page! + 1,
                          searchType: (_choiceChipSelected + 3),
                          type: type,
                          value: _textController.text);
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 25,
                    color: isPaging
                        ? AppColor.BLACK
                        : AppColor.GREY_TEXT.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _headerWidget() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 30, 10),
          // width: MediaQuery.of(context).size.width *
          //     (model.pageType == PageInvoice.LIST ? 0.22 : 0.33),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: const Row(
                      children: [
                        Text(
                          "Quản lý hệ thống",
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "   /   ",
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "Quản lý tài khoản ngân hàng",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ScopedModelDescendant<SystemViewModel>(
                builder: (context, child, model) {
                  int nearlyExpireCount = 0;
                  int overdueCount = 0;
                  int validCount = 0;
                  int notRegisteredCount = 0;

                  if (filterSelect.type == 1 && model.bankSystemDTO != null) {
                    nearlyExpireCount =
                        model.bankSystemDTO!.extraData.nearlyExpireCount;
                    overdueCount = model.bankSystemDTO!.extraData.overdueCount;
                    validCount = model.bankSystemDTO!.extraData.validCount;
                    notRegisteredCount =
                        model.bankSystemDTO!.extraData.notRegisteredCount;
                  }
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'TK sắp hết hạn:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                nearlyExpireCount.toString(),
                                style: const TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'TK quá hạn:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                StringUtils.formatNumberWithOutVND(
                                    overdueCount),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.ORANGE_DARK),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(width: 35),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'TK đã thêm:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                validCount.toString(),
                                style: const TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'TK đã liên kết:',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                StringUtils.formatNumberWithOutVND(
                                    notRegisteredCount),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.GREEN),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onCopy({required BankSystemItem dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getBankSharing(dto)).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Colors.black,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
  }
}

class FilterBankSystem {
  String title;
  int type;

  FilterBankSystem({required this.title, required this.type});
}

class ChoiceChipItem {
  final String title;
  final int value;

  ChoiceChipItem({required this.title, required this.value});
}
