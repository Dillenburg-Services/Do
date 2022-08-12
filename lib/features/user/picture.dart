import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../config/constants.dart';
import '../../config/state.dart';
import '../../presentation/theme.dart';
import '../auth/service.dart';

class ProfilePicture extends StatelessWidget {
  final String uid;
  final String? url;
  final bool alternateNoPicture;
  const ProfilePicture({
    required this.uid,
    required this.url,
    this.alternateNoPicture = false,
  });

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    final canEdit = uid == AppState.auth.currentUser!.uid;
    return GestureDetector(
      onTap: canEdit ? () => _changeProfilePic(context) : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow()],
                image: (url == null)
                    ? null
                    : DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
              ),
              child: (url == null)
                  ? Assets.profilePicture(alternate: alternateNoPicture)
                  : null,
            ),
            if (canEdit)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).darkest.darken(6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(FontAwesomeIcons.pen, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeProfilePic(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final authService = UserAuthService();
    final uid = context.read<UserCredential?>()!.user!.uid;
    await authService.setProfilePicture(uid, File(image.path));
  }
}