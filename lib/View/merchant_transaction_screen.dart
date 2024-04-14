import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/instance_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class MerchantTransactionScreen extends StatefulWidget {
  const MerchantTransactionScreen({super.key});

  @override
  State<MerchantTransactionScreen> createState() =>
      _MerchantTransactionScreenState();
}

class _MerchantTransactionScreenState extends State<MerchantTransactionScreen> {
  late MerchantViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<MerchantViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_TEXT.withOpacity(0.3),
      body: ScopedModel(
          model: _model,
          child: ScopedModelDescendant<MerchantViewModel>(
            builder: (context, child, model) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Thống kê",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "/",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Thống kê giao dịch",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tìm kiếm thông tin ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Tìm kiếm theo ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColor.GREY_DADADA)),
                              child: Row(
                                children: [
                                  DropdownButton<int>(
                                    value: model.type,
                                    underline: const SizedBox.shrink(),
                                    icon: const RotatedBox(
                                      quarterTurns: 5,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem<int>(
                                          value: 0,
                                          child: Text(
                                            "Tên đại lý",
                                          )),
                                      DropdownMenuItem<int>(
                                          value: 1,
                                          child: Text(
                                            "Mã VSO",
                                          )),
                                      DropdownMenuItem<int>(
                                          value: 2,
                                          child: Text(
                                            "Mã doanh nghiệp/MST",
                                          )),
                                    ],
                                    onChanged: (value) {
                                      model.changeType(value);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
