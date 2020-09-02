import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:congorna/src/styles/jasa_detail_style.dart';
import 'package:congorna/src/styles/text.dart';

class JasaDetail extends StatefulWidget {
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChange;
  final String errorText;
  final String initialText;

  JasaDetail(
      {this.isIOS,
      this.hintText,
      this.cupertinoIcon,
      this.materialIcon,
      this.initialText,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.onChange,
      this.errorText});

  @override
  _JasaDetailState createState() => _JasaDetailState();
}

class _JasaDetailState extends State<JasaDetail> {
  FocusNode _node;
  bool displayCupertinoErrorBorder;
  TextEditingController _controller;

  @override
  void initState() {
    _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialText != null) _controller.text = widget.initialText;
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder = false;
    super.initState();
  }

  void _handleFocusChange() {
    if (_node.hasFocus == false && widget.errorText != null) {
      displayCupertinoErrorBorder = true;
    } else {
      displayCupertinoErrorBorder = false;
    }

    widget.onChange(_controller.text);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIOS) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: JasaDetailStyles.TextBoxHorizontal,
            vertical: JasaDetailStyles.TextBoxVertical),
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              keyboardType: widget.textInputType,
              padding: EdgeInsets.all(12.0),
              placeholder: "Email",
              placeholderStyle: JasaDetailStyles.placeHolder,
              style: JasaDetailStyles.text,
              textAlign: JasaDetailStyles.textAlign,
              cursorColor: JasaDetailStyles.cursorColor,
              decoration: (displayCupertinoErrorBorder)
                  ? JasaDetailStyles.cupertinoErrorDecoration()
                  : JasaDetailStyles.cupertinoDecoration(),
              prefix: JasaDetailStyles.iconPrefix(widget.cupertinoIcon),
              obscureText: widget.obscureText,
              onChanged: widget.onChange,
              focusNode: _node,
            ),
            (widget.errorText != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text(widget.errorText, style: TextStyles.error)
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      );
    } else {
      return ListTile();
      // return Padding(
      //   padding: EdgeInsets.symmetric(
      //       horizontal: JasaDetailStyles.TextBoxHorizontal,
      //       vertical: JasaDetailStyles.TextBoxVertical),
      //       child: ListTile(

      //       ),
      //   // child: TextField(
      //   //   // keyboardType: widget.textInputType,
      //   //   // cursorColor: JasaDetailStyles.cursorColor,
      //   //   style: JasaDetailStyles.text,
      //   //   // textAlign: JasaDetailStyles.textAlign,
      //   //   obscureText: widget.obscureText,
      //   //   // decoration: JasaDetailStyles.materialDecoration(
      //   //   //     widget.hintText, widget.materialIcon, widget.errorText),
      //   //   controller: _controller,
      //   //   onChanged: widget.onChange,
      //   //   enabled: false,
      //   // ),
      // );
    }
  }
}
