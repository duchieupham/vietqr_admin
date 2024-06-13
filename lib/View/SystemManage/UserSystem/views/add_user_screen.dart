import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.height,
      child: Stack(
        children: [
          _bodyWidget(),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 120),
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
