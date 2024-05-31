import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/feature/log/bloc/log_bloc.dart';
import 'package:vietqr_admin/feature/log/provider/log_provider.dart';

import '../../commons/constants/utils/time_utils.dart';
import 'event/log_event.dart';
import 'state/log_state.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  StreamSubscription? _subscription;
  bool envGoLive = false;
  late LogBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = LogBloc()..add(const LogGetListEvent(date: ''));
    _subscription = eventBus.on<RefreshLog>().listen((data) {
      if (!data.envGoLive) {
        _bloc.add(const LogGetListEvent(date: ''));
      }

      updateEnv(data.envGoLive);
    });
  }

  updateEnv(bool value) {
    setState(() {
      envGoLive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogBloc>(
      create: (BuildContext context) => _bloc,
      child: ChangeNotifierProvider<LogProvider>(
        create: (context) => LogProvider()..init(),
        child: Column(
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration:
                  BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
              child: Row(
                children: [
                  const Text(
                    'LOG',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Consumer<LogProvider>(builder: (context, provider, child) {
                    return InkWell(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: provider.currentDate,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2040),
                        );
                        if (TimeUtils.instance.getCurrentDate(date) ==
                            TimeUtils.instance.getCurrentDate(DateTime.now())) {
                          _bloc.add(const LogGetListEvent(date: ''));
                        } else {
                          _bloc.add(LogGetListEvent(
                              date: TimeUtils.instance.getCurrentDate(date)));
                        }

                        provider.changeDate(date ?? DateTime.now());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.GREY_BG,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Chọn ngày',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              provider.dateTime,
                              style: const TextStyle(fontSize: 11),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Expanded(
                child: BlocConsumer<LogBloc, LogState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (envGoLive) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text('Đang bảo trì'),
                        );
                      }

                      if (state is LogLoadingState) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text('Đang tải ...'),
                        );
                      }
                      if (state is GetLogSuccessState) {
                        if (state.result.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text('Không có dữ liệu'),
                          );
                        }
                        return ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          children: state.result.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SelectableText(
                                e,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    }))
          ],
        ),
      ),
    );
  }
}
