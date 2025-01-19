import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NUSQAU',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 16
          ),
          bodySmall: TextStyle(
            color: Colors.white54,
            fontFamily: 'Montserrat',
            fontSize: 14
          )
        ),
      ),
      home: const BottomNavBar(), 
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    Home(),
    CameraPage(),
    ChatBot(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      bottomNavigationBar: _currentIndex != 1 
      ? ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
          },
        items: [
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/img_home_7_2.png'), color: Colors.white),
            label: '',
            backgroundColor: Color.fromARGB(255, 255, 255, 255)
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: ''
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/img_chat_1.png'), color: Colors.white),
            label: ''
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      ),
      )
      :null
    );
  }
}
class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), 
            color: const Color.fromARGB(255, 139, 14, 244),
          ),
          child: const Center(
          ),
        ),
        const Positioned(
          top: 10,
          left: 10,
          child: ImageIcon(
              AssetImage('assets/images/img_scan_1.png'),
              color: Colors.white,
              size: 30,
            ),
        ),
      ],
    );
  }
}
class CustomSend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), 
            color: const Color.fromARGB(255, 139, 14, 244),
          ),
          child: const Center(
          ),
        ),
        const Positioned(
          top: 12,
          left: 12,
          child: ImageIcon(
              AssetImage('assets/images/send.png'),
              color: Colors.white,
              size: 30,
            ),
        ),
      ],
    );
  }
}

class Home extends StatelessWidget {
  final List<String> machines = [
    "Cable Machine",
    "Chest Press Machine",
    "Elliptical Trainer",
    "Lat Pulldown Machine",
    "Leg Extension Machine",
    "Leg Press Machine",
    "Rowing Machine",
    "Smith Machine",
    "Stationary Bike",
    "Treadmill"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 4.0,
            width: 2000.0,
            color: const Color.fromARGB(255, 139, 14, 244),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: machines.length,
              itemBuilder: (context, index) {
                return Container(
                  color: const Color.fromARGB(255, 28, 28, 28),
                  child: ListTile(
                    title: Text(machines[index], style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () => showDescription(context, machines[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
    );
  }

}

class MachineDetails extends StatelessWidget {
  final String machineName;
  final String description;
  final String img;

  const MachineDetails({
    Key? key,
    required this.machineName,
    required this.description,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(machineName, style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      ),
      body: Column(
        children: [
          Container(
            height: 4.0,
            width: 2000.0,
            color: const Color.fromARGB(255, 139, 14, 244),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(img),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
    );
  }
}

late List<CameraDescription> _cameras;

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late Timer timer;
  bool isCapturing = false;
  String detectedObject = '';
  late File? _image;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (!isCapturing) {
          captureAndSendImage();
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); 
    controller.dispose();
    super.dispose();
  }

  Future<void> captureAndSendImage() async {
    if (!controller.value.isInitialized) {
      return;
    }

    if (!isCapturing) {
      try {
        isCapturing = true;
        XFile imageFile = await controller.takePicture(); 

        File file = File(imageFile.path);

        var request = http.MultipartRequest(
            'POST', Uri.parse('http://192.168.1.96:5000/predict'));


        request.files.add(http.MultipartFile(
          'image',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'), 
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          print('Image sent successfully');
          String responseBody = await response.stream.bytesToString();
          Map<String, dynamic> data = jsonDecode(responseBody);
          String predictedLabel = data['predicted_label'];
          setState(() {
            detectedObject = predictedLabel; 
          });
        } else {
          print('Error sending image: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending image to server: $e');
      } finally {
        isCapturing = false; 
      }
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.1.96:5000/predict'));
      request.files.add(http.MultipartFile(
        'image',
        _image!.readAsBytes().asStream(),
        _image!.lengthSync(),
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image sent successfully');
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = jsonDecode(responseBody);
        String predictedLabel = data['predicted_label'];
        setState(() {
          detectedObject = predictedLabel; 
        });
      } else {
        print('Error sending image: ${response.statusCode}');
      }
    } else {
      print('No image selected.');
    }
  }
  void _showMachineDetails(String machineName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MachineDetails( machineName: detectedObject, img: detectedObject, description: detectedObject,
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  if (!controller.value.isInitialized) {
    return Container();
  }
  return WillPopScope(
    onWillPop: () async {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (Route<dynamic> route) => false,
      );
      return false;
    },
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scan', style: Theme.of(context).textTheme.bodyMedium),
          backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        ),
        body: Column(
          children: [
            Container(
              height: 4.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 139, 14, 244),
            ),
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          Container(
                             width: double.infinity,
                            height: 230,
                            color: const Color.fromARGB(255, 22, 22, 22),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                if (detectedObject.isNotEmpty)
                                Container(
                                height: 75,
                                  width: screenWidth * 0.9,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(255, 28, 28, 28),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      showDescription(context, detectedObject);
                                    },
                                    child: Text('Detected Object: $detectedObject', style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                  ),
                                  Spacer(),
                                    Container(
                                      height: 75,
                                      width: screenWidth * 0.9,
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(255, 139, 14, 244),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          _getImageFromGallery();
                                        },
                                        child: Text('Upload Image', style: Theme.of(context).textTheme.bodyMedium),
                                    ),
                                  ),
                                ],
                              ),                                
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      ),
    ),
  );
}
}






class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  _loadMessages() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? savedMessages = _prefs?.getStringList('messages');
    if (savedMessages != null) {
      setState(() {
        _messages.addAll(savedMessages.map((e) => Map<String, String>.from(json.decode(e))));
      });
    }
  }

  _saveMessages() async {
    List<String> messagesToSave = _messages.map((e) => json.encode(e)).toList();
    await _prefs?.setStringList('messages', messagesToSave);
  }

  _sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'content': message});
    });
    _controller.clear();
    _saveMessages();

    var response = await http.post(
      Uri.parse('http://192.168.1.96:5001/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'prompt': message}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _messages.add({'role': 'assistant', 'content': data['response']});
      });
      _saveMessages();
    } else {
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Error: Could not retrieve response from server.'});
      });
      _saveMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NusqauBot', style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        automaticallyImplyLeading: false,
      ),

    body: Column(
  children: [
    Container(
      height: 4.0,
      width: 2000.0,
      color: const Color.fromARGB(255, 139, 14, 244),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isUserMessage = message['role'] == 'user';
          return Align(
            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: isUserMessage ? const Color.fromARGB(255, 139, 14, 244) : const Color.fromARGB(255, 28, 28, 28),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message['content']!,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    isUserMessage ? 'You' : 'NusqauBot',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                labelStyle: Theme.of(context).textTheme.bodySmall
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: CustomSend(),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _sendMessage(_controller.text);
              }
            },
          ),
        ],
      ),
    ),
  ],
),
backgroundColor: const Color.fromARGB(255, 22, 22, 22),
    );
  }
}