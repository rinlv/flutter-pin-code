/*
 * flutter_pin_code
 * Created by rin.lv
 * https://www.linkedin.com/in/hnrinlv/
 *
 * Copyright (c) 2019 Rin.LV, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code/src/single_pin_view.dart';
import 'bloc.dart';

class PinCodeView extends StatefulWidget {
  final Widget title;
  final Widget subTitle;
  final String errorMsg;
  final VoidCallback onSuccess;
  final int length;
  final int correctPin;
  final Color bgColor;
  final Color textColor;
  final Color normalColor;
  final Color selectedColor;

  const PinCodeView({Key key,
    this.title,
    this.subTitle,
    this.errorMsg,
    this.onSuccess,
    this.correctPin = 0,
    this.length = 4,
    this.bgColor = Colors.white,
    this.textColor = Colors.white,
    this.normalColor = Colors.black45,
    this.selectedColor = Colors.blue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatePinCodeView();
}

class _StatePinCodeView extends State<PinCodeView> {
  PinCodeViewBloc _pinCodeViewBloc;

  @override
  void initState() {
    _pinCodeViewBloc = PinCodeViewBloc(widget.length, widget.correctPin);
    super.initState();
  }

  @override
  void dispose() {
    _pinCodeViewBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is SuccessPinCodeState) {
          widget.onSuccess();
          return;
        }
      },
      bloc: _pinCodeViewBloc,
      child: BlocBuilder(
        bloc: _pinCodeViewBloc,
        builder: (context, state) {
          int selLength = 0;
          bool hasError = false;
          if (state is SelectedPinCodeState) {
            selLength = state.selLength;
            hasError = state.hasError;
          }
          return Container(
            color: widget.bgColor,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                widget.title,
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 40,
                    child: Center(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SinglePinView(
                            normalColor: widget.normalColor,
                            selectedColor: widget.selectedColor,
                            hasValue: index < selLength,
                          );
                        },
                        itemCount: widget.length,
                      ),
                    )),
                Flexible(
                    child: Visibility(
                      visible: hasError,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          widget.errorMsg,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                widget.subTitle,
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 3,
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: <Widget>[
                        buildButtonNumber(1),
                        buildButtonNumber(2),
                        buildButtonNumber(3),
                        buildButtonNumber(4),
                        buildButtonNumber(5),
                        buildButtonNumber(6),
                        buildButtonNumber(7),
                        buildButtonNumber(8),
                        buildButtonNumber(9),
                        Container(),
                        buildButtonNumber(0),
                        buildContainerIcon(Icons.backspace),
                      ],
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButtonNumber(int number) {
    return FlatButton(
      color: widget.normalColor,
      onPressed: () {
        _pinCodeViewBloc.dispatch(InputPinCodeEvent(number));
      },
      child: Container(
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: widget.textColor),
          ),
        ),
      ),
    );
  }

  Widget buildContainerIcon(IconData iconData) {
    return FlatButton(
      color: Colors.white,
      onPressed: () {
        _pinCodeViewBloc.dispatch(DeletePinCodeEvent());
      },
      child: Container(
        child: Center(
          child: Icon(
            iconData,
            size: 30,
            color: widget.normalColor,
          ),
        ),
      ),
    );
  }
}