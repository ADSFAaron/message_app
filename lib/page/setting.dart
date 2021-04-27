import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:message_app/page/person.dart';
import '../all_shared_imports.dart';

// Create a custom flex scheme color for a light theme.
const FlexSchemeColor myScheme1Light = FlexSchemeColor(
  primary: Color(0xFF4E0028),
  primaryVariant: Color(0xFF320019),
  secondary: Color(0xFF003419),
  secondaryVariant: Color(0xFF002411),
  // The built in schemes use their secondary variant color as their
  // custom app bar color, it could of course be any color, but for consistency
  // we will do the same in this custom FlexSchemeColor.
  appBarColor: Color(0xFF002411),
);
// Create a corresponding custom flex scheme color for a dark theme.
const FlexSchemeColor myScheme1Dark = FlexSchemeColor(
  primary: Color(0xFF9E7389),
  primaryVariant: Color(0xFF775C69),
  secondary: Color(0xFF738F81),
  secondaryVariant: Color(0xFF5C7267),
  // Again we use same secondaryVariant color as optional custom app bar color.
  appBarColor: Color(0xFF5C7267),
);

// You can build a scheme the long way, by specifying all the required hand
// picked scheme colors, like above, or can also build schemes from a
// single primary color. With the [.from] factory, then the only required color
// is the primary color, the other colors will be computed. You can optionally
// also provide the primaryVariant, secondary and secondaryVariant colors with
// the factory, but any color that is not provided will always be computed for
// the full set of required colors in a FlexSchemeColor.

// In this example we create our 2nd scheme from just a primary color
// for the light and dark schemes. The custom app bar color will in this case
// also receive the same color value as the one that is computed for
// secondaryVariant color, this is the default with the [from] factory.
final FlexSchemeColor myScheme2Light =
    FlexSchemeColor.from(primary: const Color(0xFF4C4E06));
final FlexSchemeColor myScheme2Dark =
    FlexSchemeColor.from(primary: const Color(0xFF9D9E76));

// For our 3rd custom scheme we will define primary and secondary colors, but no
// variant colors, we will not make any dark scheme definitions either.
final FlexSchemeColor myScheme3Light = FlexSchemeColor.from(
  primary: const Color(0xFF993200),
  secondary: const Color(0xFF1B5C62),
);

// Create a list with all color schemes we will use, starting with all
// the built-in ones and then adding our custom ones at the end.
final List<FlexSchemeData> myFlexSchemes = <FlexSchemeData>[
  // Use the built in FlexColor schemes, but exclude the placeholder for custom
  // scheme, a selection that would typically be used to compose a theme
  // interactively in the app using a color picker, we won't be doing that in
  // this example.
  ...FlexColor.schemesList,
  // Then add our first custom FlexSchemeData to the list, we give it a name
  // and description too.
  const FlexSchemeData(
    name: 'Toledo purple',
    description: 'Purple theme, created from full custom defined color scheme.',
    // FlexSchemeData holds separate defined color schemes for light and
    // matching dark theme colors. Dark theme colors need to be much less
    // saturated than light theme. Using the same colors in light and dark
    // theme modes does not look nice.
    light: myScheme1Light,
    dark: myScheme1Dark,
  ),
  // Do the same for our second custom scheme.
  FlexSchemeData(
    name: 'Olive green',
    description:
        'Olive green theme, created from primary light and dark colors.',
    light: myScheme2Light,
    dark: myScheme2Dark,
  ),
  // We also do the same for our 3rd custom scheme, BUT we create its matching
  // dark colors, from the light FlexSchemeColor with the toDark method.
  FlexSchemeData(
    name: 'Oregon orange',
    description: 'Custom orange and blue theme, from only light scheme colors.',
    light: myScheme3Light,
    // We create the dark desaturated colors from the light scheme.
    dark: myScheme3Light.toDark(),
  ),
];

class SettingPage extends StatelessWidget {
  SettingPage({
    @required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.schemeIndex,
    @required this.onSchemeChanged,
    @required this.flexSchemeData,
    @required this.userPhotoURL,
    @required this.backGroundURL
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int schemeIndex;
  final ValueChanged<int> onSchemeChanged;
  final FlexSchemeData flexSchemeData;

  final String backGroundURL;
  final String userPhotoURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            alignment: Alignment(-0.2,0),
            child: Text(
              "設定",
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text("個人設定"),
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PersonSettingPage(backGroundURL: backGroundURL,userPhotoURL: userPhotoURL),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              )),
            ),
            ListTile(
              title: Text("主題設定"),
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ThemePage(
                        themeMode: themeMode,
                        onThemeModeChanged: onThemeModeChanged,
                        flexSchemeData: flexSchemeData,
                        schemeIndex: schemeIndex,
                        onSchemeChanged: onSchemeChanged),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              )),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class PersonSettingPage extends StatefulWidget {
  String backGroundURL;
  String userPhotoURL;
  PersonSettingPage({@required this.backGroundURL,@required this.userPhotoURL});
  _PersonSettingPage createState() => _PersonSettingPage();
}

class _PersonSettingPage extends State<PersonSettingPage> {
  FirebaseAuth auth;
  _PersonSettingPage();

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    auth = FirebaseAuth.instance;
  }

  void uploadPhoto(_source, int changeWhere) async {
    //changeWhere 0改背景 1改大頭貼
    // 先從 _source 獲取照片資訊並上傳至
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: _source);

    EasyLoading.show(status: 'loading...');
    String name = pickedFile.path.toString().split('/').last;
    File file = File(pickedFile.path);
    // print(pickedFile.runtimeType);
    String download;
    try {
      TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
          .ref('user/image/' + name)
          .putFile(file);
      download = await snapshot.ref.getDownloadURL();
      //_submitContent(download, 'image');
    } catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
    }
    print(download);
    //修改firestore內部使用者資料
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String changeWhereString = (changeWhere==0)? 'backGroundURL':'photoURL';
    await users.doc(auth.currentUser.email).update({changeWhereString:download});

    EasyLoading.dismiss();
    //從新刷新
    Navigator.of(context).pop();
    setState(() {

    });
  }

  void myBottomSheet(BuildContext context, int changeWhere) {
    //type 0改背景 1改大頭貼

    // showBottomSheet || showModalBottomSheet
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 120,
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "從相片挑選",
                    ),
                    onTap: () => uploadPhoto(ImageSource.gallery, changeWhere),
                  ),
                  ListTile(
                    title: Text("相機拍照"),
                    onTap: () => uploadPhoto(ImageSource.camera, changeWhere),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').doc(auth.currentUser.email).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
    if (snapshot.connectionState == ConnectionState.done) {
      EasyLoading.dismiss();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "個人資料",
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () => myBottomSheet(context, 0),
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/2.jpg"),
                                  fit: BoxFit.cover)))),
                  Center(
                      child: GestureDetector(
                        onTap: () => myBottomSheet(context, 1),
                        child: FaceImage(faceURL: snapshot.data.data()['photoURL'],),
                      )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () => myBottomSheet(context, 0),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),
                  Align(
                      alignment: Alignment(0.2, 0.2),
                      child: GestureDetector(
                          onTap: () => myBottomSheet(context, 1),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),
                ],
              ),
            ),
            //BIO
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: TextField(),
              ),
            ),
          ],
        ));}
    EasyLoading.show(status: 'loading...');
     return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: Text(
              "個人資料",
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  GestureDetector(
                      onTap: () => myBottomSheet(context, 0),
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/2.jpg"),
                                  fit: BoxFit.cover)))),
                  Center(
                      child: GestureDetector(
                          onTap: () => myBottomSheet(context, 1),
                          child: FaceImage(faceURL: null,),
                          )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () => myBottomSheet(context, 0),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),
                  Align(
                      alignment: Alignment(0.2, 0.2),
                      child: GestureDetector(
                          onTap: () => myBottomSheet(context, 1),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              // color: Colors.yellow,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black38,
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )))),

                ],
              ),
            ),
            //BIO
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: TextField(),
              ),
            ),
          ],
        ));});
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({
    Key key,
    @required this.themeMode,
    @required this.onThemeModeChanged,
    @required this.schemeIndex,
    @required this.onSchemeChanged,
    @required this.flexSchemeData,
  }) : super(key: key);
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int schemeIndex;
  final ValueChanged<int> onSchemeChanged;
  final FlexSchemeData flexSchemeData;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4;
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Row(
      children: <Widget>[
        const SizedBox(width: 0.01),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('主題設定'),
              actions: const <Widget>[AboutIconButton()],
            ),
            body: PageBody(
              child: ListView(
                padding: const EdgeInsets.all(AppConst.edgePadding),
                children: <Widget>[
                  Text('主題', style: headline4),
                  const Text(
                   '這裡可以簡單預覽所選擇的主題\n'
                       '選擇包含明亮或暗色主題\n'
                       '\n\n另外也可以選擇主題的配色\n'
                       '下方右邊圓圈圈點擊可觀看有那些顏色的主題可供選擇\n'
                       '並提供即時預覽大概顏色給您看'
                  ),
                  // A 3-way theme mode toggle switch.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConst.edgePadding),
                    child: FlexThemeModeSwitch(
                      themeMode: themeMode,
                      onThemeModeChanged: onThemeModeChanged,
                      flexSchemeData: flexSchemeData,
                    ),
                  ),
                  const Divider(),
                  // Popup menu button to select color scheme.
                  PopupMenuButton<int>(
                    padding: const EdgeInsets.all(0),
                    onSelected: onSchemeChanged,
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      for (int i = 0; i < myFlexSchemes.length; i++)
                        PopupMenuItem<int>(
                          value: i,
                          child: ListTile(
                            leading: Icon(Icons.lens,
                                color: isLight
                                    ? myFlexSchemes[i].light.primary
                                    : myFlexSchemes[i].dark.primary,
                                size: 35),
                            title: Text(myFlexSchemes[i].name),
                          ),
                        )
                    ],
                    child: ListTile(
                      title: Text('${myFlexSchemes[schemeIndex].name} theme'),
                      subtitle: Text(myFlexSchemes[schemeIndex].description),
                      trailing: Icon(
                        Icons.lens,
                        color: colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Active theme color indicators.
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppConst.edgePadding),
                    child: ShowThemeColors(),
                  ),
                  const SizedBox(height: 8),
                  // Open a sub-page
                  ListTile(
                    title: const Text('Open a demo subpage'),
                    subtitle: const Text(
                      'The subpage will use the same '
                      'color scheme based theme automatically.',
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 34),
                    onTap: () {
                      Subpage.show(context);
                    },
                  ),
                  const Divider(),
                  Text('Theme Showcase', style: headline4),
                  const ThemeShowcase(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
