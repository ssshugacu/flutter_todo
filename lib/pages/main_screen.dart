import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: themeProvider.themeData,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Route _settingsRoute(BuildContext context) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Меню')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Основная тема',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setTheme(ThemeData.light());
                      },
                      icon: Icon(Icons.crop_square_rounded, size: 55.0),
                    ),
                    IconButton(
                      onPressed: () {
                        // Provider.of<ThemeProvider>(context, listen: false)
                        //     .setTheme(ThemeData.dark());
                      },
                      icon: Icon(
                        Icons.square_rounded, color: Colors.black, size: 50.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Язык',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(onPressed: () {},
                          child: Text('Русский', style: TextStyle(fontSize: 20.0),)),
                    ),
                    TextButton(onPressed: () {},
                        child: Text('English', style: TextStyle(fontSize: 20.0))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Список дел'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, _settingsRoute(context));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => true);
                },
                child: Text('Список задач', style: TextStyle(color: Colors.white, fontSize: 30)),
                style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent)
            ),
            Padding(padding: EdgeInsets.all(50.0)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/calendar', (route) => true);
                },
                child: Text('Календарь', style: TextStyle(color: Colors.white, fontSize: 30)),
                style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent)
            ),
          ],
        ),
      ),
    );
  }
}
