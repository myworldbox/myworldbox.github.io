import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import '../../core/core_const.dart';
import '../../core/core_mixin.dart';
import '../../core/core_static.dart';
import '../../core/core_var.dart';
import '../../effect/effect_galaxy.dart';
import '../../effect/effect_text_shuffle.dart';
import '../../core/core_struct.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_request.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../item/layout/overlay_layout.dart';

import '../../item/layout/tab_layout.dart';
import '../../item/snackbar/default_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../item/button/default_button.dart';
import '../../item/image/default_image.dart';
import '../../item/layout/ordered_layout.dart';
import '../../utility/utility_generate.dart';
import '../../page/test/fos_database.dart';
import '../../item/accordion/default_accordion.dart';
import '../../item/accordion/tile_accordion.dart';
import '../../item/carousel/default_carousel.dart';
import '../../item/draggable/bottom_draggable.dart';
import '../../model/atom.dart';
import '../../core/core_enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:googleapis_auth/auth_io.dart';

import '../auth/fos_auth_login.dart';

class PageHome extends StatefulWidget {
  PageHome({super.key});

  late Atom overlayBg;
  late Atom galaxyEffect;
  late Atom tabLayout;
  late Atom infoImage;
  late Atom coloredMapOrderedLayout;
  late Atom infoTwoArrayLayout;

  late Atom projectLayout;
  late Atom infoCarousell;
  late Atom infoPopper;

  late Atom infoRadio;
  late Atom infoModal;
  late Atom aboutMeAccordion;
  late Atom navDropdown;
  late Atom contactButton;
  late Atom pressButton;

  late Atom bottomDraggable;

  @override
  State<PageHome> createState() => _PageHome();
}

class Local {
  double screenHeight = 900;
  double screenWidth = 900;
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  Uint8List? imageBytes;
  String? _selectedFilePath;
  String? abc = "";
  double dialogHeight = 50;
  bool isSignatureChecked = false;
  int? outputOption = 0;
}

class Func {
  Future<Uint8List?>? getImage(IGlobal global, ImageSource source) async {
    XFile? pickedImage;
    Uint8List? imageBytes;

    if (source == ImageSource.camera &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    } else {
      pickedImage = await ImagePicker().pickImage(source: source);
    }

    if (pickedImage != null) {
      imageBytes = await pickedImage.readAsBytes();
    }

    return imageBytes;
  }

  Future<Map<String, dynamic>?> imageToDocumentAi(
    IGlobal global,
    Uint8List imageBytes,
  ) async {
    AutoRefreshingAuthClient client;
    dynamic response;

    client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        global.CoreStatic.coreConst.credential.google.serviceAccount,
      ),
      ["https://www.googleapis.com/auth/cloud-platform"],
    );

    final accessToken = client.credentials.accessToken.data.toString();

    log(accessToken);

    final uri = global.CoreStatic.coreConst.www.documentAI.host;
    final path = global.CoreStatic.coreConst.www.documentAI.path;

    response = await Request.post(
      uri,
      path,
      null,
      {
        HttpHeaders.authorizationHeader:
            'Bearer ya29.a0Ad52N39I1Yin0zqGjXGKOEPeDwRuGnc2TZ7pb_Qf3T2CCXp8k8hxzLCQj_vW7yQ_Md_vsHfD1L35E8y4Q5ePpI8ybA7W2e3V3QxL7i0Tl6zyqqRpTlE8FmHH8GVD_XUhq0X-ZuJYNfWtfRAp2dPXY1Nsh2KznJDrCzJhaCgYKAVUSARESFQHGX2MiIdXrR8F17OCYwYhNwqZXww0171',
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
      {
        "skipHumanReview": true,
        "rawDocument": {
          "mimeType": "application/pdf",
          "content": base64Encode(imageBytes),
        },
      },
    );

    log(response.toString());

    client.close();

    return response;
  }

  Future<Uint8List?> getFileByte(global) async {
    FilePickerResult? result;
    Uint8List? imagebyte;
    result = await FilePicker.platform.pickFiles();
    imagebyte = result?.files.single.bytes;
    return imagebyte;
  }
}

class _PageHome extends Template<PageHome, Param, Func> {
  Atom createOverlayBg() {
    var ok;
    return Atom(
      thing: Thing(
        one: Content(
          dataList: [
            EffectGalaxy(fragment: widget.galaxyEffect),
            EffectTextShuffle(
              mottoList: const [
                'Motto 1',
                'Motto 2',
                'Motto 3',
                // Add more mottos as needed
              ],
            ),
          ],
        ),
      ),
      style: Style(
        height: CoreStatic.coreVar.size.height,
        width: CoreStatic.coreVar.size.width,
      ),
    );
  }

  Atom createGalaxyEffect() {
    return Atom(
      style: Style(
        height: CoreStatic.coreVar.size.height,
        width: CoreStatic.coreVar.size.width,
      ),
    );
  }

  Atom createBottomDraggable() {
    List<Widget> items = [
      SizedBox(
        width: CoreStatic.coreVar.size.width,
        child: const Center(
          child: ListTile(leading: Icon(Icons.drag_handle_rounded)),
        ),
      ),
      DefaultCarousel(fragment: widget.infoCarousell),
      TileAccordion(fragment: widget.aboutMeAccordion),
    ];

    return Atom(
      thing: Thing(
        one: Content(
          style: Style(
            backgroundColor: const Color.fromARGB(255, 8, 16, 32),
            border: Side(topLeft: Box(radius: 10), topRight: Box(radius: 10)),
          ),
        ),
        multiple: items.map((e) => Content(widget: e)).toList(),
      ),
      style: Style(
        height: CoreStatic.coreVar.size.height,
        backgroundColor: const Color.fromARGB(255, 22, 0, 48),
      ),
    );
  }

  Atom createTabLayout() {
    return Atom(
      thing: Thing(
        multiple: [
          Content(
            data: Data(title: "About me"),
            dataList: [BottomDraggable(fragment: widget.bottomDraggable)],
          ),
          Content(
            data: Data(title: "Project"),
            dataList: [OrderedLayout(fragment: widget.projectLayout)],
          ),
          Content(
            data: Data(title: "Contact"),
            dataList: [OrderedLayout(fragment: widget.contactButton)],
          ),
        ],
      ),
      style: Style(width: param.screenWidth, height: param.screenHeight),
    );
  }

  Atom createInfoCarousel() {
    return Atom();
  }

  Atom createInfoRadio() {
    List<dynamic> list = [
      {"title": "home", "selected": true, "function": () {}},
      {"title": "login", "function": () {}},
      {"title": "register", "function": () {}},
    ];

    List<Content> content = list.map((value) {
      FlatAtom flatAtom = FlatAtom.fromMap(value);

      return Content(
        data: Data(title: flatAtom.title, selected: flatAtom.selected),
        function: flatAtom.function,
      );
    }).toList();

    return Atom(
      thing: Thing(multiple: content),
      style: Style(width: 200, height: 200),
    );
  }

  Atom createInfoImage() {
    return Atom(
      thing: Thing(
        one: Content(
          data: Data(
            path:
                "${global.CoreStatic.coreConst.www.myWorldBox.host}${global.CoreStatic.coreConst.www.myWorldBox.path}/image/portrait/VL_0.jpeg",
          ),
        ),
      ),
      style: Style(width: 300, height: 300),
    );
  }

  Atom createColoredMapOrderedLayout() {
    return Atom(
      thing: Thing(
        any: List.generate(
          100,
          (_) =>
              Container(width: 50, height: 50, color: Generate.randomColor()),
        ),
      ),
      style: Style(
        width: param.screenWidth,
        margin: Side(
          left: Box(width: 10),
          top: Box(width: 10),
          right: Box(width: 10),
          bottom: Box(width: 10),
        ),
      ),
    );
  }

  Atom createSpan(double width, double height) {
    return Atom(
      thing: Thing(
        one: Content(
          dataList: [SizedBox(width: width, height: height)],
        ),
      ),
      style: Style(width: width, height: height),
    );
  }

  Atom createInfoTwoArrayLayout() {
    return Atom(
      thing: Thing(
        any: [
          [const Text("1")],
          [const Text("4"), const Text("5"), const Text("6")],
          [const Text("7"), const Text("8"), const Text("9")],
        ],
      ),
      style: Style(width: param.screenWidth, height: param.screenHeight),
    );
  }

  Atom createInfoModal() {
    return Atom(
      thing: Thing(
        one: Content(
          data: Data(title: "About Me", body: "HKUST Computer Engineering"),
          style: Style(
            backgroundColor: Colors.deepPurple,
            height: 500,
            width: 500,
          ),
        ),
      ),
      style: Style(width: 800.0, height: 800),
    );
  }

  Atom createAboutMeAccordion() {
    return Atom();
  }

  Atom createProjectList() {
    Atom eachAccordion(FlatAtom e) {
      return Atom(
        thing: Thing(
          one: Content(
            data: Data(title: e.title, body: e.hint),
          ),
        ),
        style: Style(width: param.screenWidth),
      );
    }

    dynamic project = [];

    List<Widget> items = [
      if (project is Iterable)
        for (var e in project)
          DefaultAccordion(fragment: eachAccordion(FlatAtom.fromMap(e))),
    ];

    return Atom(
      thing: Thing(any: items),
      style: Style(width: param.screenWidth),
    );
  }

  Atom createNavigationDropdown() {
    return Atom(
      thing: Thing(
        multiple: [
          Content(
            function: () {},
            data: Data(title: "home"),
          ),
          Content(
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageHome()),
              );
            },
            data: Data(title: "database"),
          ),
          Content(
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageDatabase()),
              );
            },
            data: Data(title: "dashboard"),
          ),
          Content(
            function: () {},
            data: Data(title: "Login"),
          ),
        ],
      ),
      style: Style(width: 100.0, height: 50),
    );
  }

  Atom createLoginButton() {
    return Atom(
      thing: Thing(
        one: Content(
          function: () {
            param.abc = "abc";
            create(ui);
          },
          data: Data(title: "Login"),
          style: Style(backgroundColor: Colors.black),
        ),
      ),
      style: Style(
        width: 150.0,
        height: 50,
        margin: Side(
          left: Box(width: 5),
          right: Box(width: 5),
          top: Box(width: 5),
          bottom: Box(width: 5),
        ),
      ),
    );
  }

  Atom createContactButton() {
    Atom eachButton(FlatAtom e) {
      return Atom(
        thing: Thing(
          one: Content(
            image: Side(left: Box(icon: e.icon)),
            function: e.function,
            // data: Data(title: e.title),
            style: Style(
              backgroundColor: Colors.black,
              padding: Side(
                left: Box(width: 1),
                top: Box(width: 1),
                right: Box(width: 1),
                bottom: Box(width: 1),
              ),
            ),
          ),
        ),
        style: Style(
          width: 80.0,
          height: 60,
          margin: Side(
            left: Box(width: 5),
            top: Box(width: 5),
            right: Box(width: 5),
            bottom: Box(width: 5),
          ),
        ),
      );
    }

    List<Widget> items = [
      for (var e in [
        {"title": "github", "icon": FontAwesomeIcons.github, "function": () {}},
        {"title": "meta", "icon": FontAwesomeIcons.meta, "function": () {}},
        {
          "title": "youtube",
          "icon": FontAwesomeIcons.youtube,
          "function": () {},
        },
        {
          "title": "stackoverflow",
          "icon": FontAwesomeIcons.stackOverflow,
          "function": () {},
        },
        {
          "title": "bitbucket",
          "icon": FontAwesomeIcons.bitbucket,
          "function": () {},
        },
      ])
        DefaultButton(fragment: eachButton(FlatAtom.fromMap(e))),
    ];

    return Atom(
      thing: Thing(one: Content(dataList: items)),
      style: Style(
        width: param.screenWidth / 2,
        height: param.screenHeight / 2,
        margin: Side(
          left: Box(width: 10),
          top: Box(width: 10),
          right: Box(width: 10),
          bottom: Box(width: 10),
        ),
      ),
    );
  }

  Atom createInfoPopper() {
    return Atom(
      thing: Thing(
        one: Content(
          data: Data(title: "Hello guys"),
          style: Style(backgroundColor: Colors.black),
        ),
      ),
      style: Style(width: 100.0, height: 80),
    );
  }

  @override
  void initState() {
    super.initState();

    create(ui);
  }

  @override
  void didUpdateWidget(PageHome oldWidget) {
    super.didUpdateWidget(oldWidget);

    create(ui);

    log(CoreStatic.coreVar.file.json.global.toString());
  }

  @override
  assign() {
    widget.galaxyEffect = createGalaxyEffect();
    widget.pressButton = createLoginButton();
    widget.infoTwoArrayLayout = createInfoTwoArrayLayout();
    widget.coloredMapOrderedLayout = createColoredMapOrderedLayout();
    widget.infoCarousell = createInfoCarousel();
    widget.aboutMeAccordion = createAboutMeAccordion();
    widget.bottomDraggable = createBottomDraggable();
    widget.infoImage = createInfoImage();
    widget.infoRadio = createInfoRadio();
    widget.infoModal = createInfoModal();
    widget.projectLayout = createProjectList();
    widget.navDropdown = createNavigationDropdown();
    widget.contactButton = createContactButton();
    widget.infoPopper = createInfoPopper();
    widget.tabLayout = createTabLayout();
    widget.overlayBg = createOverlayBg();
  }

  @override
  render() => [
    ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Output Options'),
              content: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      title: const Text('PDF'),
                      value: param.outputOption,
                      groupValue: param.outputOption,
                      onChanged: (value) {
                        param.outputOption = param.outputOption! > 2
                            ? 0
                            : (param.outputOption! + 1);
                        create(ui);
                      },
                    ),
                    RadioListTile(
                      title: const Text('Excel'),
                      value: param.outputOption,
                      groupValue: param.outputOption,
                      onChanged: (value) {
                        param.outputOption = param.outputOption! > 2
                            ? 0
                            : (param.outputOption! + 1);
                        create(ui);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Include Signature'),
                      value: param.isSignatureChecked,
                      onChanged: (value) {
                        param.isSignatureChecked = !param.isSignatureChecked;
                        create(ui);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Perform the desired action here
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirm'),
                ),
                TextButton(
                  onPressed: () {
                    // Perform the desired action here
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Open Dialog'),
    ),
    OverlayLayout(fragment: widget.overlayBg),
    Text(param.abc.toString()),
    DefaultButton(fragment: widget.pressButton),
    Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (param.textScanning) const CircularProgressIndicator(),
              if (!param.textScanning && param.imageFile == null)
                Container(width: 300, height: 300, color: Colors.grey[300]!),
              if (param.imageBytes != null) Image.memory(param.imageBytes!),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey[400],
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          Uint8List? imageByte = await func.getImage(
                            global,
                            ImageSource.gallery,
                          );
                          CoreStatic.coreVar.response = await func
                              .imageToDocumentAi(global, imageByte!);
                          create(ui);
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image, size: 30),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.grey[400],
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        Uint8List? imageByte = await func.getImage(
                          global,
                          ImageSource.camera,
                        );
                        CoreStatic.coreVar.response = await func
                            .imageToDocumentAi(global, imageByte!);
                        create(ui);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera_alt, size: 30),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                param.scannedText,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
    Text(CoreStatic.coreVar.response.toString()),
    if (param.imageBytes != null) Image.memory(param.imageBytes!),
    Text(utf8.decode(param.imageBytes ?? []).toString()),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (param._selectedFilePath != null)
            Expanded(child: Text(Uri.file(param._selectedFilePath!).toString()))
          else
            Text('No file selected'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              Uint8List? imageByte = await func.getFileByte(global);
              CoreStatic.coreVar.response = await func.imageToDocumentAi(
                global,
                imageByte!,
              );
              create(ui);
            },
            child: Text('Select Document'),
          ),
        ],
      ),
    ),
    TabLayout(fragment: widget.tabLayout),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: state == 0 ? null : AppBar(),
      drawer: state == 0
          ? null
          : SizedBox(
              width: state == 1 ? 50 : 150,
              child: Drawer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: drawer,
                ),
              ),
            ),
      body: SafeArea(child: body),
      floatingActionButton: state == 0 ? actionButton : null,
    );
  }

  @override
  Param param = Param<Local>(Local());

  @override
  Utility utility = Utility();
}
