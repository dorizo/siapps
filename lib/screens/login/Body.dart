import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/components/CustomRadioButton.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.username,
      this.password,
      this.usernameError,
      this.passwordError,
      this.userErrorMessage,
      this.passwordErrorMessage,
      @required this.student,
      @required this.teacher,
      @required this.radioStudentClick,
      @required this.radioTeacherClick,
      @required this.parentLoginClick,
      @required this.checkLogin})
      : super(key: key);

  final username;
  final password;

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool student;
  bool teacher;
  bool usernameError = false;
  bool passwordError = false;

  String userErrorMessage = "";
  String passwordErrorMessage = "";

  final VoidCallback radioStudentClick;
  final VoidCallback radioTeacherClick;
  final VoidCallback parentLoginClick;
  final VoidCallback checkLogin;

  void _checkLogin() {
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Container(
          alignment: Alignment.topLeft,
          child: new Stack(
            children: <Widget>[
              new Container(
                height: 110.0,
                decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                ),
                alignment: Alignment.bottomCenter,
                child: null,
              ),
              new Container(
                padding: new EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                      decoration: BoxDecoration(
                          color: ColorsInt.colorWhite.withOpacity(0.4),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(15.0))),
                      child: new Image.asset("assets/images/iconsapp.png" , width: 40, height: 40,),
                      // Text(
                      //   AppLocalizations.of(context).translate("Sc"),
                      //   style: TextStyle(
                      //       color: ColorsInt.colorWhite,
                      //       fontSize: 30.0,
                      //       fontFamily: "regular"),
                      // ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    new Card(
                      margin: EdgeInsets.zero,
                      color: ColorsInt.colorWhite,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: new Container(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new TextFormField(
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              focusNode: _usernameFocus,
                              controller: username,
                              maxLines: 1,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _usernameFocus, _passwordFocus);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0.0),
                                isDense: true,
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)
                                    .translate("username"),
                                prefixIcon: Image.asset(
                                  'assets/images/ic_user_name.png',
                                  height: 10.0,
                                  width: 10.0,
                                ),
                                errorText:
                                    usernameError ? userErrorMessage : null,
                                hintStyle:
                                    TextStyle(color: ColorsInt.colorTextHint),
                              ),
                              style: TextStyle(
                                  fontFamily: "regular",
                                  color: ColorsInt.colorText),
                            ),
                            Container(
                              color: ColorsInt.colorGray,
                              height: 1,
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            ),
                            new TextFormField(
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.visiblePassword,
                              focusNode: _passwordFocus,
                              controller: password,
                              obscureText: true,
                              maxLines: 1,
                              onFieldSubmitted: (term) {
                                //keyboard done action click
                                _checkLogin();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0.0),
                                isDense: true,
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)
                                    .translate("password"),
                                prefixIcon: Image.asset(
                                    'assets/images/ic_password.png'),
                                errorText:
                                    passwordError ? passwordErrorMessage : null,
                                hintStyle:
                                    TextStyle(color: ColorsInt.colorTextHint),
                              ),
                              style: TextStyle(
                                  fontFamily: "regular",
                                  color: ColorsInt.colorText),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*new Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        AppLocalizations.of(context).translate("login_as"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: HexColor(ColorString.colorPrimary),
                          fontFamily: "bold",
                        ),
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: new CustomRadioButtion(
                            isChecked: student,
                            title: AppLocalizations.of(context).translate("student"),
                            onCheck: () {
                              radioStudentClick();
                            },
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: new CustomRadioButtion(
                            isChecked: teacher,
                            title: AppLocalizations.of(context).translate("teacher"),
                            onCheck: () {
                              radioTeacherClick();
                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    ),*/
                    new SizedBox(
                      height: 20.0,
                    ),
                    new InkWell(
                      onTap: () => checkLogin(),
                      child: new Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: ColorsInt.colorPrimary,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: new Center(
                            child: Text(
                              AppLocalizations.of(context).translate("login"),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "bold",
                                  color: ColorsInt.colorWhite),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: new Text(
                        AppLocalizations.of(context).translate("login_note"),
                        style: TextStyle(
                            fontFamily: "regular",
                            color: ColorsInt.colorText,
                            fontSize: 12.0),
                      ),
                    ),
                    new SizedBox(height: 20.0),
                    new Container(
                      width: double.infinity,
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Flexible(
                            child: new Container(
                              color: ColorsInt.colorDivider,
                              height: 1,
                            ),
                            flex: 1,
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: new Text(
                              AppLocalizations.of(context).translate("or"),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorsInt.colorGreen,
                                  fontFamily: "regular"),
                            ),
                          ),
                          new Flexible(
                            child: new Container(
                              color: ColorsInt.colorDivider,
                              height: 1,
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new InkWell(
                      onTap: () {
                        //_displaySnackBar(context, "losdf");
                        parentLoginClick();
                      },
                      child: new Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: ColorsInt.colorOrange,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: new Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("parent_login"),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "bold",
                                  color: ColorsInt.colorWhite),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
