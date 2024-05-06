import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_admin/ViewModel/annualFee_viewModel.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/ViewModel/serviceFee_viewModel.dart';
import 'package:vietqr_admin/ViewModel/system_transaction_viewModel.dart';
import 'package:vietqr_admin/ViewModel/userRecharge_viewModel.dart';
import 'package:vietqr_admin/models/DAO/AnnualDAO.dart';

void createRouteBindings() async {
  Get.put(MerchantViewModel());
  Get.put(ServiceFeeViewModel());
  Get.put(SystemTransactionViewModel());
  Get.put(AnnualFeeAfterViewModel());
  Get.put(UserRechargeViewModel());
}
