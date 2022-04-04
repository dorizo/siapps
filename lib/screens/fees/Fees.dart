import 'dart:developer';

import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/fees/Body.dart';

import 'package:classes_app/models/FeesModel.dart';
import 'package:classes_app/models/BankModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';

class Fees extends StatefulWidget {
  @override
  _FeesState createState() => _FeesState();
}

class _FeesState extends State<Fees> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  var _setModalState;

  var _total_remaining_amount = "";
  List<FeesModel> _feesModelListHistory = [];
  List<FeesModel> _feesModelList = [];
  List<BankModel> _bankModelList = [];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      //_makeGetFeesRemaining(context);
      _makeGetFeesDetail(context);
    });
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("fees")),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: new Body(
        controller: _controller,
        total_remaining_amount: _total_remaining_amount,
        feesModelList: _feesModelList,
        feesModelListHistory: _feesModelListHistory,
        onPayClick: () => _displayPaymentBottomSheet(),
      ),
    );
  }

  _makeGetFeesRemaining(BuildContext context) {
    var url = BaseURL.GET_FEES_REMAINING_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      setState(() {
        _total_remaining_amount = dataJson["total_remaining_amount"];
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _makeGetFeesDetail(BuildContext context) {
    var url = BaseURL.GET_FEES_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      final Map feesObject = dataJson["fees"];
      final List bank_details = dataJson["bank_details"];
      final List fees_typeList = dataJson["fees_type"];
      final List paid_feesList = dataJson["paid_fees"];

      setState(() {
        _total_remaining_amount = feesObject["total_remaining_amount"];

        if (_feesModelListHistory.length > 0) {
          _feesModelListHistory.clear();
        }
        _feesModelListHistory.addAll(
            paid_feesList.map((val) => FeesModel.fromJson(val)).toList());

        if (_feesModelList.length > 0) {
          _feesModelList.clear();
        }
        _feesModelList.addAll(
            fees_typeList.map((val) => FeesModel.fromJson(val)).toList());

        if (_bankModelList.length > 0) {
          _bankModelList.clear();
        }
        _bankModelList.addAll(
            bank_details.map((val) => BankModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _displayPaymentBottomSheet() {
    if(sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE)==2){
Navigator.pushNamed(context, '/webviewlink',
                  arguments: HomeMenuModel(
                    'Detail Pembayaran ',
                    'https://demo.siapps.id/admin/payment/index/'+sharedPrefs.getString(BaseURL.KEY_USER_ID),
                  ));
 
    }else{
      _displaySnackBar(context, "Accunt Ini Tidak Dapat Akses Pembayaran");
    };
    // Future<void> future = showModalBottomSheet<void>(
    //   context: context,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //         builder: (BuildContext context, StateSetter setModalState) {
    //       _setModalState = setModalState;
    //       return new Container(
    //         padding: MediaQuery.of(context).viewInsets,
    //         child: new ListView.builder(
    //             shrinkWrap: true,
    //             padding: EdgeInsets.only(top: 20.0),
    //             itemCount: _bankModelList.length,
    //             itemBuilder: (context, index) {
    //               final bankModel = _bankModelList[index];

    //               return new Container(
    //                 margin:
    //                     EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
    //                 decoration: BoxDecoration(
    //                   border: Border.all(
    //                     color: ColorsInt.colorGray,
    //                     width: 1.0,
    //                   ),
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.all(
    //                     Radius.circular(20.0),
    //                   ),
    //                   boxShadow: <BoxShadow>[
    //                     new BoxShadow(
    //                       color: ColorsInt.colorGray,
    //                       blurRadius: 1.0,
    //                       offset: new Offset(0.0, 0.0),
    //                     ),
    //                   ],
    //                 ),
    //                 child: new Container(
    //                   width: double.infinity,
    //                   padding: EdgeInsets.only(
    //                       top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
    //                   child: new Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: <Widget>[
    //                       new Expanded(
    //                         child: new Column(
    //                           mainAxisSize: MainAxisSize.max,
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: <Widget>[
    //                             new Text(
    //                               bankModel.bank_name ?? "",
    //                               style: TextStyle(
    //                                 fontFamily: "regular",
    //                                 fontSize: 18.0,
    //                                 color: ColorsInt.colorBlack,
    //                               ),
    //                             ),
    //                             new Text(
    //                               "${AppLocalizations.of(context).translate("ac_name")} ${bankModel.acc_holder_name}",
    //                               style: TextStyle(
    //                                 fontFamily: "regular",
    //                                 fontSize: 12.0,
    //                                 color: ColorsInt.colorBlack,
    //                               ),
    //                             ),
    //                             new Text(
    //                               "${AppLocalizations.of(context).translate("ac_no")} ${bankModel.acc_no}",
    //                               style: TextStyle(
    //                                 fontFamily: "regular",
    //                                 fontSize: 12.0,
    //                                 color: ColorsInt.colorBlack,
    //                               ),
    //                             ),
    //                             new Text(
    //                               "${AppLocalizations.of(context).translate("ifsc")} ${bankModel.acc_ifsc}",
    //                               style: TextStyle(
    //                                 fontFamily: "regular",
    //                                 fontSize: 12.0,
    //                                 color: ColorsInt.colorBlack,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       new Text(
    //                         bankModel.acc_type ?? "",
    //                         style: TextStyle(
    //                           fontFamily: "bold",
    //                           fontSize: 16.0,
    //                           color: ColorsInt.colorText,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             }),
    //       );
    //     });
    //   },
    // );
    // future.then((void value) {
    //   _setModalState(() {});
    // });
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
