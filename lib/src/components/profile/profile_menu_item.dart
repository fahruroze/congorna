import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/utils/screenconfig.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key key,
    this.iconSrc,
    this.title,
    this.onPressed,
  }) : super(key: key);
  final String iconSrc, title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    double defaultSize = ScreenConfig.defaultSize;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2, vertical: defaultSize * 0.5),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                iconSrc,
                height: ScreenConfig.defaultSize * 2,
              ),
              SizedBox(
                width: defaultSize * 2,
              ),
              Text(title, style: TextStyles.normal),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: defaultSize * 2,
                color: AppColors.darkgray,
              )
            ],
          ),
        ),
      ),
    );
  }
}
