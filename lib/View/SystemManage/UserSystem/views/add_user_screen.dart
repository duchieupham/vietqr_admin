import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/root_viewModel.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/encrypt_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/input_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/pin_widget.dart';
import 'package:vietqr_admin/feature/integration_connectivity/new_connect/new_connect_screen.dart';
import 'package:vietqr_admin/models/DTO/create_user_dto.dart';

class AddUserScreen extends StatefulWidget {
  final Function() callback;
  final Function(CreateUserDTO) onCreate;

  const AddUserScreen({
    super.key,
    required this.callback,
    required this.onCreate,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _midNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _nationalController = TextEditingController();
  final TextEditingController _nationalDateController = TextEditingController();

  final TextEditingController _oldNationalController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  List<Gender> listGender = [
    Gender('Nam', 0, true),
    Gender('Nữ', 1, false),
  ];
  Gender selectGender = Gender('Nam', 0, true);

  int inputLength = 0;
  int passLength = 0;

  bool isEnable = false;

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
    Get.find<RootViewModel>().reset();
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

  Widget _bodyWidget() {
    return ScopedModelDescendant<SystemViewModel>(
      builder: (context, child, model) {
        return ListView(
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
                    'Tạo mới người dùng',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SĐT đăng nhập VietQR* ($inputLength/10 ký tự số)',
                        style: const TextStyle(fontSize: 13)),
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
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          inputLength = value.length;
                          checkIsEnable();
                          setState(() {});
                        },
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        // maxLines: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.only(bottom: 10),
                          border: InputBorder.none,
                          hintText: 'Nhập số điện thoại',
                          hintStyle: TextStyle(
                              fontSize: 13, color: AppColor.GREY_TEXT),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text('Mật khẩu* ($passLength/6 ký tự số)',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      height: 40,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.GREY_DADADA),
                      ),
                      alignment: Alignment.center,
                      child: PinWidget(
                        width: 350,
                        pinSize: 15,
                        pinLength: 6,
                        focusNode: focusNode,
                        onDone: (text) {
                          passLength = text.length;
                          _passController.value = TextEditingValue(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: text.length),
                          );
                          checkIsEnable();

                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Nhập ký tự số.',
                        style: TextStyle(fontSize: 10)),
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

                        onChanged: (value) {},

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
                          checkIsEnable();
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
                          checkIsEnable();
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
                          checkIsEnable();
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
                    SizedBox(
                      height: 60,
                      width: 350,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Checkbox(
                                value: listGender[index].isSelect,
                                onChanged: (value) {
                                  for (var g in listGender) {
                                    g.isSelect =
                                        g.type == listGender[index].type;
                                  }
                                  selectGender = listGender[index];
                                  setState(() {});
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
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 50,
                        ),
                        itemCount: listGender.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
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
                    const Text('Ngày cấp CCCD', style: TextStyle(fontSize: 13)),
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
                            contentPadding: EdgeInsets.only(bottom: 10, top: 5),
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
                          contentPadding: EdgeInsets.only(bottom: 10, top: 10),
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

  Widget _bottom() {
    return MButtonWidget(
      isEnable: isEnable,
      colorDisableBgr: AppColor.GREY_DADADA,
      colorEnableBgr: AppColor.BLUE_TEXT,
      onTap: isEnable
          ? () {
              CreateUserDTO dto = CreateUserDTO(
                  phoneNo: _phoneController.text,
                  password: EncryptUtils.instance.encrypted(
                    _phoneController.text,
                    _passController.text,
                  ),
                  email: _emailController.text,
                  firstName: _firstNameController.text,
                  middleName: _midNameController.text,
                  lastName: _lastNameController.text,
                  address: _addressController.text,
                  gender: selectGender.type.toString(),
                  nationalId: _nationalController.text,
                  oldNationalId: _oldNationalController.text,
                  nationalDate: _nationalDateController.text);
              widget.onCreate(dto);
            }
          : null,
      title: 'Xác nhận',
      width: 350,
      height: 50,
    );
  }

  void checkIsEnable() {
    if (_phoneController.text.isNotEmpty &&
        _passController.text.isNotEmpty &&
        (_emailController.text.isNotEmpty ||
            _firstNameController.text.isNotEmpty ||
            _midNameController.text.isNotEmpty ||
            _lastNameController.text.isNotEmpty)) {
      isEnable = true;
    } else {
      isEnable = false;
    }
    setState(() {});
  }
}

class Gender {
  String? gender;
  int? type;
  bool? isSelect;

  Gender(this.gender, this.type, this.isSelect);
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final newText = _formatDate(text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatDate(String text) {
    // Remove non-numeric characters
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length >= 5 && text.length <= 6) {
      text = '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4, 6)}';
    } else if (text.length >= 7) {
      text = '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4, 8)}';
    } else if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2, 4)}';
    }

    return text;
  }
}
