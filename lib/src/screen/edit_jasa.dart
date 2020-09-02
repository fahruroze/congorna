import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/blocs/jasa_bloc.dart';
import 'package:congorna/src/models/jasa.dart';
import 'package:congorna/src/styles/base.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/widgets/button.dart';
import 'package:congorna/src/widgets/dropdown_button.dart';
import 'package:congorna/src/widgets/sliver_scaffold.dart';
import 'package:congorna/src/widgets/textfield.dart';
import 'package:provider/provider.dart';

class EditJasa extends StatefulWidget {
  final String jasaId;
  final formatPrice = NumberFormat.simpleCurrency(locale: "id_IDR");

  EditJasa({this.jasaId});

  @override
  _EditJasaState createState() => _EditJasaState();
}

class _EditJasaState extends State<EditJasa> {
  @override
  void initState() {
    var jasaBloc =
        Provider.of<JasaBloc>(context, listen: false); //instance jasabloc
    jasaBloc.jasaSaved.listen((saved) {
      if (saved != null && saved == true && context != null) {
        Fluttertoast.showToast(
          msg: "Jasa Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColors.purpleViolet,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var jasaBloc = Provider.of<JasaBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return FutureBuilder<Jasa>(

        // future: jasaBloc.fetchJasa(widget.jasaId),
        builder: (context, snapshot) {
      if (!snapshot.hasData && widget.jasaId != null) {
        return Scaffold(
          body: Center(
              child: (Platform.isIOS)
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator()),
        );
      }

      Jasa existingJasa;

      if (widget.jasaId != null) {
        //Edit Logic
        existingJasa = snapshot.data;
        loadValues(jasaBloc, existingJasa, authBloc.mahasiswaId);
      } else {
        //Add Logic
        loadValues(jasaBloc, null, authBloc.mahasiswaId);
      }

      return (Platform.isIOS)
          ? AppSliverScaffold.cupertinoSliverScaffold(
              navTitle: '',
              pageBody: pageBody(true, jasaBloc, context, existingJasa),
              context: context)
          : AppSliverScaffold.materialSliverScaffold(
              navTitle: '',
              pageBody: pageBody(false, jasaBloc, context, existingJasa),
              context: context);
    });
  }

  Widget pageBody(
      bool isIOS, JasaBloc jasaBloc, BuildContext context, Jasa existingJasa) {
    var items = Provider.of<List<String>>(context);
    var pageLabel = (existingJasa != null) ? 'Edit Jasa' : 'Add Jasa';
    return ListView(
      children: <Widget>[
        Text(pageLabel,
            style: TextStyles.subtitle, textAlign: TextAlign.center),
        Padding(
          padding: BaseStyles.listPadding,
          child: Divider(color: AppColors.darkblue),
        ),
        StreamBuilder<String>(
            stream: jasaBloc.jasaName,
            builder: (context, snapshot) {
              return AppTextField(
                hintText: 'Nama Jasa',
                cupertinoIcon: FontAwesomeIcons.shoppingBasket,
                materialIcon: FontAwesomeIcons.shoppingBasket,
                isIOS: isIOS,
                errorText: snapshot.error,
                initialText:
                    (existingJasa != null) ? existingJasa.jasaName : null,
                onChange: jasaBloc.changeJasaName,
              );
            }),
        StreamBuilder<double>(
            stream: jasaBloc.jasaHarga,
            builder: (context, snapshot) {
              return AppTextField(
                hintText: 'Harga',
                cupertinoIcon: FontAwesomeIcons.dollarSign,
                materialIcon: FontAwesomeIcons.dollarSign,
                isIOS: isIOS,
                textInputType: TextInputType.number,
                errorText: snapshot.error,
                initialText: (existingJasa != null)
                    ? existingJasa.jasaHarga.toString()
                    : null,
                onChange: jasaBloc.changeJasaHarga,
              );
            }),
        StreamBuilder<String>(
            stream: jasaBloc.jasaServices,
            builder: (context, snapshot) {
              return AppTextField(
                hintText: 'Services',
                cupertinoIcon: FontAwesomeIcons.servicestack,
                materialIcon: FontAwesomeIcons.servicestack,
                isIOS: isIOS,
                errorText: snapshot.error,
                initialText:
                    (existingJasa != null) ? existingJasa.jasaServices : null,
                onChange: jasaBloc.changeJasaServices,
              );
            }),
        StreamBuilder<String>(
            stream: jasaBloc.jasaTimes,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                // return Container();
                return AppDropdownButton(
                  hintText: 'Waktu',
                  items: items,
                  value: snapshot.data,
                  onChanged: jasaBloc.changeJasaTimes,
                  materialIcon: FontAwesomeIcons.clock,
                  cupertinoIcon: FontAwesomeIcons.clock,
                );
              } else {
                return AppDropdownButton(
                  hintText: 'Waktu',
                  items: items,
                  value: snapshot.data,
                  onChanged: jasaBloc.changeJasaTimes,
                  materialIcon: FontAwesomeIcons.clock,
                  cupertinoIcon: FontAwesomeIcons.clock,
                );
              }
            }),
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
              if (!snapshot.hasData || snapshot.data == "")
                return AppButton(
                    buttonType: ButtonType.Register,
                    buttonText: 'Add Image',
                    onPressed: jasaBloc.pickImage);

              return Column(
                children: <Widget>[
                  Padding(
                      padding: BaseStyles.listPadding,
                      child: Image.network(snapshot.data)),
                  AppButton(
                      buttonType: ButtonType.Register,
                      buttonText: 'Change Image',
                      onPressed: jasaBloc.pickImage)
                ],
              );
            }),
        StreamBuilder<bool>(
            stream: jasaBloc.isValid,
            builder: (context, snapshot) {
              return Padding(
                padding: BaseStyles.listPadding,
                child: AppButton(
                  buttonType: (snapshot.data == true)
                      ? ButtonType.Brown
                      : ButtonType.Disable,
                  buttonText: 'Save Jasa',
                  onPressed: jasaBloc.saveJasa,
                ),
              );
            }),
      ],
    );
  }

  loadValues(JasaBloc jasaBloc, Jasa jasa, String vendorId) {
    jasaBloc.changeJasa(jasa);
    jasaBloc.changeVendorId(vendorId);
    // jasaBloc.changeJasaId(vendorId);
    if (jasa != null) {
      //EDIT FORM
      jasaBloc.changeJasaTimes(jasa.jasaTimes);
      jasaBloc.changeJasaName(jasa.jasaName);
      jasaBloc.changeJasaHarga(jasa.jasaHarga.toString());
      jasaBloc.changeJasaServices(jasa.jasaServices);
      jasaBloc.changeJasaImage(jasa.jasaImage ?? '');
    } else {
      //ADD FORM
      jasaBloc.changeJasaTimes(null);
      jasaBloc.changeJasaName(null);
      jasaBloc.changeJasaServices(null);
      jasaBloc.changeJasaHarga(null);
      jasaBloc.changeJasaImage('');
    }
  }
}
