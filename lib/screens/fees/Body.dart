import 'package:classes_app/config/BaseURL.dart';
import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/models/FeesModel.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.controller,
      this.total_remaining_amount,
      this.feesModelListHistory,
      this.feesModelList,
      this.onPayClick})
      : super(key: key);

  TabController controller;
  final total_remaining_amount;
  List<FeesModel> feesModelListHistory;
  List<FeesModel> feesModelList;

  VoidCallback onPayClick;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
              color: ColorsInt.colorPrimary,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0))),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                AppLocalizations.of(context).translate("need_to_pay"),
                style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: "regular",
                    color: ColorsInt.colorWhite),
              ),
              new Text(
                "${BaseURL.CURRENCY} ${total_remaining_amount ?? ""}",
                style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: "regular",
                    color: ColorsInt.colorWhite),
              ),
            ],
          ),
        ),
        new SizedBox(
          height: 10.0,
        ),
        new Card(
          shape: StadiumBorder(
            side: BorderSide(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
          ),
          child: new Container(
            padding: EdgeInsets.all(10.0),
            child: new InkWell(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Image.asset(
                    "assets/images/ic_pay_online.png",
                    height: 20.0,
                    width: 20.0,
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("pay"),
                    style: TextStyle(
                        color: ColorsInt.colorText,
                        fontSize: 18.0,
                        fontFamily: "regular"),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              onTap: () => onPayClick(),
            ),
          ),
        ),
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new TabBar(
            controller: controller,
            unselectedLabelColor: ColorsInt.colorBlack,
            labelColor: ColorsInt.colorBlack,
            indicatorColor: ColorsInt.colorPrimary,
            labelStyle: TextStyle(
              fontFamily: "regular",
              fontSize: 16.0,
            ),
            tabs: [
              Tab(
                icon: null,
                text: AppLocalizations.of(context).translate("history"),
              ),
              Tab(
                icon: null,
                text: AppLocalizations.of(context).translate("fees"),
              ),
            ],
          ),
        ),
        new Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              _getFeesListHistory("1"),
              _getFeesList("2"),
            ],
          ),
        ),
      ],
    );
  }

  _getFeesListHistory(pageStoreKey) {
    return new ListView.builder(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      key: new PageStorageKey(pageStoreKey),
      shrinkWrap: true,
      itemCount: feesModelListHistory.length,
      itemBuilder: (context, indext) {
        final feesModel = feesModelListHistory[indext];

        return new Container(
          margin: EdgeInsets.only(top: 10.0),
          //color: ColorsInt.colorWhite,
          /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
          ),*/
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: ColorsInt.colorGray,
                blurRadius: 1.0,
                offset: new Offset(0.0, 0.0),
              ),
            ],
          ),
          child: new Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        feesModel.paid_date ?? "",
                        style: TextStyle(
                          fontFamily: "regular",
                          fontSize: 18.0,
                          color: ColorsInt.colorBlack,
                        ),
                      ),
                      new Text(
                        feesModel.note ?? "",
                        style: TextStyle(
                          fontFamily: "regular",
                          fontSize: 12.0,
                          color: ColorsInt.colorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                new Text(
                  "${BaseURL.CURRENCY} ${feesModel.paid_amount}",
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 18.0,
                    color: ColorsInt.colorText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _getFeesList(pageStoreKey) {
    return new ListView.builder(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      key: new PageStorageKey(pageStoreKey),
      shrinkWrap: true,
      itemCount: feesModelList.length,
      itemBuilder: (context, indext) {
        final feesModel = feesModelList[indext];

        return new Container(
          margin: EdgeInsets.only(top: 10.0),
          //color: ColorsInt.colorWhite,
          /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
          ),*/
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: ColorsInt.colorGray,
                blurRadius: 1.0,
                offset: new Offset(0.0, 0.0),
              ),
            ],
          ),
          child: new Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        feesModel.fees_type ?? "",
                        style: TextStyle(
                          fontFamily: "regular",
                          fontSize: 18.0,
                          color: ColorsInt.colorBlack,
                        ),
                      ),
                      new Text(
                        feesModel.batch_name ?? "",
                        style: TextStyle(
                          fontFamily: "regular",
                          fontSize: 12.0,
                          color: ColorsInt.colorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                new Text(
                  "${BaseURL.CURRENCY} ${feesModel.amount}",
                  style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 18.0,
                    color: ColorsInt.colorText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
