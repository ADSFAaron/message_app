import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  SettingPage(
      {@required this.themeMode,
      @required this.onThemeModeChanged,
      @required this.schemeIndex,
      @required this.onSchemeChanged,
      @required this.flexSchemeData,
      @required this.userPhotoURL,
      @required this.backGroundURL});

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
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          alignment: Alignment(-0.2, 0),
          child: Text(
            "設定",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("個人設定"),
              leading: Icon(
                Icons.account_circle_outlined,
              ),
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PersonSettingPage(
                        backGroundURL: backGroundURL, userPhotoURL: userPhotoURL),
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
              leading: Icon(Icons.color_lens_outlined),
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
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PersonSettingPage extends StatefulWidget {
  String backGroundURL;
  String userPhotoURL;

  PersonSettingPage(
      {@required this.backGroundURL, @required this.userPhotoURL});

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
    String subTitle = pickedFile.path.toString().split('.').last;
    File file = File(pickedFile.path);
    // print(pickedFile.runtimeType);
    String download;
    String changeWhereString =
        (changeWhere == 0) ? 'backGroundURL' : 'photoURL';
    try {
      TaskSnapshot snapshot = await firebase_storage.FirebaseStorage.instance
          .ref('user/' +
              changeWhereString +
              '/' +
              auth.currentUser.email.toString())
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
    await users
        .doc(auth.currentUser.email)
        .update({changeWhereString: download});

    EasyLoading.dismiss();
    //從新刷新
    Navigator.of(context).pop();
    setState(() {});
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
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser.email)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          // alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => myBottomSheet(context, 0),
                            child: BackGroundImage(
                              imageURL: snapshot.data.data()['backGroundURL'],
                              siz: MediaQuery.of(context).size.width / 1.5,
                            ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () => myBottomSheet(context, 1),
                            child: FaceImage(
                              faceURL: snapshot.data.data()['photoURL'],
                            ),
                          ),
                        ),
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
                              ),
                            ),
                          ),
                        ),
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
                              ),
                            ),
                          ),
                        ),
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
              ),
            );
          }
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
                          child: FaceImage(
                            faceURL: null,
                          ),
                        ),
                      ),
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
                            ),
                          ),
                        ),
                      ),
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
                            ),
                          ),
                        ),
                      ),
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
            ),
          );
        });
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final PageController previewController = PageController(initialPage: 0);

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
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FlexThemeModeSwitch(
                      title: Text(
                        "顯示模式",
                        style: textTheme.subtitle1,
                      ),
                      themeMode: themeMode,
                      onThemeModeChanged: onThemeModeChanged,
                      flexSchemeData: flexSchemeData,
                      showSystemMode: false,
                      optionButtonBorderRadius: 50,
                      optionButtonMargin: EdgeInsets.all(12.0),
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
                      // title: Text('${myFlexSchemes[schemeIndex].name} theme123'),
                      // subtitle: Text(myFlexSchemes[schemeIndex].description),
                      title: Text(
                        '主題顏色',
                        style: textTheme.subtitle1,
                      ),
                      subtitle: Text('選擇主題配色'),
                      trailing: Icon(
                        Icons.lens,
                        color: colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: Text(
                      'Preview',
                      style: textTheme.subtitle1,
                    ),
                  ),
                  Container(
                    height: height / 3 * 2,
                    child: PageView(
                        controller: previewController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            child: previewSVGChatRoom(theme),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            child: previewSVGChatPage(theme),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            child: previewSVGHomePage(theme),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Theme Page Theme Preview SVG (不直接使用 SVG 因為 flutter 無法對 svg element 修改)
  // <defs> 對 SVG 檔案定義變數
  Widget previewSVGChatPage(ThemeData theme) {
    return SvgPicture.string(''' 
        <svg height="667" viewBox="0 0 375 667" width="375" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter filterUnits="userSpaceOnUse" height="71" id="Rectangle" width="390" x="-7.5" y="608.5">
      <feOffset dy="5" input="SourceAlpha" />
      <feGaussianBlur result="blur" stdDeviation="2.5" />
      <feFlood flood-opacity="0.2" />
      <feComposite in2="blur" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <filter filterUnits="userSpaceOnUse" height="98" id="Rectangle-2" width="417" x="-21" y="593">
      <feOffset dy="3" input="SourceAlpha" />
      <feGaussianBlur result="blur-2" stdDeviation="7" />
      <feFlood flood-opacity="0.122" />
      <feComposite in2="blur-2" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <filter filterUnits="userSpaceOnUse" height="86" id="Rectangle-3" width="405" x="-15" y="604">
      <feOffset dy="8" input="SourceAlpha" />
      <feGaussianBlur result="blur-3" stdDeviation="5" />
      <feFlood flood-opacity="0.141" />
      <feComposite in2="blur-3" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <filter filterUnits="userSpaceOnUse" height="65" id="Rectangle_8" width="65" x="288.5" y="20.5">
      <feOffset dy="1" input="SourceAlpha" />
      <feGaussianBlur result="blur-4" stdDeviation="1.5" />
      <feFlood flood-opacity="0.161" />
      <feComposite in2="blur-4" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <filter filterUnits="userSpaceOnUse" height="65" id="Rectangle_8-2" width="65" x="218.5"
        y="20.5">
      <feOffset dy="1" input="SourceAlpha" />
      <feGaussianBlur result="blur-5" stdDeviation="1.5" />
      <feFlood flood-opacity="0.161" />
      <feComposite in2="blur-5" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <filter filterUnits="userSpaceOnUse" height="74" id="Ellipse_1" width="74" x="11" y="18">
      <feOffset dy="3" input="SourceAlpha" />
      <feGaussianBlur result="blur-6" stdDeviation="3" />
      <feFlood flood-color="#8f8f8f" flood-opacity="0.161" />
      <feComposite in2="blur-6" operator="in" />
      <feComposite in="SourceGraphic" />
    </filter>
    <clipPath id="clip-ChatPage">
      <rect height="667" width="375" />
    </clipPath>
  </defs>
  <g clip-path="url(#clip-ChatPage)" id="ChatPage">
    <rect fill="#''' +
        theme.colorScheme.background.hexCode +
        '''" height="667" width="375" />
    <g data-name="Light 🌕/ Bottom Nav/1. Three up (3 States)"
        id="Light_Bottom_Nav_1._Three_up_3_States_" transform="translate(0 611)">
      <g data-name="Light 🌕/ Bottom Nav/Container" id="Light_Bottom_Nav_Container">
        <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp">
          <g id="Shadow">
            <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle)"
                transform="matrix(1, 0, 0, 1, 0, -611)">
              <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-4"
                  transform="translate(0 611)" width="375" />
            </g>
            <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle-2)"
                transform="matrix(1, 0, 0, 1, 0, -611)">
              <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-5"
                  transform="translate(0 611)" width="375" />
            </g>
            <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle-3)"
                transform="matrix(1, 0, 0, 1, 0, -611)">
              <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-6"
                  transform="translate(0 611)" width="375" />
            </g>
          </g>
        </g>
        <rect fill="#''' +
        theme.bottomAppBarColor.hexCode +
        '''" height="56" id="Primary" width="375" />
      </g>
      <g data-name="Light 🌕/ Bottom Nav/Tab on Primary" id="Light_Bottom_Nav_Tab_on_Primary"
          transform="translate(68)">
        <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp-2">
          <rect style="mix-blend-mode: multiply;isolation: isolate" data-name="Rectangle"
              fill="#fff" height="56" id="Rectangle-7" width="120" />
        </g>
        <text data-name="✏️ Caption" fill="#b8b8b8" font-family="SegoeUI, Segoe UI" font-size="12"
            id="_Caption" letter-spacing="0.033em" transform="translate(60 45)">
          <tspan x="-20.281" y="0">Friends</tspan>
        </text>
      </g>
      <g data-name="Light 🌕/ Bottom Nav/Tab on Primary" id="Light_Bottom_Nav_Tab_on_Primary-2"
          transform="translate(188)">
        <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp-3">
          <rect style="mix-blend-mode: multiply;isolation: isolate" data-name="Rectangle"
              fill="#fff" height="56" id="Rectangle-8" width="120" />
        </g>
        <text data-name="✏️ Caption" fill="#''' +
        theme.primaryColor.hexCode +
        '''" font-family="SegoeUI, Segoe UI"
            font-size="12" id="_Caption-2" letter-spacing="0.033em" transform="translate(60 45)">
          <tspan x="-12.796" y="0">Chat</tspan>
        </text>
        <g id="chat" transform="translate(45.694 8)">
          <g data-name="Group 220" id="Group_220" transform="translate(3.366)">
            <g data-name="Group 219" id="Group_219" transform="translate(0)">
              <path
                  d="M14.859,0c-.006.006-.019.006-.037.006A11.43,11.43,0,0,0,5.857,18.56L4.19,22.43a.621.621,0,0,0,.325.818.635.635,0,0,0,.356.044l6.112-1.074a11.014,11.014,0,0,0,3.808.662A11.44,11.44,0,0,0,14.859,0ZM14.8,21.637a10.021,10.021,0,0,1-3.527-.643.6.6,0,0,0-.331-.031l-5.144.9L7.155,18.7a.628.628,0,0,0-.1-.655A9.98,9.98,0,0,1,5.32,15.157,10.193,10.193,0,1,1,25,11.387v.037A10.22,10.22,0,0,1,14.8,21.637Z"
                  data-name="Path 2863" fill="#''' +
        theme.primaryColor.hexCode +
        '''" id="Path_2863"
                  transform="translate(-3.366)" />
            </g>
          </g>
          <g data-name="Group 222" id="Group_222" transform="translate(10.314 9.158)">
            <g data-name="Group 221" id="Group_221">
              <path d="M118.661,146.7H115.29a.624.624,0,1,0,0,1.249h3.371a.624.624,0,1,0,0-1.249Z"
                  data-name="Path 2864" fill="#''' +
        theme.primaryColor.hexCode +
        '''" id="Path_2864"
                  transform="translate(-114.666 -146.7)" />
            </g>
          </g>
          <g data-name="Group 224" id="Group_224" transform="translate(10.314 12.28)">
            <g data-name="Group 223" id="Group_223">
              <path d="M123.031,196.7H115.29a.624.624,0,1,0,0,1.249h7.741a.624.624,0,1,0,0-1.249Z"
                  data-name="Path 2865" fill="#''' +
        theme.primaryColor.hexCode +
        '''" id="Path_2865"
                  transform="translate(-114.666 -196.7)" />
            </g>
          </g>
        </g>
      </g>
    </g>
    <g data-name="Add Friend Button" id="Add_Friend_Button" transform="translate(273)">
      <g filter="url(#Rectangle_8)" transform="matrix(1, 0, 0, 1, -273, 0)">
        <rect data-name="Rectangle 8" fill="#''' +
        theme.scaffoldBackgroundColor.hexCode +
        '''" height="56" id="Rectangle_8-3" rx="28"
            transform="translate(293 24)" width="56" />
      </g>
      <g id="outline-person_add-24px" transform="translate(36 40)">
        <g id="Bounding_Boxes">
          <path d="M0,0H24V24H0Z" data-name="Path 3495" fill="none" id="Path_3495" />
        </g>
        <g id="Outline">
          <g data-name="Group 390" id="Group_390">
            <path
                d="M15,12a4,4,0,1,0-4-4A4,4,0,0,0,15,12Zm0-6a2,2,0,1,1-2,2A2.006,2.006,0,0,1,15,6Z"
                data-name="Path 3496" fill="#b8b8b8" id="Path_3496" />
            <path
                d="M15,14c-2.67,0-8,1.34-8,4v2H23V18C23,15.34,17.67,14,15,14ZM9,18c.22-.72,3.31-2,6-2s5.8,1.29,6,2Z"
                data-name="Path 3497" fill="#b8b8b8" id="Path_3497" />
            <path d="M6,15V12H9V10H6V7H4v3H1v2H4v3Z" data-name="Path 3498" fill="#b8b8b8"
                id="Path_3498" />
          </g>
        </g>
      </g>
    </g>
    <g data-name="Delete Button" id="Delete_Button" transform="translate(203)">
      <g filter="url(#Rectangle_8-2)" transform="matrix(1, 0, 0, 1, -203, 0)">
        <rect data-name="Rectangle 8" fill="#''' +
        theme.scaffoldBackgroundColor.hexCode +
        '''" height="56" id="Rectangle_8-4" rx="28"
            transform="translate(223 24)" width="56" />
      </g>
      <g id="outline-delete_sweep-24px" transform="translate(36 40)">
        <g data-name="Bounding_Boxes" id="Bounding_Boxes-2">
          <path d="M0,0H24V24H0Z" data-name="Path 2784" fill="none" id="Path_2784" />
        </g>
        <g data-name="Outline" id="Outline-2">
          <g data-name="Group 198" id="Group_198">
            <rect data-name="Rectangle 125" fill="#''' +
        theme.primaryColor.hexCode +
        '''" height="2" id="Rectangle_125"
                transform="translate(15 16)" width="4" />
            <rect data-name="Rectangle 126" fill="#b8b8b8" height="2" id="Rectangle_126"
                transform="translate(15 8)" width="7" />
            <rect data-name="Rectangle 127" fill="#b8b8b8" height="2" id="Rectangle_127"
                transform="translate(15 12)" width="6" />
            <path d="M3,18a2.006,2.006,0,0,0,2,2h6a2.006,2.006,0,0,0,2-2V8H3Zm2-8h6v8H5Z"
                data-name="Path 2785" fill="#b8b8b8" id="Path_2785" />
            <path d="M10,4H6L5,5H2V7H14V5H11Z" data-name="Path 2786" fill="#b8b8b8"
                id="Path_2786" />
          </g>
        </g>
      </g>
    </g>
    <g data-name="Menu Button" id="Menu_Button">
      <g filter="url(#Ellipse_1)" transform="matrix(1, 0, 0, 1, 0, 0)">
        <circle cx="28" cy="28" data-name="Ellipse 1" fill="#''' +
        theme.scaffoldBackgroundColor.hexCode +
        '''" id="Ellipse_1-2" r="28"
            transform="translate(20 24)" />
      </g>
      <g id="baseline-menu-24px" transform="translate(34.402 38.402)">
        <path d="M0,0H28V28H0Z" data-name="Path 2012" fill="none" id="Path_2012" />
        <path d="M3,21.6H23.2V19H3Zm0-6.5H23.2V12.5H3ZM3,6V8.6H23.2V6Z" data-name="Path 2013"
            fill="#898888" id="Path_2013" transform="translate(0.899 0.201)" />
      </g>
    </g>
    <path
        d="M26.362,14.4a7.331,7.331,0,0,0-4.212-5.513,4.581,4.581,0,0,0,1.562-3.471,4.4,4.4,0,0,0-4.278-4.5,4.4,4.4,0,0,0-4.278,4.5,4.581,4.581,0,0,0,1.563,3.473,6.909,6.909,0,0,0-1.03.562A7.246,7.246,0,0,0,13.6,11.569a8.693,8.693,0,0,0-1.784-.942,5.664,5.664,0,0,0,2.24-4.55A5.45,5.45,0,0,0,8.758.5a5.45,5.45,0,0,0-5.3,5.576,5.664,5.664,0,0,0,2.24,4.55,9.212,9.212,0,0,0-5.667,7.1,2.157,2.157,0,0,0,.446,1.725,1.986,1.986,0,0,0,1.544.748H15.5a1.986,1.986,0,0,0,1.544-.748,2.157,2.157,0,0,0,.446-1.725,9.8,9.8,0,0,0-.285-1.2H24.65a1.71,1.71,0,0,0,1.329-.643,1.854,1.854,0,0,0,.383-1.483ZM16.7,5.413a2.737,2.737,0,1,1,5.464,0,2.737,2.737,0,1,1-5.464,0ZM5,6.077A3.876,3.876,0,0,1,8.758,2.1a3.877,3.877,0,0,1,3.755,3.979,3.877,3.877,0,0,1-3.755,3.979A3.876,3.876,0,0,1,5,6.077ZM15.855,18.423a.46.46,0,0,1-.358.176H2.02a.46.46,0,0,1-.358-.176A.52.52,0,0,1,1.553,18a7.44,7.44,0,0,1,7.205-6.35A7.44,7.44,0,0,1,15.963,18a.519.519,0,0,1-.109.42Zm8.939-3.569a.186.186,0,0,1-.144.072h-8.1a9.27,9.27,0,0,0-1.734-2.357,5.4,5.4,0,0,1,4.617-2.66,5.583,5.583,0,0,1,5.406,4.767.219.219,0,0,1-.046.178Zm0,0"
        fill="#b8b8b8" id="friends" transform="translate(114.002 620.512)" />
    <g data-name="Friend Chat-1" id="Friend_Chat-1" transform="translate(2 5)">
      <g data-name="Rectangle 10" fill="#''' +
        theme.cardColor.hexCode +
        '''" id="Rectangle_10" stroke="#e6e6e6" stroke-width="2"
          transform="translate(17 99)">
        <rect height="79" rx="10" stroke="none" width="338" />
        <rect fill="none" height="77" rx="9" width="336" x="1" y="1" />
      </g>
      <text fill="#''' +
        theme.colorScheme.onBackground.hexCode +
        '''" font-family="SegoeUI, Segoe UI" font-size="21" id="Jeff"
          letter-spacing="0.033em" transform="translate(148 148)">
        <tspan x="-16.862" y="0">Jeff / 打球</tspan>
      </text>
      <g data-name="jeff" id="jeff-2" transform="translate(42 114)">
        <circle cx="25" cy="25" data-name="Ellipse 3" fill="#0d8abc" id="Ellipse_3" r="25" />
        <text fill="#fff" font-family="SegoeUI, Segoe UI" font-size="22" id="JE"
            transform="translate(25 34)">
          <tspan x="-12.491" y="0">JE</tspan>
        </text>
      </g>
    </g>
    <g data-name="Friend Chat-2" id="Friend_Chat-2" transform="translate(2 92)">
      <g data-name="Rectangle 10" fill="#''' +
        theme.cardColor.hexCode +
        '''" id="Rectangle_10-2" stroke="#e6e6e6" stroke-width="2"
          transform="translate(17 99)">
        <rect height="79" rx="10" stroke="none" width="338" />
        <rect fill="none" height="77" rx="9" width="336" x="1" y="1" />
      </g>
      <text data-name="Jeff" fill="#''' +
        theme.colorScheme.onBackground.hexCode +
        '''" font-family="SegoeUI, Segoe UI" font-size="21"
          id="Jeff-3" letter-spacing="0.033em" transform="translate(148 148)">
        <tspan x="-16.862" y="0">Jeff / 古蹟文化交流</tspan>
      </text>
      <g data-name="jeff" id="jeff-4" transform="translate(42 114)">
        <circle cx="25" cy="25" data-name="Ellipse 3" fill="#0d8abc" id="Ellipse_3-2" r="25" />
        <text data-name="JE" fill="#fff" font-family="SegoeUI, Segoe UI" font-size="22" id="JE-2"
            transform="translate(25 34)">
          <tspan x="-12.491" y="0">JE</tspan>
        </text>
      </g>
    </g>
    <g data-name="Friend Chat-3" id="Friend_Chat-3" transform="translate(2 179)">
      <g data-name="Rectangle 10" fill="#''' +
        theme.cardColor.hexCode +
        '''" id="Rectangle_10-3" stroke="#e6e6e6" stroke-width="2"
          transform="translate(17 99)">
        <rect height="79" rx="10" stroke="none" width="338" />
        <rect fill="none" height="77" rx="9" width="336" x="1" y="1" />
      </g>
      <text fill="#''' +
        theme.colorScheme.onBackground.hexCode +
        '''" font-family="SegoeUI, Segoe UI" font-size="21" id="Zhon"
          letter-spacing="0.033em" transform="translate(148 148)">
        <tspan x="-25.075" y="0">Zhon / o敏捷o</tspan>
      </text>
      <g data-name="zhon" id="zhon-2" transform="translate(42 114)">
        <circle cx="25" cy="25" data-name="Ellipse 2" fill="#b4f8c8" id="Ellipse_2" r="25" />
        <text font-family="SegoeUI, Segoe UI" font-size="22" id="ZH"
            transform="translate(25 33.741)">
          <tspan x="-14.083" y="0">ZH</tspan>
        </text>
      </g>
    </g>
  </g>
</svg>

        ''');
  }

  Widget previewSVGHomePage(ThemeData theme) {
    return SvgPicture.string(''' 
        <svg height="667" viewBox="0 0 375 667" width="375" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <filter filterUnits="userSpaceOnUse" height="71" id="Rectangle" width="390" x="-7.5"
            y="608.5">
            <feOffset dy="5" input="SourceAlpha" />
            <feGaussianBlur result="blur" stdDeviation="2.5" />
            <feFlood flood-opacity="0.2" />
            <feComposite in2="blur" operator="in" />
            <feComposite in="SourceGraphic" />
        </filter>
        <filter filterUnits="userSpaceOnUse" height="98" id="Rectangle-2" width="417" x="-21"
            y="593">
            <feOffset dy="3" input="SourceAlpha" />
            <feGaussianBlur result="blur-2" stdDeviation="7" />
            <feFlood flood-opacity="0.122" />
            <feComposite in2="blur-2" operator="in" />
            <feComposite in="SourceGraphic" />
        </filter>
        <filter filterUnits="userSpaceOnUse" height="86" id="Rectangle-3" width="405" x="-15"
            y="604">
            <feOffset dy="8" input="SourceAlpha" />
            <feGaussianBlur result="blur-3" stdDeviation="5" />
            <feFlood flood-opacity="0.141" />
            <feComposite in2="blur-3" operator="in" />
            <feComposite in="SourceGraphic" />
        </filter>
        <filter filterUnits="userSpaceOnUse" height="65" id="Rectangle_8" width="148" x="205.5"
            y="20.5">
            <feOffset dy="1" input="SourceAlpha" />
            <feGaussianBlur result="blur-4" stdDeviation="1.5" />
            <feFlood flood-opacity="0.161" />
            <feComposite in2="blur-4" operator="in" />
            <feComposite in="SourceGraphic" />
        </filter>
        <filter filterUnits="userSpaceOnUse" height="74" id="Ellipse_1" width="74" x="11" y="18">
            <feOffset dy="3" input="SourceAlpha" />
            <feGaussianBlur result="blur-5" stdDeviation="3" />
            <feFlood flood-color="#8f8f8f" flood-opacity="0.161" />
            <feComposite in2="blur-5" operator="in" />
            <feComposite in="SourceGraphic" />
        </filter>
        <clipPath id="clip-HomePage">
            <rect height="667" width="375" />
        </clipPath>
    </defs>
    <g clip-path="url(#clip-HomePage)" id="HomePage">
        <rect fill="#''' +
        theme.backgroundColor.hexCode +
        '''" height="667" width="375" />
        <rect data-name="Rectangle 9" fill="#''' +
        theme.cardColor.hexCode +
        '''" height="568" id="Rectangle_9" rx="10"
            transform="translate(17 99)" width="342" />
        <g data-name="Light 🌕/ Bottom Nav/1. Three up (3 States)"
            id="Light_Bottom_Nav_1._Three_up_3_States_" transform="translate(0 611)">
            <g data-name="Light 🌕/ Bottom Nav/Container" id="Light_Bottom_Nav_Container">
                <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp">
                    <g id="Shadow">
                        <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle)"
                            transform="matrix(1, 0, 0, 1, 0, -611)">
                            <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-4"
                                transform="translate(0 611)" width="375" />
                        </g>
                        <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle-2)"
                            transform="matrix(1, 0, 0, 1, 0, -611)">
                            <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-5"
                                transform="translate(0 611)" width="375" />
                        </g>
                        <g style="mix-blend-mode: multiply;isolation: isolate" filter="url(#Rectangle-3)"
                            transform="matrix(1, 0, 0, 1, 0, -611)">
                            <rect data-name="Rectangle" fill="#fff" height="56" id="Rectangle-6"
                                transform="translate(0 611)" width="375" />
                        </g>
                    </g>
                </g>
                <rect fill="#''' +
        theme.bottomAppBarColor.hexCode +
        '''" height="56" id="Primary" width="375" />
            </g>
            <g data-name="Light 🌕/ Bottom Nav/Tab on Primary" id="Light_Bottom_Nav_Tab_on_Primary"
                transform="translate(68)">
                <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp-2">
                    <rect style="mix-blend-mode: multiply;isolation: isolate" data-name="Rectangle" fill="#fff" height="56" id="Rectangle-7"
                        width="120" />
                </g>
                <text data-name="✏️ Caption" fill="#''' +
        theme.primaryColor.hexCode +
        '''" font-family="SegoeUI, Segoe UI"
                    font-size="12" id="_Caption" letter-spacing="0.033em"
                    transform="translate(60 45)">
                    <tspan x="-20.281" y="0">Friends</tspan>
                </text>
            </g>
            <g data-name="Light 🌕/ Bottom Nav/Tab on Primary"
                id="Light_Bottom_Nav_Tab_on_Primary-2" transform="translate(188)">
                <g data-name="Light 🌕/Elevation/00dp" id="Light_Elevation_00dp-3">
                    <rect style="mix-blend-mode: multiply;isolation: isolate" data-name="Rectangle" fill="#fff" height="56" id="Rectangle-8"
                        width="120" />
                </g>
                <text data-name="✏️ Caption" fill="#b8b8b8" font-family="SegoeUI, Segoe UI"
                    font-size="12" id="_Caption-2" letter-spacing="0.033em"
                    transform="translate(60 45)">
                    <tspan x="-12.796" y="0">Chat</tspan>
                </text>
                <g id="chat" transform="translate(45.694 8)">
                    <g data-name="Group 220" id="Group_220" transform="translate(3.366)">
                        <g data-name="Group 219" id="Group_219" transform="translate(0)">
                            <path d="M14.859,0c-.006.006-.019.006-.037.006A11.43,11.43,0,0,0,5.857,18.56L4.19,22.43a.621.621,0,0,0,.325.818.635.635,0,0,0,.356.044l6.112-1.074a11.014,11.014,0,0,0,3.808.662A11.44,11.44,0,0,0,14.859,0ZM14.8,21.637a10.021,10.021,0,0,1-3.527-.643.6.6,0,0,0-.331-.031l-5.144.9L7.155,18.7a.628.628,0,0,0-.1-.655A9.98,9.98,0,0,1,5.32,15.157,10.193,10.193,0,1,1,25,11.387v.037A10.22,10.22,0,0,1,14.8,21.637Z" data-name="Path 2863"
                                fill="#b8b8b8"
                                id="Path_2863" transform="translate(-3.366)" />
                        </g>
                    </g>
                    <g data-name="Group 222" id="Group_222" transform="translate(10.314 9.158)">
                        <g data-name="Group 221" id="Group_221">
                            <path d="M118.661,146.7H115.29a.624.624,0,1,0,0,1.249h3.371a.624.624,0,1,0,0-1.249Z" data-name="Path 2864"
                                fill="#b8b8b8"
                                id="Path_2864" transform="translate(-114.666 -146.7)" />
                        </g>
                    </g>
                    <g data-name="Group 224" id="Group_224" transform="translate(10.314 12.28)">
                        <g data-name="Group 223" id="Group_223">
                            <path d="M123.031,196.7H115.29a.624.624,0,1,0,0,1.249h7.741a.624.624,0,1,0,0-1.249Z" data-name="Path 2865"
                                fill="#b8b8b8"
                                id="Path_2865" transform="translate(-114.666 -196.7)" />
                        </g>
                    </g>
                </g>
            </g>
        </g>
        <g data-name="Add Friend Button" id="Add_Friend_Button" transform="translate(273)">
            <g filter="url(#Rectangle_8)" transform="matrix(1, 0, 0, 1, -273, 0)">
                <rect data-name="Rectangle 8" fill="#''' +
        theme.scaffoldBackgroundColor.hexCode +
        '''" height="56" id="Rectangle_8-2" rx="28"
                    transform="translate(210 24)" width="139" />
            </g>
            <g id="outline-person_add-24px" transform="translate(36 40)">
                <g id="Bounding_Boxes">
                    <path d="M0,0H24V24H0Z" data-name="Path 3495" fill="none" id="Path_3495" />
                </g>
                <g id="Outline">
                    <g data-name="Group 390" id="Group_390">
                        <path d="M15,12a4,4,0,1,0-4-4A4,4,0,0,0,15,12Zm0-6a2,2,0,1,1-2,2A2.006,2.006,0,0,1,15,6Z" data-name="Path 3496"
                            fill="#b8b8b8"
                            id="Path_3496" />
                        <path d="M15,14c-2.67,0-8,1.34-8,4v2H23V18C23,15.34,17.67,14,15,14ZM9,18c.22-.72,3.31-2,6-2s5.8,1.29,6,2Z" data-name="Path 3497"
                            fill="#b8b8b8"
                            id="Path_3497" />
                        <path d="M6,15V12H9V10H6V7H4v3H1v2H4v3Z" data-name="Path 3498"
                            fill="#b8b8b8" id="Path_3498" />
                    </g>
                </g>
            </g>
            <text data-name="Add Friend" fill="#b8b8b8" font-family="SegoeUI, Segoe UI"
                font-size="12" id="Add_Friend" letter-spacing="0.033em"
                transform="translate(-11 57)">
                <tspan x="-30.915" y="0">Add Friend</tspan>
            </text>
        </g>
        <g data-name="Menu Button" id="Menu_Button">
            <g filter="url(#Ellipse_1)" transform="matrix(1, 0, 0, 1, 0, 0)">
                <circle cx="28" cy="28" data-name="Ellipse 1" fill="#''' +
        theme.scaffoldBackgroundColor.hexCode +
        '''" id="Ellipse_1-2"
                    r="28" transform="translate(20 24)" />
            </g>
            <g id="baseline-menu-24px" transform="translate(34.402 38.402)">
                <path d="M0,0H28V28H0Z" data-name="Path 2012" fill="none" id="Path_2012" />
                <path d="M3,21.6H23.2V19H3Zm0-6.5H23.2V12.5H3ZM3,6V8.6H23.2V6Z" data-name="Path 2013"
                    fill="#898888"
                    id="Path_2013" transform="translate(0.899 0.201)" />
            </g>
        </g>
        <path d="M26.362,14.4a7.331,7.331,0,0,0-4.212-5.513,4.581,4.581,0,0,0,1.562-3.471,4.4,4.4,0,0,0-4.278-4.5,4.4,4.4,0,0,0-4.278,4.5,4.581,4.581,0,0,0,1.563,3.473,6.909,6.909,0,0,0-1.03.562A7.246,7.246,0,0,0,13.6,11.569a8.693,8.693,0,0,0-1.784-.942,5.664,5.664,0,0,0,2.24-4.55A5.45,5.45,0,0,0,8.758.5a5.45,5.45,0,0,0-5.3,5.576,5.664,5.664,0,0,0,2.24,4.55,9.212,9.212,0,0,0-5.667,7.1,2.157,2.157,0,0,0,.446,1.725,1.986,1.986,0,0,0,1.544.748H15.5a1.986,1.986,0,0,0,1.544-.748,2.157,2.157,0,0,0,.446-1.725,9.8,9.8,0,0,0-.285-1.2H24.65a1.71,1.71,0,0,0,1.329-.643,1.854,1.854,0,0,0,.383-1.483ZM16.7,5.413a2.737,2.737,0,1,1,5.464,0,2.737,2.737,0,1,1-5.464,0ZM5,6.077A3.876,3.876,0,0,1,8.758,2.1a3.877,3.877,0,0,1,3.755,3.979,3.877,3.877,0,0,1-3.755,3.979A3.876,3.876,0,0,1,5,6.077ZM15.855,18.423a.46.46,0,0,1-.358.176H2.02a.46.46,0,0,1-.358-.176A.52.52,0,0,1,1.553,18a7.44,7.44,0,0,1,7.205-6.35A7.44,7.44,0,0,1,15.963,18a.519.519,0,0,1-.109.42Zm8.939-3.569a.186.186,0,0,1-.144.072h-8.1a9.27,9.27,0,0,0-1.734-2.357,5.4,5.4,0,0,1,4.617-2.66,5.583,5.583,0,0,1,5.406,4.767.219.219,0,0,1-.046.178Zm0,0"
            fill="#''' +
        theme.primaryColor.hexCode +
        '''"
            id="friends" transform="translate(114.002 620.512)" />
        <g data-name="Friend TItle-1" id="Friend_TItle-1">
            <g data-name="Rectangle 10" fill="#''' +
        theme.backgroundColor.hexCode +
        '''" id="Rectangle_10" stroke="#898888"
                stroke-width="1" transform="translate(17 99)">
                <path
                    d="M10,0H114a0,0,0,0,1,0,0V114a0,0,0,0,1,0,0H0a0,0,0,0,1,0,0V10A10,10,0,0,1,10,0Z"
                    stroke="none" />
                <path
                    d="M10,.5H113a.5.5,0,0,1,.5.5V113a.5.5,0,0,1-.5.5H1a.5.5,0,0,1-.5-.5V10A9.5,9.5,0,0,1,10,.5Z"
                    fill="none" />
            </g>
            <g id="jeff" transform="translate(51 123)">
                <circle cx="25" cy="25" data-name="Ellipse 3" fill="#0d8abc" id="Ellipse_3"
                    r="25" />
                <text fill="#fff" font-family="SegoeUI, Segoe UI" font-size="22" id="JE"
                    transform="translate(25 34)">
                    <tspan x="-12.491" y="0">JE</tspan>
                </text>
            </g>
            <text data-name="Jeff" fill="#0d8abc" font-family="SegoeUI, Segoe UI" font-size="15"
                id="Jeff-2" letter-spacing="0.033em" transform="translate(74 203)">
                <tspan x="-12.044" y="0">Jeff</tspan>
            </text>
        </g>
        <g data-name="Friend Title-2" id="Friend_Title-2">
            <g data-name="Rectangle 11" fill="#''' +
        theme.backgroundColor.hexCode +
        '''" id="Rectangle_11" stroke="#898888"
                stroke-width="1" transform="translate(131 99)">
                <rect height="114" stroke="none" width="114" />
                <rect fill="none" height="113" width="113" x="0.5" y="0.5" />
            </g>
            <text font-family="SegoeUI, Segoe UI" font-size="15" id="Zhon"
                letter-spacing="0.033em" transform="translate(188 202)">
                <tspan x="-17.911" y="0" fill="#''' +
        theme.colorScheme.onBackground.hexCode +
        '''">Zhon</tspan>
            </text>
            <g data-name="zhon" id="zhon-2" transform="translate(162 123)">
                <circle cx="25" cy="25" data-name="Ellipse 2" fill="#b4f8c8" id="Ellipse_2"
                    r="25" />
                <text font-family="SegoeUI, Segoe UI" font-size="22" id="ZH"
                    transform="translate(25 33.741)">
                    <tspan x="-14.083" y="0">ZH</tspan>
                </text>
            </g>
        </g>
    </g>
</svg>

        ''');
  }

  Widget previewSVGChatRoom(ThemeData theme) {
    return SvgPicture.string(''' 
        <svg height="667" viewBox="0 0 375 667" width="375" xmlns="http://www.w3.org/2000/svg" fill="#''' +
        theme.cardColor.hexCode +
        '''">
  <defs>
    <clipPath id="clip-ChatRoom">
      <rect height="667" width="375" />
    </clipPath>
  </defs>
  <g clip-path="url(#clip-ChatRoom)" id="ChatRoom">
    <rect fill="#''' +
        theme.backgroundColor.hexCode +
        '''" height="667" width="375" />
    <rect data-name="Rectangle 1" fill="#''' +
        theme.primaryColor.hexCode +
        '''" height="68" id="Rectangle_1"
        width="375" />
    <g data-name="Rectangle 2" fill="#''' +
        theme.bottomAppBarColor.hexCode +
        '''" id="Rectangle_2" stroke="#B0B0B0"
        stroke-width="1" transform="translate(60 602)">
      <rect height="47" rx="10" stroke="none" width="256" />
      <rect fill="none" height="46" rx="9.5" width="255" x="0.5" y="0.5" />
    </g>
    <g id="outline-send-24px" transform="translate(334 612)">
      <g id="Bounding_Boxes">
        <path d="M0,0H28V28H0Z" data-name="Path 2825" fill="none" id="Path_2825" />
      </g>
      <g id="Outline" transform="translate(2 3)">
        <path
            d="M4.393,6.7l8.94,3.936L4.381,9.417,4.393,6.7m8.929,10.658L4.381,21.3V18.583l8.94-1.222M2.012,3,2,11.556,19.857,14,2,16.444,2.012,25,27,14,2.012,3Z"
            fill="#''' +
        theme.primaryColorLight.hexCode +
        '''" id="XMLID_1127_" transform="translate(-2 -3)" />
      </g>
    </g>
    <g id="baseline-expand_less-24px" transform="translate(17 612)">
      <path d="M12,8,6,14l1.41,1.41L12,10.83l4.59,4.58L18,14Z" data-name="Path 2000" id="Path_2000"
          transform="translate(2 1.929)"  fill="#''' +
        theme.primaryColorDark.hexCode +
        '''"/>
      <path d="M0,0H28V28H0Z" data-name="Path 2001" fill="none" id="Path_2001" />
    </g>
    <g id="baseline-arrow_back-24px" transform="translate(22 21)">
      <path d="M0,0H26V26H0Z" data-name="Path 1968" fill="none" id="Path_1968" />
      <path d="M22,11.875H8.309L14.6,5.586,13,4,4,13l9,9,1.586-1.586L8.309,14.125H22Z"
          data-name="Path 1969" id="Path_1969" />
    </g>
    <g id="outline-border_color-24px" transform="translate(337 24.002)">
      <g data-name="Bounding_Boxes" id="Bounding_Boxes-2">
        <path d="M0,0H20V20H0Z" data-name="Path 2859" fill="none" id="Path_2859" />
      </g>
      <g data-name="Outline" id="Outline-2" transform="translate(0 -0.002)">
        <g data-name="Group 218" id="Group_218">
          <path d="M14,3.25l-10,10V17H7.75l10-10ZM6.92,15H6v-.92l8-8,.92.92Z" data-name="Path 2860"
               id="Path_2860" transform="translate(-1.561 0.002)" />
          <path d="M20.71,4.04a1,1,0,0,0,0-1.41L18.37.29a1,1,0,0,0-1.41,0L15,2.25,18.75,6Z"
              data-name="Path 2861" id="Path_2861" transform="translate(-2 0.002)" />
          <path d="M0,20H20v4H0Z" data-name="Path 2862" fill="rgba(0,0,0,0.2)" id="Path_2862"
              transform="translate(0 -3.998)" />
        </g>
      </g>
    </g>
    <text data-name="Chat Room"  font-family="SegoeUI, Segoe UI" font-size="26"
        id="Chat_Room" transform="translate(68 43)" >
      <tspan x="0" y="0">Chat Room</tspan>
    </text>
    <path d="M10,0H80A10,10,0,0,1,90,10V38A10,10,0,0,1,80,48H0a0,0,0,0,1,0,0V10A10,10,0,0,1,10,0Z"
        data-name="Rectangle 4" fill="rgba(180,248,200,0.5)" id="Rectangle_4"
        transform="translate(77 102)" />
    <path d="M10,0H214a10,10,0,0,1,10,10V70a10,10,0,0,1-10,10H0a0,0,0,0,1,0,0V10A10,10,0,0,1,10,0Z"
        data-name="Rectangle 12" fill="rgba(180,248,200,0.5)" id="Rectangle_12"
        transform="translate(77 292)" />
    <path d="M0,0H188a10,10,0,0,1,10,10V38a10,10,0,0,1-10,10H10A10,10,0,0,1,0,38V0A0,0,0,0,1,0,0Z"
        data-name="Rectangle 5" fill="rgba(180,248,200,0.5)" id="Rectangle_5"
        transform="translate(77 159)" />
    <text data-name="Type Some Text" fill="#e3e3e3" font-family="SegoeUI, Segoe UI" font-size="18"
        id="Type_Some_Text" transform="translate(75 631)">
      <tspan x="0" y="0">Type Some Text</tspan>
    </text>
    <text font-family="SegoeUI, Segoe UI" font-size="15" id="Hey_Jeff" letter-spacing="0.033em"
        transform="translate(122 132)" fill="#000">
      <tspan x="-29.85" y="0">Hey, Jeff</tspan>
    </text>
    <text data-name="What do u call a shoe made
out of a banana?" font-family="SegoeUI, Segoe UI" font-size="15"
        id="What_do_u_call_a_shoe_made_out_of_a_banana_" letter-spacing="0.033em"
        transform="translate(91 323)" fill="#000">
      <tspan x="0" y="0">What do u call a shoe made</tspan>
      <tspan x="0" y="32">out of a banana?</tspan>
    </text>
    <text data-name="I wanna ask u a question" font-family="SegoeUI, Segoe UI" font-size="15"
        id="I_wanna_ask_u_a_question" letter-spacing="0.033em" fill="#000"
        transform="translate(179 189)">
      <tspan x="-87.107" y="0">I wanna ask u a question</tspan>
    </text>
    <g id="Chat">
      <path d="M10,0H52A10,10,0,0,1,62,10V48a0,0,0,0,1,0,0H10A10,10,0,0,1,0,38V10A10,10,0,0,1,10,0Z"
          data-name="Rectangle 3" fill="rgba(13,138,188,0.5)" id="Rectangle_3"
          transform="translate(236 228)" />
      <text fill="#fff" font-family="SegoeUI, Segoe UI" font-size="15" id="Sure"
          letter-spacing="0.033em" transform="translate(267 258)">
        <tspan x="-15.508" y="0">Sure</tspan>
      </text>
    </g>
    <g data-name="Chat" id="Chat-2" transform="translate(0 168)">
      <path d="M10,0H76A10,10,0,0,1,86,10V48a0,0,0,0,1,0,0H10A10,10,0,0,1,0,38V10A10,10,0,0,1,10,0Z"
          data-name="Rectangle 3" fill="rgba(13,138,188,0.5)" id="Rectangle_3-2"
          transform="translate(212 228)" />
      <text data-name="Slipper?" fill="#fff" font-family="SegoeUI, Segoe UI" font-size="15"
          id="Slipper_" letter-spacing="0.033em" transform="translate(255 258)">
        <tspan x="-28.077" y="0">Slipper?</tspan>
      </text>
    </g>
    <g id="Message_stamp">
      <text data-name="PM 5:47" fill="#666" font-family="SegoeUI, Segoe UI" font-size="10"
          id="PM_5:47" letter-spacing="0.033em" transform="translate(195 139)">
        <tspan x="-18.83" y="0">PM 5:47</tspan>
      </text>
      <text fill="#666" font-family="SegoeUI, Segoe UI" font-size="11" id="Read"
          letter-spacing="0.033em" transform="translate(176 125)">
        <tspan x="0" y="0">Read</tspan>
      </text>
    </g>
    <g data-name="Message_stamp" id="Message_stamp-2" transform="translate(106 61)">
      <text data-name="PM 5:48" fill="#666" font-family="SegoeUI, Segoe UI" font-size="10"
          id="PM_5:48" letter-spacing="0.033em" transform="translate(195 139)">
        <tspan x="-18.83" y="0">PM 5:48</tspan>
      </text>
      <text data-name="Read" fill="#666" font-family="SegoeUI, Segoe UI" font-size="11" id="Read-2"
          letter-spacing="0.033em" transform="translate(176 125)">
        <tspan x="0" y="0">Read</tspan>
      </text>
    </g>
    <g data-name="Message_stamp" id="Message_stamp-3" transform="translate(133 228)">
      <text data-name="PM 5:51" fill="#666" font-family="SegoeUI, Segoe UI" font-size="10"
          id="PM_5:51" letter-spacing="0.033em" transform="translate(195 139)">
        <tspan x="-18.83" y="0">PM 5:51</tspan>
      </text>
      <text data-name="Read" fill="#666" font-family="SegoeUI, Segoe UI" font-size="11" id="Read-3"
          letter-spacing="0.033em" transform="translate(176 125)">
        <tspan x="0" y="0">Read</tspan>
      </text>
    </g>
    <text data-name="PM 5:49" fill="#666" font-family="SegoeUI, Segoe UI" font-size="10"
        id="PM_5:49" letter-spacing="0.033em" transform="translate(209 268)">
      <tspan x="-18.83" y="0">PM 5:49</tspan>
    </text>
    <text data-name="PM 5:49" fill="#666" font-family="SegoeUI, Segoe UI" font-size="10"
        id="PM_5:49-2" letter-spacing="0.033em" transform="translate(188 436)">
      <tspan x="-18.83" y="0">PM 5:49</tspan>
    </text>
    <g id="zhon" transform="translate(15 157)">
      <circle cx="25" cy="25" data-name="Ellipse 2" fill="#b4f8c8" id="Ellipse_2" r="25" />
      <text font-family="SegoeUI, Segoe UI" font-size="22" id="ZH" transform="translate(25 33.741)">
        <tspan x="-14.083" y="0">ZH</tspan>
      </text>
    </g>
    <g data-name="zhon" id="zhon-2" transform="translate(15 322)">
      <circle cx="25" cy="25" data-name="Ellipse 2" fill="#b4f8c8" id="Ellipse_2-2" r="25" />
      <text data-name="ZH" font-family="SegoeUI, Segoe UI" font-size="22" id="ZH-2"
          transform="translate(25 33.741)">
        <tspan x="-14.083" y="0">ZH</tspan>
      </text>
    </g>
    <g id="jeff" transform="translate(307 394)">
      <circle cx="25" cy="25" data-name="Ellipse 3" fill="#0d8abc" id="Ellipse_3" r="25" />
      <text fill="#fff" font-family="SegoeUI, Segoe UI" font-size="22" id="JE"
          transform="translate(25 34)">
        <tspan x="-12.491" y="0">JE</tspan>
      </text>
    </g>
    <g data-name="jeff" id="jeff-2" transform="translate(307 226)">
      <circle cx="25" cy="25" data-name="Ellipse 3" fill="#0d8abc" id="Ellipse_3-2" r="25" />
      <text data-name="JE" fill="#fff" font-family="SegoeUI, Segoe UI" font-size="22" id="JE-2"
          transform="translate(25 34)">
        <tspan x="-12.491" y="0">JE</tspan>
      </text>
    </g>
  </g>
</svg>

 ''');
  }
}
