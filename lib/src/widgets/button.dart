import 'package:flutter/material.dart';
import 'package:congorna/src/styles/base.dart';
import 'package:congorna/src/styles/button.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({@required this.buttonText, this.buttonType, this.onPressed});

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.Brown:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.brown;
        break;

      case ButtonType.Lightblue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;

      case ButtonType.Disable:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.purpleS;
        break;

      case ButtonType.Login:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.thirdColor;
        break;

      case ButtonType.Register:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.purpleViolet;
        break;

      default:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: (pressed)
            ? BaseStyles.listFieldVertical + BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        bottom: (pressed)
            ? BaseStyles.listFieldVertical - BaseStyles.animationOffset
            : BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal,
      ),
      child: GestureDetector(
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: ButtonStyles.buttonWidth,
          // width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
              boxShadow:
                  pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow),
          child: Center(
              child: Text(
            widget.buttonText,
            style: fontStyle,
          )),
        ),
        onTapDown: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.Disable) pressed = !pressed;
          });
        },
        onTapUp: (details) {
          if (widget.buttonType != ButtonType.Disable) pressed = !pressed;
        },
        onTap: () {
          if (widget.buttonType != ButtonType.Disable) {
            widget.onPressed();
          }
        },
      ),
      duration: Duration(milliseconds: 20),
    );
  }
}

enum ButtonType {
  Register,
  Login,
  Lightblue,
  Brown,
  Disable,
  DarkGray,
  DarkBlue
}
