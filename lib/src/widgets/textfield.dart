import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:congorna/src/styles/textfield.dart';
import 'package:congorna/src/styles/text.dart';

class AppTextField extends StatefulWidget {
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChange;
  final String errorText;
  final String initialText;

  AppTextField(
      {@required this.isIOS,
      @required this.hintText,
      @required this.cupertinoIcon,
      @required this.materialIcon,
      this.initialText,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.onChange,
      this.errorText});

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
            horizontal: TextFieldStyles.TextBoxHorizontal,
            vertical: TextFieldStyles.TextBoxVertical),
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              keyboardType: widget.textInputType,
              padding: EdgeInsets.all(12.0),
              placeholder: "Email",
              placeholderStyle: TextFieldStyles.placeHolder,
              style: TextFieldStyles.text,
              textAlign: TextFieldStyles.textAlign,
              cursorColor: TextFieldStyles.cursorColor,
              decoration: (displayCupertinoErrorBorder)
                  ? TextFieldStyles.cupertinoErrorDecoration()
                  : TextFieldStyles.cupertinoDecoration(),
              prefix: TextFieldStyles.iconPrefix(widget.cupertinoIcon),
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
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: TextFieldStyles.TextBoxHorizontal,
            vertical: TextFieldStyles.TextBoxVertical),
        child: TextField(
          keyboardType: widget.textInputType,
          cursorColor: TextFieldStyles.cursorColor,
          style: TextFieldStyles.text,
          textAlign: TextFieldStyles.textAlign,
          obscureText: widget.obscureText,
          decoration: TextFieldStyles.materialDecoration(
              widget.hintText, widget.materialIcon, widget.errorText),
          controller: _controller,
          onChanged: widget.onChange,
        ),
      );
    }
  }
}
