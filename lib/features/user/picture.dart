import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../config/constants.dart';
import '../../config/state.dart';
import '../../presentation/theme.dart';
import '../../presentation/utils.dart';
import '../auth/service.dart';

class ProfilePicture extends StatelessWidget {
  final String? url;
  final bool canEdit;
  final bool alternateNoPicture;
  const ProfilePicture({
    required this.url,
    required this.canEdit,
    this.alternateNoPicture = false,
  });

  @override
  Widget build(BuildContext context) {
    final url = this.url;
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

    final controller = EntryController();
    controller.insert(
      context,
      OverlayEntry(
        builder: (context) => Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(200),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                'Modificando a imagem de perfil...',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ),
        ),
      ),
    );

    final authService = UserAuthService();
    authService
        .setProfilePicture(
          AppState.auth.currentUser!.uid,
          File(image.path),
        )
        .then((e) => controller.remove());
  }
}
