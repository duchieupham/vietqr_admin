import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/feature/integration_connectivity/new_connect/new_connect_screen.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';

import 'add_user_screen.dart';

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
  final TextEditingController _midNameController = TextEditingController();
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

  List<Gender> listGender = [
    Gender('Nam', 0, false),
    Gender('Nữ', 1, false),
  ];

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  void initData() async {
    await _model.getUserDetail(widget.userId);
    if (_model.userInfo != null) {
      _emailController.text = _model.userInfo!.email;
      _firstNameController.text = _model.userInfo!.firstName;
      _midNameController.text = _model.userInfo!.middleName;
      _lastNameController.text = _model.userInfo!.lastName;
      _nationalController.text = _model.userInfo!.nationalId;
      _nationalDateController.text = _model.userInfo!.nationalDate;
      _oldNationalController.text = _model.userInfo!.oldNationalId;
      _addressController.text = _model.userInfo!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: context.width,
        child: Stack(
          children: [
            _bodyWidget(),
            Positioned(bottom: 0, left: 0, child: _bottom())
          ],
        ),
      ),
    );
  }

  Widget _bottom() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        return MButtonWidget(
          isEnable: true,
          colorDisableBgr: AppColor.GREY_DADADA,
          colorEnableBgr: AppColor.BLUE_TEXT,
          onTap: () {
            UserInfo dto = UserInfo(
                id: widget.userId,
                address: _addressController.text,
                fullName: '',
                status: true,
                firstName: _firstNameController.text,
                middleName: _midNameController.text,
                lastName: _lastNameController.text,
                email: _emailController.text,
                nationalId: _nationalController.text,
                phoneNo: '',
                oldNationalId: _oldNationalController.text,
                nationalDate: _nationalDateController.text,
                gender: model.selectGender!.type!);
            model.updateUser(dto).then(
              (value) {
                if (value == true) {
                  model.getUserDetail(widget.userId).whenComplete(
                    () {
                      _emailController.text = _model.userInfo!.email;
                      _firstNameController.text = model.userInfo!.firstName;
                      _midNameController.text = model.userInfo!.middleName;
                      _lastNameController.text = model.userInfo!.lastName;
                      _nationalController.text = model.userInfo!.nationalId;
                      _nationalDateController.text =
                          model.userInfo!.nationalDate;
                      _oldNationalController.text =
                          model.userInfo!.oldNationalId;
                      _addressController.text = model.userInfo!.address;
                    },
                  );
                }
              },
            );
          },
          title: 'Xác nhận',
          width: 350,
          height: 50,
        );
      },
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          controller: _midNameController,
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
                      const Text('Giới tính', style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      model.selectGender != null
                          ? SizedBox(
                              height: 60,
                              width: 350,
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  bool isSelect = model.selectGender!.type ==
                                      listGender[index].type;

                                  return SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelect,
                                          onChanged: (value) {
                                            model.genderUpdate(
                                                listGender[index]);
                                          },
                                          shape: const CircleBorder(),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          listGender[index].gender!,
                                          style: const TextStyle(fontSize: 13),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 50,
                                ),
                                itemCount: listGender.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CCCD', style: TextStyle(fontSize: 13)),
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
                          controller: _nationalController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]"))
                          ],
                          onChanged: (value) {},
                          maxLength: 12,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          // maxLines: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập căn cước công dân ở đây',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('Ngày cấp CCCD',
                          style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _nationalDateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [DateInputFormatter()],
                          onChanged: (value) {},
                          maxLength: 12,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          // maxLines: 1,
                          decoration: const InputDecoration(
                              counterText: '',
                              contentPadding:
                                  EdgeInsets.only(bottom: 10, top: 5),
                              border: InputBorder.none,
                              hintText: 'Nhập ngày cấp',
                              hintStyle: TextStyle(
                                  fontSize: 13, color: AppColor.GREY_TEXT),
                              suffixIcon: Icon(
                                FontAwesomeIcons.calendarDays,
                                size: 15,
                              )),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('CMND cũ', style: TextStyle(fontSize: 13)),
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
                          controller: _oldNationalController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]")),
                          ],

                          onChanged: (value) {
                            // _oldNationalController.value.copyWith(text: value);
                            setState(() {});
                          },

                          // maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập CMND cũ ở đây',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text('Địa chỉ', style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 80,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppColor.GREY_DADADA),
                        ),
                        child: TextField(
                          controller: _addressController,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$'))
                          ],
                          onChanged: (value) {},
                          maxLines: 80,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 10, top: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập địa chỉ ở đây',
                            hintStyle: TextStyle(
                                fontSize: 13, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
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
