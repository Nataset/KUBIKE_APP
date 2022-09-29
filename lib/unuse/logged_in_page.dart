import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoggedInPage extends StatelessWidget {
  final GoogleSignInAccount user;
  final GoogleSignInAuthentication googleAuth;

  const LoggedInPage({super.key, required this.user, required this.googleAuth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Profile',
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  user.photoUrl ?? 'https://via.placeholder.com/150'),
            ),
            Text(
              'Name: ' + user.displayName! ?? 'Not Found',
            ),
            Text('Email: ' + user.email),
            // Text('TokenId: ' + googleAuth.idToken ?? 'Not Found'),
            // Text('Token: ' + googleAuth.accessToken! ?? 'Not Found')
          ],
        ),
      ),
    );
  }
}
