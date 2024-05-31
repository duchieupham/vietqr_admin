import 'package:get/instance_manager.dart';
import 'package:vietqr_admin/ViewModel/annualFee_viewModel.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/ViewModel/merchant_viewModel.dart';
import 'package:vietqr_admin/ViewModel/qr_box_viewModel.dart';
import 'package:vietqr_admin/ViewModel/serviceFee_viewModel.dart';
import 'package:vietqr_admin/ViewModel/system_transaction_viewModel.dart';
import 'package:vietqr_admin/ViewModel/userRecharge_viewModel.dart';

void createRouteBindings() async {
  Get.put(MerchantViewModel());
  Get.put(ServiceFeeViewModel());
  Get.put(SystemTransactionViewModel());
  Get.put(AnnualFeeAfterViewModel());
  Get.put(UserRechargeViewModel());
  Get.put(InvoiceViewModel());
  Get.put(QrBoxViewModel());
}
