import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'custom_shape.dart';

class InfoProfile extends StatelessWidget {
  const InfoProfile({
    Key key,
    this.name,
    this.email,
    this.image,
    this.numberPhone,
  }) : super(key: key);
  final String name, email, image, numberPhone;

  @override
  Widget build(BuildContext context) {
    double defaultSize = ScreenConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 24,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 15,
              color: AppColors.purpleViolet,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(100),
                //   child: CachedNetworkImage(
                //     imageUrl: image,
                //     progressIndicatorBuilder:
                //         (context, url, downloadProgress) =>
                //             CircularProgressIndicator(
                //                 value: downloadProgress.progress),
                //     errorWidget: (context, url, error) => Padding(
                //       padding: EdgeInsets.only(bottom: defaultSize),
                //       child: Image.asset(
                //         "aseets/images/pic.png",
                //         height: defaultSize * 14,
                //         width: defaultSize * 14,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(bottom: defaultSize),
                  height: defaultSize * 14,
                  width: defaultSize * 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: defaultSize * 0.5),
                    image: DecorationImage(
                      //   // fit: BoxFit.cover, image: AssetImage(image))),
                      fit: BoxFit.cover,

                      // image: FadeInImage.assetNetwork(
                      //   placeholder: 'assets/images/pic.png',
                      //   image: image,
                      // ),

                      // image: Image.network(
                      //   image,
                      // ),
                      image: NetworkImage(
                        image,
                      ),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: defaultSize * 2.2, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: defaultSize * 2.2,
                  ),
                ),
                // Text(
                //   numberPhone,
                //   style: TextStyle(
                //     fontSize: defaultSize * 2.2,
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
