import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';

class DialogSelectBankType extends StatefulWidget {
  const DialogSelectBankType({
    super.key,
    required this.list,
    this.isSearch = false,
    this.searchType,
    this.noData,
  });

  final String? noData;
  final String? searchType;
  final bool isSearch;
  final List<BankTypeDTO> list;
  @override
  State<DialogSelectBankType> createState() => _DialogSelectBankTypeState();
}

class _DialogSelectBankTypeState extends State<DialogSelectBankType> {
  final TextEditingController controller = TextEditingController();

  List<BankTypeDTO> data = [];

  bool isFilter = false;

  @override
  void initState() {
    data = widget.list;

    setState(() {});

    super.initState();
  }

  bool get isShort => widget.list.isNotEmpty && widget.list.length < 5;

  @override
  Widget build(BuildContext context) {
    var widgetContents = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 25,
          // ),
          // const DefaultTextStyle(
          //   style: TextStyle(
          //     color: AppColor.BLACK,
          //     fontSize: 15,
          //     fontWeight: FontWeight.normal,
          //   ),
          //   child: Text(
          //     'Kết quà tìm kiếm',
          //   ),
          // ),
          Flexible(
            child: ListView.separated(
                // shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  BankTypeDTO dto = data[index];
                  return InkWell(
                    onTap: () => _onSelect(dto),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColor.GREY_DADADA),
                                image: DecorationImage(
                                  image: ImageUtils.instance
                                      .getImageNetWork(data[index].imageId),
                                )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.BLACK,
                                  ),
                                  child: Text(
                                    dto.bankShortName!,
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.GREY_TEXT),
                                  child: Text(
                                    dto.bankName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: AppColor.BLUE_TEXT,
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const MySeparator(
                      color: AppColor.GREY_DADADA,
                    ),
                itemCount: data.length),
          ),
        ],
      ),
    );
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          width: 700,
          height: 700,
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      child: Text(
                        'Chọn ngân hàng',
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  (data.isEmpty && widget.noData != null)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 10,
                          ),
                          child: Text(
                            widget.noData!,
                            // style: tvStyle,
                          ),
                        )
                      : widgetContents,

                  if (widget.isSearch)
                    Material(
                      color: AppColor.WHITE,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: controller,
                          onChanged: onSearch,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            hintText: 'Tìm kiếm ngân hàng',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: AppColor.GREY_TEXT),
                            prefixIcon: IconButton(
                              onPressed: null,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.search,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSearch(String value) {
    if (value.isNotEmpty) {
      isFilter = true;
    } else {
      isFilter = false;
    }
    data = widget.list;
    List<BankTypeDTO> values = [];
    List<BankTypeDTO> listMaps = [...data];
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto.bankCode.toUpperCase().contains(value.toUpperCase()) ||
              dto.bankName.toUpperCase().contains(value.toUpperCase()) ||
              dto.bankShortName!.toUpperCase().contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    data = values;
    setState(() {});
  }

  _onSelect(BankTypeDTO dto) {
    // final index = widget.list.indexOf(dto);
    Navigator.of(context).pop(dto);
  }
}
