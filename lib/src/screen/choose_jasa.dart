import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:congorna/src/app.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/blocs/jasa_bloc.dart';
import 'package:congorna/src/blocs/order_bloc.dart';
import 'package:congorna/src/models/jasa.dart';
import 'package:congorna/src/models/order.dart';
import 'package:congorna/src/styles/base.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/widgets/appstate.dart';
// import 'package:congorna/src/widgets/appstate.dart';
import 'package:congorna/src/widgets/button.dart';
import 'package:congorna/src/widgets/card.dart';
import 'package:congorna/src/widgets/dropdown_button.dart';
import 'package:congorna/src/widgets/jasa_detail.dart';
import 'package:congorna/src/widgets/orders2.dart';
import 'package:congorna/src/widgets/sliver_scaffold.dart';
import 'package:congorna/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class ChooseJasa extends StatefulWidget {
  final String jasaId;

  ChooseJasa({this.jasaId});
  final formatPrice =
      NumberFormat.simpleCurrency(locale: "id_IDR"); // format Rupiah

  @override
  _ChooseJasaState createState() => _ChooseJasaState();
}

final choooseJasaScaffoldKey = GlobalKey<ScaffoldState>();

class _ChooseJasaState extends State<ChooseJasa> {
  @override
  void initState() {
    var jasaBloc = Provider.of<JasaBloc>(context, listen: false);
    var orderBloc = Provider.of<OrderBloc>(context, listen: false); //i
    // final appState = Provider.of<AppState>(context);
    orderBloc.orderSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
            msg: "Jasa Saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: AppColors.purpleViolet,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var jasaBloc = Provider.of<JasaBloc>(context);
    var orderBloc = Provider.of<OrderBloc>(context);

    var authBloc = Provider.of<AuthBloc>(context);

    final appState = Provider.of<AppState>(context);

    return FutureBuilder<Jasa>(
      future: jasaBloc.fetchJasa(widget.jasaId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.jasaId != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Order Detail',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator()),
          );
        }

        Jasa existingJasa;
        print("existingJasa");
        // print(existingJasa);

        if (widget.jasaId != null) {
          //EDIT logic
          existingJasa = snapshot.data;

          loadValues(
            orderBloc, jasaBloc, existingJasa, authBloc.mahasiswaId,
            // jasaBloc.jasaId,
          );
        } else {
          //ADD logic
          loadValues(orderBloc, jasaBloc, null, authBloc.mahasiswaId
              // jasaBloc.jasaId,
              );
        }

        return (Platform.isIOS)
            ? AppSliverScaffold.cupertinoSliverScaffold(
                navTitle: '',
                pageBody:
                    pageBody(true, jasaBloc, orderBloc, context, existingJasa),
                context: context)
            : AppSliverScaffold.materialSliverScaffold(
                navTitle: 'Pemesanan',
                navBottom: StreamBuilder<bool>(
                    stream: jasaBloc.isValid,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: BaseStyles.listPadding,
                        child: AppButton(
                            buttonType: ButtonType.Brown,
                            // buttonType: (snapshot.data == true)
                            //     ? ButtonType.Brown
                            //     : ButtonType.Disable,
                            buttonText: 'Order',
                            onPressed: () => [
                                  orderBloc.saveOrder(context: context),
                                  orderBloc.getPelangganLocation()
                                ]),
                      );
                    }),
                pageBody:
                    pageBody(false, jasaBloc, orderBloc, context, existingJasa),
                context: context);

        // return pageBody(false, jasaBloc, orderBloc, context, existingJasa);
      },
    );
  }

  Widget pageBody(bool isIOS, JasaBloc jasaBloc, OrderBloc orderBloc,
      BuildContext context, Jasa existingJasa) {
    var items = Provider.of<List<String>>(context);

    var pageLabel = (existingJasa != null) ? 'Order Detail' : 'Order Detail';
    // final appState = Provider.of<AppState>(context);
    // appState.getUserLocation();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Alamat",
                  style: TextStyles.subtitle,
                )
              ],
            ),
            Divider(
              color: AppColors.darkblue,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/images/map.png',
                      )),
                  flex: 2,
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Jl. lohbener baru no.4 Polindra, Blok Celeng Kab Indramayu',
                          style: TextStyles.navTitle,
                        ),
                        FlatButton(onPressed: () {}, child: Icon(Icons.edit))
                      ],
                    ))
              ],
            ),

            // Padding(
            //   padding: BaseStyles.listPadding,
            //   child: Divider(color: AppColors.darkblue),
            // ),
            Text(
              pageLabel,
              style: TextStyles.subtitle,
              textAlign: TextAlign.left,
            ),
            // Padding(
            //   padding: BaseStyles.listPadding,
            //   child: Divider(color: AppColors.darkblue),
            // ),
            Divider(
              color: AppColors.darkblue,
            ),
            StreamBuilder<bool>(
              stream: jasaBloc.isUploading,
              builder: (context, snapshot) {
                return (!snapshot.hasData || snapshot.data == false)
                    ? Container()
                    : Center(
                        child: (Platform.isIOS)
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(),
                      );
              },
            ),
            StreamBuilder<String>(
                stream: jasaBloc.jasaImage,
                builder: (context, snapshot) {
                  // if (snapshot.hasData || snapshot.data != null)
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: CachedNetworkImage(
                                    imageUrl: existingJasa != null
                                        ? existingJasa.jasaImage
                                        : null,
                                    // existingJasa.jasaImage ? existingJasa.jasaImage : "",
                                    height: 100,
                                    width: 110,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/add.png",
                                      height: 100,
                                      width: 110,
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                StreamBuilder<String>(
                                  stream: jasaBloc.jasaName,
                                  builder: (context, snapshot) {
                                    orderBloc.changeJasaName;
                                    return Text(
                                      existingJasa != null
                                          ? existingJasa.jasaName
                                          : null,
                                      style: TextStyles.subOnBoardText,
                                    );
                                  },
                                ),
                                StreamBuilder<double>(
                                  stream: jasaBloc.jasaHarga,
                                  builder: (context, snapshot) {
                                    orderBloc.changeJasaHarga;
                                    return Text(
                                      existingJasa != null
                                          ? widget.formatPrice
                                              .format(existingJasa.jasaHarga)
                                          : null,
                                      style: TextStyles.subOnBoardText,
                                    );
                                  },
                                ),
                                StreamBuilder<String>(
                                  stream: jasaBloc.jasaTimes,
                                  builder: (context, snapshot) {
                                    orderBloc.changeJasaTimes;
                                    return Text(
                                      existingJasa != null
                                          ? existingJasa.jasaTimes
                                          : null,
                                      style: TextStyles.subOnBoardText,
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
          ],
          // children: <Widget>[
        ),
      ),
    );
  }

  loadValues(OrderBloc orderBloc, JasaBloc jasaBloc, Jasa jasa, String jasaId) {
    jasaBloc.changeJasa(jasa);
    // orderBloc.changeOrder(order);
    orderBloc.changeJasaId(jasaId);
    // jasaBloc.changeJasaId(jasaId);
    orderBloc.changeJasaTimes(jasa.jasaTimes);
    orderBloc.changeJasaName(jasa.jasaName);
    orderBloc.changeJasaHarga(jasa.jasaHarga.toString());
    orderBloc.changeJasaServices(jasa.jasaServices);
    orderBloc.changeJasaImage(jasa.jasaImage ?? '');
    // if (jasa != null) {
    //   //EDIT FORM
    //   orderBloc.changeJasaTimes(jasa.jasaTimes);
    //   orderBloc.changeJasaName(jasa.jasaName);
    //   orderBloc.changeJasaHarga(jasa.jasaHarga.toString());
    //   orderBloc.changeJasaServices(jasa.jasaServices);
    //   orderBloc.changeJasaImage(jasa.jasaImage ?? '');
    // } else {
    //   //ADD FORM
    //   jasaBloc.changeJasaTimes(null);
    //   jasaBloc.changeJasaName(null);
    //   jasaBloc.changeJasaServices(null);
    //   jasaBloc.changeJasaHarga(null);
    //   jasaBloc.changeJasaImage('');
    // }
  }
}
