import 'dart:io';
import 'package:flutter/material.dart';
import '../data/dogs_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/photo_picker.dart';
import '../widgets/ulvenik_icon.dart';
import 'dog_profile_screen.dart';

/// Create Dog Profile: name, breed, age, sex, My Dog / Client Dog and an
/// optional photo, saved to the real DogsStore. Opens the new dog's profile
/// on save (Dogs & Goals handover, "Add Dog").
class AddDogScreen extends StatefulWidget {
  final bool hasTrainerPack;
  const AddDogScreen({super.key, this.hasTrainerPack = true});

  @override
  State<AddDogScreen> createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _name = TextEditingController();
  final _breed = TextEditingController();
  final _age = TextEditingController();
  final _owner = TextEditingController();
  String _sex = 'Male';
  bool _isClient = false;
  String? _photoPath;
  String? _nameError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _age.dispose();
    _owner.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path = await pickPhotoPath(context);
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  void _save() {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = 'Please enter a dog name.');
      return;
    }
    _saving = true;
    final dog = DogsStore.instance.create(
      name: _name.text.trim(),
      breed: _breed.text.trim().isEmpty ? 'Mixed Breed' : _breed.text.trim(),
      age: _age.text.trim(),
      sex: _sex,
      isClient: _isClient,
      ownerName: _isClient && _owner.text.trim().isNotEmpty ? _owner.text.trim() : null,
      localPhotoPath: _photoPath,
    );
    AppSnackbar.show(context, message: '${dog.name} added', type: SnackbarType.success);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DogProfileScreen(dogName: dog.name)));
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: 'Add Dog',
      bottom: PrimaryButton(label: 'Save Dog', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 96,
                    height: 96,
                    color: AppColors.cardsCarbon,
                    child: _photoPath == null
                        ? Center(child: UlvenikIcon(UlvenikIcons.dogs, size: 34, color: AppColors.secondarySage))
                        : Image.file(File(_photoPath!), fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Center(
                                child: UlvenikIcon(UlvenikIcons.dogs, size: 34, color: AppColors.secondarySage))),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen, shape: BoxShape.circle),
                    child: Icon(Icons.add_a_photo_outlined, color: AppColors.primaryTextOffWhite, size: 15),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          const FieldLabel('Dog Name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter your dog\'s name', error: _nameError),
          ),
          const FieldLabel('Breed'),
          TextField(
            controller: _breed,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Golden Retriever'),
          ),
          const FieldLabel('Age'),
          TextField(
            controller: _age,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. 2 yrs'),
          ),
          const FieldLabel('Sex'),
          Row(children: [
            for (final s in const ['Male', 'Female']) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _sex = s),
                  child: Container(
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _sex == s ? AppColors.primaryForestGreen.withValues(alpha: 0.18) : AppColors.cardsCarbon,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _sex == s ? AppColors.primaryForestGreen : AppColors.cardBorder),
                    ),
                    child: Text(s,
                        style: TextStyle(
                            color: _sex == s ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              if (s == 'Male') const SizedBox(width: 10),
            ],
          ]),
          if (widget.hasTrainerPack) ...[
            const FieldLabel('Dog Type'),
            Row(children: [
              for (final c in const [false, true]) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isClient = c),
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isClient == c ? AppColors.primaryForestGreen.withValues(alpha: 0.18) : AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _isClient == c ? AppColors.primaryForestGreen : AppColors.cardBorder),
                      ),
                      child: Text(c ? 'Client Dog' : 'My Dog',
                          style: TextStyle(
                              color: _isClient == c ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                if (c == false) const SizedBox(width: 10),
              ],
            ]),
            if (_isClient) ...[
              const FieldLabel('Owner Name'),
              TextField(
                controller: _owner,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Enter the owner\'s name'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
