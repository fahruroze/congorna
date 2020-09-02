import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/blocs/jasa_bloc.dart';
import 'package:congorna/src/models/jasa.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/widgets/card.dart';
import 'package:provider/provider.dart';

class JasaCuci extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var jasaBloc = Provider.of<JasaBloc>(context);
    var authBloc = Provider.of<AuthBloc>(context);
    return pageBody(jasaBloc, context, authBloc.mahasiswaId);
  }

  Widget pageBody(
    JasaBloc jasaBloc,
    BuildContext context,
    String vendorId,
  ) {
    return StreamBuilder<List<Jasa>>(
        // stream: jasaBloc.jasaByVendorId(vendorId),
        stream: jasaBloc.jasaByJasaId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return (Platform.isIOS)
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator();

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var jasa = snapshot.data[index];
                    return GestureDetector(
                      child: AppCard(
                        jasaName: jasa.jasaName,
                        jasaHarga: jasa.jasaHarga,
                        jasaServices: jasa.jasaServices,
                        jasaTimes: jasa.jasaTimes,
                        jasaImage: jasa.jasaImage,
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed('/choosejasa/${jasa.jasaId}'),
                      // onTap: () => Navigator.of(context)
                      //     .pushNamed('/choosejasa/${jasa.jasaId}'),
                    );
                  },
                ),
              ),
              // GestureDetector(
              //   child: Container(
              //       height: 50.0,
              //       width: double.infinity,
              //       color: AppColors.brown,
              //       child: (Platform.isIOS)
              //           ? Icon(CupertinoIcons.add,
              //               color: Colors.white, size: 35.0)
              //           : Icon(Icons.add_shopping_cart,
              //               color: Colors.white, size: 35.0)),
              //   // onTap: () => Navigator.of(context).pushNamed('/choosejasa'),
              //   onTap: () => Navigator.of(context).pushNamed('/choosejasa'),
              // )
            ],
          );
        });
  }
}
