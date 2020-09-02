import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:congorna/src/styles/button.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/base.dart';

class SocialButton extends StatelessWidget {
  final SocialButtonType socialButtonType;
  final void Function() onPressed;
  final void Function() onTap;

  SocialButton({@required this.socialButtonType, this.onPressed, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color iconColor;
    IconData icon;

    switch (socialButtonType) {
      case SocialButtonType.Facebook:
        iconColor = Colors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebookF;
        break;

      case SocialButtonType.Google:
        iconColor = Colors.white;
        buttonColor = AppColors.google;
        icon = FontAwesomeIcons.instagram;
        break;

      default:
        iconColor = Colors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebookF;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ButtonStyles.buttonHeight,
        width: ButtonStyles.buttonHeight,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
            boxShadow: BaseStyles.boxShadow),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}

enum SocialButtonType { Facebook, Google }
