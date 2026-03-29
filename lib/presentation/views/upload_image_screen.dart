import 'dart:io';
import 'package:ai_outfit_recommender/core/utils/app_strings.dart';
import 'package:ai_outfit_recommender/core/utils/app_images.dart';
import 'package:ai_outfit_recommender/core/utils/Flushbar_helper.dart';
import 'package:ai_outfit_recommender/core/utils/validators.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/upload_image_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/utils/image_picker_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_textField.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  //---[Controllers]---
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();

  //---[Variables]---
  final _formKey = GlobalKey<FormState>();
  File? _image;

  //---[Pick Image Function]---

  void pickImage() async {
    final image = await ImagePickerHelper.pickImage();
    if (image != null) {
      setState(() {
        _image = image;
      });
    } else {
      _image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---[Appbar]---
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appBar,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          AppStrings.uploadImage,
          style: TextStyle(color: AppColors.card, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //---[Stuff Container]---
                Stack(
                  children: [
                    CustomContainer(
                      fileImage: _image,
                      isFileImage: true,
                      imagePath: AppImages.camera,
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: _image != null
                          ? Image.file(_image!)
                          : Icon(Icons.camera_alt, size: 100),
                    ),
                    Positioned(
                      right: 10,
                      top: 30,
                      child: InkWell(
                        onTap: () {
                          _image = null;
                          setState(() {});
                        },
                        child: _image != null
                            ? Icon(Icons.highlight_remove_outlined, size: 30)
                            : SizedBox(),
                      ),
                    ),

                    //---[Outline Button Add Photo And Details]---
                    Positioned(
                      right: 110,
                      bottom: 60,
                      child: _image != null
                          ? SizedBox()
                          : Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: pickImage,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey.shade800,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Add Photo',
                                        style: AppTextStyles.smallText.copyWith(
                                          color: Colors.grey.shade800,
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
                SizedBox(height: 5),

                //---[TextFormFields]---

                //Category TextFormFields
                _buildText(
                  'Category:',
                  CustomTextField(
                    controller: categoryController,
                    validator: ValidatorsHelper.category,
                    hintText: 'Choose Category',
                    icon: Icons.category,
                  ),
                ),
                Divider(),

                //Color TextFormFields
                _buildText(
                  'Color:',
                  CustomTextField(
                    controller: colorController,
                    validator: ValidatorsHelper.color,

                    hintText: 'Choose Color',
                    icon: Icons.color_lens,
                  ),
                ),
                Divider(),

                //Season TextFormFields
                _buildText(
                  'Season:',
                  CustomTextField(
                    controller: seasonController,
                    validator: ValidatorsHelper.season,

                    hintText: 'Select Season',
                    icon: Icons.sunny,
                  ),
                ),
                Divider(),

                SizedBox(height: 25),

                //---[Save Button]---
                Consumer<UploadImageVM>(
                  builder: (context, vm, child) => CustomButton(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 1.2,

                    onTap: () async {
                      final isValid = _formKey.currentState!.validate();
                      if (_image == null) {
                        FlushbarHelperMessage.showMessage(
                          icon: Icon(Icons.warning, color: Colors.red),
                          color: Colors.white,

                          context: context,
                          message: 'Image Not Selected',
                          background: Colors.orange,
                        );
                        return;
                      }
                      if (isValid) {
                        await vm.saveData(
                          _image!,
                          categoryController.text,
                          colorController.text,
                          seasonController.text,
                        );

                        //---[Success Flushbar]---

                        FlushbarHelperMessage.showMessage(
                          icon: Icon(Icons.check_circle, color: Colors.white),
                          color: Colors.white,

                          context: context,
                          message: 'Data Saved Successfully',
                          background: Colors.green,
                        );
                      } else {
                        //---[Error Flushbar]---

                        FlushbarHelperMessage.showMessage(
                          icon: Icon(Icons.warning, color: Colors.white),
                          color: Colors.white,

                          context: context,
                          message: 'Please fill all the fields Correctly',
                          background: Colors.red,
                        );
                      }
                    },
                    child: vm.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Save',
                            style: AppTextStyles.appTitle.copyWith(
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Text
  Widget _buildText(String cat, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cat, style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
          SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}
