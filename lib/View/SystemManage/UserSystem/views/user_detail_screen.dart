import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late SystemViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    // _model.getInvoiceDetail(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<SystemViewModel>(
        builder: (context, child, model) {
      return Container();
    });
  }
}
