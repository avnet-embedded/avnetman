import 'package:bonfire/state_manager/bonfire_injector.dart';
import 'package:flutter/material.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScanDialog extends StatefulWidget {
  const ScanDialog({Key? key}) : super(key: key);

  @override
  State<ScanDialog> createState() => _ScanDialogState();

  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const ScanDialog();
      },
    );
  }
}

class _ScanDialogState extends State<ScanDialog> {
  late GameState _state;

  @override
  void initState() {
    _state = BonfireInjector.instance.get();
    _state.addListener(_listener);
    super.initState();
  }

  void _listener() {
    if (!_state.scanOn) {
      _state.removeListener(_listener);
      Future.delayed(const Duration(seconds: 2), () {
        _state.reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.black);

    Widget procChild;
    Widget rawChild;
    if (!_state.hasLastScanProc) {
      procChild = LoadingAnimationWidget.fourRotatingDots(
        color: const Color.fromARGB(178, 0x81, 0xc7, 0x84),
        size: MediaQuery.of(context).size.width * 0.15,
      );
    } else {
      procChild = Image.memory(_state.lastScanProc,
          height: MediaQuery.of(context).size.width * 0.15, fit: BoxFit.fill);
    }

    if (!_state.hasLastScanRaw) {
      rawChild = LoadingAnimationWidget.fourRotatingDots(
        color: const Color.fromARGB(178, 0x81, 0xc7, 0x84),
        size: MediaQuery.of(context).size.width * 0.15,
      );
    } else {
      rawChild = Image.memory(_state.lastScanRaw,
          height: MediaQuery.of(context).size.width * 0.15, fit: BoxFit.fill);
    }

    return Focus(
        autofocus: true,
        child: Center(
            heightFactor: 0.7,
            widthFactor: 0.7,
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Please put your business card under our scanner',
                          style: textStyle.copyWith(
                              fontSize: 26, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Image.asset("assets/images/scanner_info.png",
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.fill),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              rawChild,
                              const SizedBox(width: 20),
                              procChild,
                              const SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(
                                  _state.lastTextResult,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle.copyWith(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ])
                      ],
                    )))));
  }
}
