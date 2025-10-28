import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userId, super.key});

  final String userId;

  static const routeName = 'profile';
  static const routePath = '/profile/:userId';
  static const routePattern = 'profile/:userId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile #$userId')),
      body: Center(child: Text('Profile details for user $userId go here.')),
    );
  }
}
