import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final Function() callback;
  final Function() onUpdate;
  const UpdateUserScreen({
    super.key,
    required this.userId,
    required this.callback,
    required this.onUpdate,
  });

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _midtNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _nationalController = TextEditingController();
  final TextEditingController _nationalDateController = TextEditingController();

  final TextEditingController _oldNationalController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  late SystemViewModel _model;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    const pattern = r'^[^@]+@[^@]+\.[^@]+';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    _model.getUserDetail(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: context.width,
        child: Stack(
          children: [
            _bodyWidget(),
            // Positioned(bottom: 0, left: 0, child: _bottom())
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        UserInfo? dto;
        if (model.status == ViewStatus.Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (model.userInfo != null && model.status != ViewStatus.Error) {
          dto = model.userInfo!;
          _emailController.text = dto.email;
          _firstNameController.text = dto.firstName;
          _midtNameController.text = dto.middleName;
          _lastNameController.text = dto.lastName;
          _nationalController.text = dto.nationalId;
          _nationalDateController.text = dto.nationalDate;
          _oldNationalController.text = dto.oldNationalId;
          _addressController.text = dto.address;
        }
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: widget.callback,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'Cập nhật thông tin người dùng',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (dto != null)
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SĐT đăng nhập VietQR*',
                          style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          color: AppColor.GREY_DADADA,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dto.phoneNo,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('Email', style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [EmailInputFormatter()],

                          // maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập email ở đây',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('Họ và tên', style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                          ],

                          onChanged: (value) {
                            // checkIsEnable();
                          },

                          // maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập Họ',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _midtNameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                          ],

                          onChanged: (value) {
                            // checkIsEnable();
                          },

                          // maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập Tên Đệm',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                          ],

                          onChanged: (value) {
                            // checkIsEnable();
                          },

                          // maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập Tên',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
