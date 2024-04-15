import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/ViewModel/system_transaction_viewModel.dart';
import 'package:vietqr_admin/feature/merchant/views/merchant.dart';

import '../../../service/shared_references/session.dart';

void createRouteBindings() async {
  Get.put(MerchantViewModel());
  Get.put(SystemTransactionViewModel());
}
