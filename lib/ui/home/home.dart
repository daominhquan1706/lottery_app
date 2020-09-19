import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  PostStore _postStore;
  ThemeStore _themeStore;
  LanguageStore _languageStore;
  Map<String, dynamic> _listData = {
    "0": ["097198"],
    "1": ["00417"],
    "2": ["39548"],
    "3": ["34866", "34866"],
    "4": ["34866", "34866", "45153", "39583", "00287", "12341", "09123"],
    "5": ["1312"],
    "6": ["1312", "1312", "1312"],
    "7": ["1312"],
    "8": ["48"],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _postStore = Provider.of<PostStore>(context);

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Drawer Header"),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text("Item 1"),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text("Item 1"),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text("Item 1"),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text("Item 1"),
          ),
        ],
      ),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Center(
          child: Text(AppLocalizations.of(context).translate('home_tv_posts'))),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
//      _buildLanguageButton(),
//      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading
            ? CustomProgressIndicatorWidget()
            : Material(
                child: Table(
                  columnWidths: {0: FractionColumnWidth(.2)},
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildRow(title: "Giải tám", data: [
                      _listData["8"],
                      _listData["8"],
                      _listData["8"],
                    ]),
                    _buildRow(title: "Giải bảy", data: [
                      _listData["7"],
                      _listData["7"],
                      _listData["7"],
                    ]),
                    _buildRow(title: "Giải sáu", data: [
                      _listData["6"],
                      _listData["6"],
                      _listData["6"],
                    ]),
                    _buildRow(title: "Giải năm", data: [
                      _listData["5"],
                      _listData["5"],
                      _listData["5"],
                    ]),
                    _buildRow(title: "Giải bốn", data: [
                      _listData["4"],
                      _listData["4"],
                      _listData["4"],
                    ]),
                    _buildRow(title: "Giải ba", data: [
                      _listData["3"],
                      _listData["3"],
                      _listData["3"],
                    ]),
                    _buildRow(title: "Giải hai", data: [
                      _listData["2"],
                      _listData["2"],
                      _listData["2"],
                    ]),
                    _buildRow(title: "Giải một", data: [
                      _listData["1"],
                      _listData["1"],
                      _listData["1"],
                    ]),
                    _buildRow(title: "Giải đặc biệt", data: [
                      _listData["0"],
                      _listData["0"],
                      _listData["0"],
                    ]),
                  ],
                ),
              );
      },
    );
  }

  TableRow _buildRow({String title, List<List<String>> data}) {
    return TableRow(
      children: [Center(child: Text(title)), ...listColumn(data)],
    );
  }

  List<Widget> listColumn(List<List<String>> data) {
    return data
        .map((listNumber) => Column(
            children: listNumber.map((e) => Center(child: Text(e))).toList()))
        .toList();
  }

  Widget _buildMenuItem() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: const Text("He'd have you all unravel at the"),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
