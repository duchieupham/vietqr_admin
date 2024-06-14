import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/root_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class PinWidget extends StatefulWidget {
  final double width;
  final double pinSize;
  final int pinLength;
  final FocusNode focusNode;
  final Function(String) onDone;
  const PinWidget({
    super.key,
    required this.width,
    required this.pinSize,
    required this.pinLength,
    required this.focusNode,
    required this.onDone,
  });

  @override
  State<PinWidget> createState() => _PinWidgetState();
}

class _PinWidgetState extends State<PinWidget> {
  late RootViewModel _model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model = Get.find<RootViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: _model,
        child: ScopedModelDescendant<RootViewModel>(
          builder: (context, child, model) {
            return Stack(
              children: [
                Container(
                  width: widget.width,
                  height: widget.pinSize + 5,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: widget.pinLength,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return UnconstrainedBox(
                        child: Container(
                          width: widget.pinSize,
                          height: widget.pinSize,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.pinSize),
                            color: (model.pinLength < index + 1)
                                ? AppColor.TRANSPARENT
                                : AppColor.BLUE_TEXT,
                            border: Border.all(
                              width: 2,
                              color: AppColor.BLUE_TEXT,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                TextField(
                  focusNode: widget.focusNode,
                  obscureText: true,
                  maxLength: widget.pinLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  showCursor: false,
                  decoration: const InputDecoration(
                    counterStyle: TextStyle(
                      height: 0,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: AppColor.TRANSPARENT),
                  keyboardType: TextInputType.number,
                  onChanged: ((text) {
                    model.updatePinLength(text.length);
                    if (text.length == widget.pinLength) {
                      widget.focusNode.unfocus();
                      // model.reset();
                    }
                    widget.onDone(text);
                  }),
                ),
              ],
            );
          },
        ));
  }
}
