import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSettingsOption('Change Theme', _changeTheme),
                _buildSettingsOption('Manage Storage', _manageStorage),
                _buildSettingsOption('Notification Settings', _notificationSettings),
                _buildSettingsOption('About App', _aboutApp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.blue.withOpacity(0.8),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      SystemChrome.setSystemUIOverlayStyle(
        _isDarkTheme
            ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
        )
            : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
        ),
      );
    });
  }

  void _manageStorage() {
    // Handle storage management
    print('Manage Storage Pressed');
  }

  void _notificationSettings() {
    // Handle notification settings
    print('Notification Settings Pressed');
  }

  void _aboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About App'),
        content: Text(
          'Music Player v1.0\nDeveloped by Ahtisham And Danish',
          style: TextStyle(color: Colors.black),  // Set text color to black
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
