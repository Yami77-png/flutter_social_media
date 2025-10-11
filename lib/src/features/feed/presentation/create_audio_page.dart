import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/src/core/helpers/media_picker_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_extensions.dart';
import 'package:flutter_social_media/src/core/utility/app_local_audio_player.dart';
import 'package:flutter_social_media/src/core/utility/app_text_field.dart';
import 'package:flutter_social_media/src/core/utility/components/app_drop_down.dart';
import 'package:flutter_social_media/src/features/feed/application/create_audio_cubit/create_audio_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/audio_cover_photo_selection_buttons.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_appbar.dart';

class CreateAudioPage extends StatefulWidget {
  static const String route = 'create_audio_page';
  const CreateAudioPage({super.key});

  @override
  State<CreateAudioPage> createState() => _CreateAudioPageState();
}

class _CreateAudioPageState extends State<CreateAudioPage> {
  final titleTEC = TextEditingController();
  final artistTEC = TextEditingController();
  final audioNameTEC = TextEditingController();
  String? _selectedType;
  File? _coverImage;
  bool coverPhotoSelected = false;

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    log('pickedFile: ${pickedFile}');

    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
        coverPhotoSelected = true;
      });
    }

    log('cover image: ${_coverImage?.path}');
    _validatePostContent();
  }

  final MediaPickerHelper _mediaPicker = MediaPickerHelper();
  File? _audioFile;

  void _pickAudio() async {
    final file = await _mediaPicker.pickAudio();
    if (file != null) {
      setState(() {
        _audioFile = file;
        audioNameTEC.text = file.path.split('/').last;
      });
    }
    _validatePostContent();
  }

  bool _canPost = false;
  void _validatePostContent() {
    final hasTitle = titleTEC.text.trim().isNotEmpty;
    final hasArtist = artistTEC.text.trim().isNotEmpty;
    final hasAudioName = audioNameTEC.text.trim().isNotEmpty;
    final hasAudioType = _selectedType != null;
    final hasCoverImage = _coverImage != null;
    final hasMedia = _audioFile != null;

    final isValid = hasTitle && hasArtist && hasAudioName && hasAudioType && hasCoverImage && hasMedia;

    if (_canPost != isValid) {
      setState(() {
        _canPost = isValid;
      });
    }
  }

  void _publishAudio(BuildContext context) {
    context.read<CreateAudioCubit>().createAudio(
      title: titleTEC.text.trim(),
      artist: artistTEC.text.trim(),
      audioType: _selectedType ?? '',
      coverImageFile: _coverImage!,
      audioFile: _audioFile!,
    );

    // Immediately navigate back to the feed.
    if (context.canPop()) {
      context.pop();
    } else {
      // Fallback if it can't be popped (e.g., deep link)
      context.goNamed(NavWrapperPage.route);
    }
  }

  @override
  void initState() {
    super.initState();

    titleTEC.addListener(_validatePostContent);
    artistTEC.addListener(_validatePostContent);
    audioNameTEC.addListener(_validatePostContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostAppbar(
        title: 'AUDIO',
        onTap: _canPost ? () => _publishAudio(context) : null,
        publishColor: _canPost ? AppColors.primaryColor : Colors.grey.shade400,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 16,
            children: [
              InkWell(
                onTap: _pickCoverImage,
                child: Container(
                  height: 225,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _coverImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_coverImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 14,
                          children: [Icon(Icons.file_upload_outlined), Text('Select cover picture')],
                        ),
                ),
              ),
              // Cover Photo Selection Buttons
              AudioCoverPhotoSelectionButtons(coverPhotoSelected: coverPhotoSelected, pickCoverImage: _pickCoverImage),
              AppTextField(controller: titleTEC, labelText: 'Title'),
              AppDropDown(
                value: _selectedType,
                hintText: 'Audio Type',
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                  });
                },
                items: AudioType.values.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(value: value.name, child: Text(value.name.capitalFirstLetter()));
                }).toList(),
              ),
              AppTextField(controller: artistTEC, labelText: 'Artist'),
              AppTextField(
                controller: audioNameTEC,
                labelText: 'Audio',
                suffixIcon: Icon(Icons.attachment, color: Colors.black54),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _pickAudio();
                },
              ),
              AppLocalAudioPlayer(file: _audioFile),
            ],
          ),
        ),
      ),
    );
  }
}
