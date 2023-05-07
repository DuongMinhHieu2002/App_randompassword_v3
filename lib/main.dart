import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';


void main() => runApp(MyApp());

enum Page { CurrentPassword, PasswordHistory }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Password Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.amberAccent[200],
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkModeEnabled = false;
  final LongPressGestureRecognizer _longPressGestureRecognizer =
      LongPressGestureRecognizer();
  bool _showSpecialCharacters = false;
  String _password = '';
  bool _excludeNumbers = false;
  bool _shortPassword = false;
  bool _longPasword = false;
  bool _uppercaseOnly = false;
  bool _useCustomCharacters = false;
  String _customCharacters = '';
  Page _currentPage = Page.CurrentPassword;
  int _length = 17;
  List<History> _passwordHistory = [];
  bool _iconBool = false;

  ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    brightness: Brightness.light
  );
  ThemeData _darkTheme = ThemeData(
      primarySwatch: Colors.deepOrange,
      brightness: Brightness.dark
  );
  IconData _iconLight = Icons.wb_sunny;
  IconData _iconDark = Icons.nights_stay;

  void _generatePassword() {
    String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_showSpecialCharacters) {
      chars += '!@#\$%^&*()';
    }

    final String numbers = '0123456789';
    final Random rand = Random();
    String newPassword = '';

    if (_shortPassword) {
      setState(() {
        _length = 9;

      });
    }
    if (_longPasword){
      setState(() {
        _length=17;

      });
    }

    for (int i = 0; i < _length; i++) {
      String char = chars[rand.nextInt(chars.length)];
      if (_uppercaseOnly && !_useCustomCharacters) {
        char = char.toUpperCase();

      }
      else if (_useCustomCharacters && _customCharacters.isNotEmpty) {
        chars='';
        chars += _customCharacters;
        if (_uppercaseOnly){
          chars=chars.toUpperCase();
        }
        if (_showSpecialCharacters){
          chars = chars + '!@#\$%^&*()';
        }
      }
      if (_excludeNumbers ) {
        chars += numbers;}
      newPassword += char;

    }
    newPassword = newPassword.substring(1);
    setState(() {
      _password = newPassword;
      if (_currentPage == Page.CurrentPassword) {
        _addToHistory(new History(input: _password, output: ''));
      }
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _copyHistoryToClipboard(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addToHistory(History history) {
    setState(() {
      _passwordHistory.insert(0, history);
    });
  }

  Widget _buildCurrentPasswordPage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _password='';
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Generate my Password'),
              onPressed: _generatePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Copy to your Clipboard'),
              onPressed: _copyToClipboard,
            ),
            SizedBox(height: 20),
            Expanded(
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Text('Custom length password'),
                        SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: FloatingActionButton(
                            onPressed: () {
                              if (_length>9){
                                setState(() {
                                  _length --;
                                });
                              }
                            },
                            child: Icon(Icons.remove),
                            mini: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Theme.of(context).primaryColorDark),
                          ),
                          child: Center(
                            child: Text(
                              '${_length - 1}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: FloatingActionButton(
                            onPressed: () {
                              if (_length<19){
                                setState(() {
                                  _length++;
                                });
                              }
                            },
                            child: Icon(Icons.add),
                            mini: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Checkbox(
                          value: _useCustomCharacters,
                          onChanged: (bool? value) {
                            setState(() {
                              _useCustomCharacters = value ?? false;

                              if(_useCustomCharacters == true) {_excludeNumbers = false;_showSpecialCharacters = false; }

                            });
                          },
                        ),
                        // Text('Use custom characters'),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            enabled: _useCustomCharacters,
                            onChanged: (value) {
                              setState(() {
                                _customCharacters = value;

                              });

                            },
                            decoration: InputDecoration(
                              hintText: 'Enter custom characters',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _excludeNumbers,
                          onChanged: (bool? value) {
                            setState(() {
                              _excludeNumbers = value ?? false;
                            });
                          },
                        ),
                        Text('Include numbers'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _shortPassword,
                          onChanged: (bool? value) {
                            setState(() {
                              _shortPassword = value ?? false;
                              _longPasword = false;
                              _length = 9;
                            });
                          },
                        ),
                        Text('Short password'),
                      ],
                    ),
                    SizedBox(height: 20 ,),
                    Row(
                      children: [
                        Checkbox(
                          value: _longPasword,
                          onChanged: (bool? value) {
                            setState(() {
                              _longPasword = value ?? false;
                              _shortPassword = false;
                              _length = 17;
                            });
                          },
                        ),
                        Text('Long password'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _uppercaseOnly,
                          onChanged: (bool? value) {
                            setState(() {
                              _uppercaseOnly = value ?? false;
                            });
                          },
                        ),
                        Text('Uppercase only'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _showSpecialCharacters,
                          onChanged: (bool? value) {
                            setState(() {
                              _showSpecialCharacters = value ?? false;
                            });
                          },
                        ),
                        Text('Show special characters'),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildPasswordHistoryPage() {
    if (_passwordHistory.isEmpty) {
      return Center(
        child: Text(
          'No password history available.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: _passwordHistory.length,
      itemBuilder: (context, index) {
        final history = _passwordHistory[index];
        return GestureDetector(
          onLongPress: () {
            setState(() {
              _passwordHistory.removeAt(index);
            });
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Điều chỉnh vị trí đổ bóng
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '${history.input}',
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(
                          color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordHistory.removeAt(index);
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[500],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _copyToClipboard();
                    },
                    icon: Icon(Icons.copy,
                    color: Colors.grey,),
                  ),
                ],
              )
          ),
        );
      },
    );
  }

  Widget _buildCurrentPage() {
    if (_currentPage == Page.CurrentPassword) {
      return _buildCurrentPasswordPage();
    } else {
      return _buildPasswordHistoryPage();
    }
  }

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _currentPage = index == 0 ? Page.CurrentPassword : Page.PasswordHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "hello",
      debugShowCheckedModeBanner: false,
      theme: _iconBool ? _darkTheme : _lightTheme,
      home :
      Scaffold(
        appBar: AppBar(
          title: Text('Random Password Generator'),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                _iconBool = !_iconBool;
                // print("${_iconBool}");
              });
            }, icon:Icon(_iconBool ? _iconDark : _iconLight))
          ],
        ),
        body: _buildCurrentPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage == Page.CurrentPassword ? 0 : 1,
          onTap: _onBottomNavigationBarItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              label: 'Current Password',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Password History',
            ),
          ],
        ),
      ),
    );
  }
}

class History {
  final String input;
  final String output;

  History({required this.input, required this.output});
}
