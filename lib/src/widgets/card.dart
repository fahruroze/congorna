import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:congorna/src/styles/base.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';

class AppCard extends StatelessWidget {
  final String jasaName;
  final double jasaHarga;
  // final int jasaUnit;
  final String jasaServices;
  final String jasaTimes;
  final String note;
  final String jasaImage;
  final DateTime createdAt;

  // final String createdBy;

  final formatPrice = NumberFormat.simpleCurrency(locale: "id_IDR");

  AppCard({
    @required this.jasaName,
    @required this.jasaHarga,
    // @required this.jasaUnit,
    @required this.jasaServices,
    @required this.jasaTimes,
    this.note = "",
    this.jasaImage,
    this.createdAt,
    // this.createdBy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: BaseStyles.listPadding,
      padding: BaseStyles.listPadding,
      decoration: BoxDecoration(
          boxShadow: BaseStyles.boxShadow,
          color: Colors.white,
          border: Border.all(
            color: AppColors.purpleViolet,
            width: BaseStyles.borderWidth,
          ),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, bottom: 10.0, top: 10.0),
                  child: ClipRRect(
                    // child: Image.network(
                    //   jasaImage,
                    //   height: 100.0,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: jasaImage,
                      height: 100.0,
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/add.png",
                        height: 100.0,
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  )
                  // : Image.asset(
                  //     'assets/images/Unyellowing.jpeg',
                  //     height: 100.0,
                  //   ),
                  ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(jasaName, style: TextStyles.subtitle),
                  Text('${formatPrice.format(jasaHarga)}',
                      style: TextStyles.body),
                  Text(
                    jasaTimes,
                    style: TextStyles.body,
                  ),
                  (jasaHarga != null)
                      ? Text('Buka', style: TextStyles.bodyBlue)
                      : Text('Tutup', style: TextStyles.bodyRed)
                ],
              )
            ],
          ),
          Text(
            note,
            style: TextStyles.body,
          )
        ],
      ),
    );
  }
}
