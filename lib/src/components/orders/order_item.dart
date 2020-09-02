import 'package:congorna/src/models/order.dart';
import 'package:congorna/src/styles/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/utils/screenconfig.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key key,
    this.iconSrc,
    this.title,
    this.onPressed,
    this.isIOS,
    this.hintText,
    this.materialIcon,
    this.cupertinoIcon,
    this.textInputType,
    this.obscureText,
    this.onChange,
    this.errorText,
    this.initialText,
  }) : super(key: key);

  final String iconSrc, title;
  final Function onPressed;
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChange;
  final String errorText;
  final String initialText;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
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
