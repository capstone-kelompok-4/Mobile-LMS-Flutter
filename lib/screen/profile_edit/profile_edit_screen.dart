import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms/data/model/user/user_model.dart';
import 'package:lms/screen/login/login_view_model.dart';
import 'package:lms/screen/profile_edit/profile_edit_view_model.dart';
import 'package:lms/utils/check_user.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../constants/styles.dart';
import '../../utils/result_state.dart';
import '../../widgets/custom_notification_snackbar.dart';

class ProfileEditScreen extends StatefulWidget {
  static const String routeName = '/profile_edit_screen';
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialistController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _chooseImage(ImageSource source) async {
    final choseImage = await _picker.pickImage(source: source);
    setState(() {
      _image = choseImage;
    });
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select from:",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: colorTextBlue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _chooseImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: colorOrange,
                  ),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(
                    "Gallery",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _chooseImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: colorOrange,
                  ),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(
                    "Camera",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final ProfileEditViewModel profileEditViewModel =
          Provider.of<ProfileEditViewModel>(context, listen: false);
      final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

      profileEditViewModel.changeState(ResultState.loading);
      await CheckUser.isLogin(context);

      final result = await profileEditViewModel.editProfile(
        loginViewModel.userLogin!.id,
        _nameController.text,
        _phoneController.text,
        _image,
        UserDataAddress(
          detailAddress: _addressController.text,
          country: _countryController.text,
          stateProvince: _provinceController.text,
          city: _cityController.text,
          zipCode: _zipCodeController.text,
        ),
      );

      if (result == null) {
        CustomNotificationSnackbar(context: context, message: "Terjadi kesalahan");
        return;
      }

      loginViewModel.getUserPref();
      CustomNotificationSnackbar(context: context, message: "Profil berhasil diubah");
    }
  }

  @override
  void initState() {
    final LoginViewModel loginViewModel = Provider.of(context, listen: false);
    final user = loginViewModel.userLogin;

    _nameController.text = user?.name ?? "";
    _specialistController.text = user?.userSpecialization.name ?? "";
    _emailController.text = user?.email ?? "";
    _phoneController.text = user?.phoneNumber ?? "";
    _addressController.text = user?.address.detailAddress ?? "";
    _countryController.text = user?.address.country ?? "";
    _provinceController.text = user?.address.stateProvince ?? "";
    _cityController.text = user?.address.city ?? "";
    _zipCodeController.text = user?.address.zipCode ?? "";

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialistController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
          decoration:
              BoxDecoration(color: colorBlueDark, borderRadius: BorderRadius.circular(50.0)),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: colorTextBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      bottomNavigationBar: Consumer<ProfileEditViewModel>(builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: model.state == ResultState.loading ? null : () => _updateProfile(),
                  style: ElevatedButton.styleFrom(
                    primary: colorOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    "Simpan",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              if (model.state == ResultState.loading)
                const LinearProgressIndicator(
                  color: colorOrange,
                  backgroundColor: colorGreyLow,
                ),
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        child: Consumer<LoginViewModel>(builder: (context, model, child) {
          final user = model.userLogin;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: colorGreyLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32.0,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () => _pickImage(),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size(85, 85),
                              child: _image != null
                                  ? Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : user?.imageUrl != null && user!.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          user.imageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "assets/images/avatar_example_1.png",
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Text(
                          "Data diri",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: colorBlueDark,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _nameController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "John Doe",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Nama lengkap wajib diisi";
                          }

                          if (value.length < 3) {
                            return "Nama lengkap tidak boleh kurang dari 6 karakter";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Specialist",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _specialistController,
                        autocorrect: false,
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: colorBlueLight,
                          filled: true,
                          hintText: "",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueLight, width: 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueLight, width: 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueLight, width: 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Your email",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _emailController,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "123456@company.com",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Email wajib diisi";
                          }

                          if (value.length < 6) {
                            return "Email tidak boleh kurang dari 6 karakter";
                          }

                          if (!isEmail(value)) {
                            return "Email tidak valid";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Phone Number",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "0853234xxx",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Nomor telepon wajib diisi";
                          }

                          if (value.length < 8) {
                            return "Nomor telepon tidak boleh kurang dari 8 karakter";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Detail Address",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _addressController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Jalan Kenangan Timur",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Alamat wajib diisi";
                          }

                          if (value.length < 6) {
                            return "Alamat tidak boleh kurang dari 6 karakter";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Country",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _countryController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Indonesia",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Negara wajib diisi";
                          }

                          if (value.length < 3) {
                            return "Negara tidak boleh kurang dari 3 karakter";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "State/Province",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: colorTextBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _provinceController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "DKI Jakarta",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: colorBlueDark),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Provinsi wajib diisi";
                          }

                          if (value.length < 3) {
                            return "Provinsi tidak boleh kurang dari 3 karakter";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "City",
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                        color: colorTextBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _cityController,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Jakarta Barat",
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: colorBlueDark),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: colorBlueDark),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Kota wajib diisi";
                                    }

                                    if (value.length < 3) {
                                      return "Kota tidak boleh kurang dari 3 karakter";
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Zip Code",
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                        color: colorTextBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _zipCodeController,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.send,
                                  onFieldSubmitted: (_) => _updateProfile(),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "12345",
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: colorBlueDark),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: colorBlueDark),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Kode pos wajib diisi";
                                    }

                                    if (value.length < 3) {
                                      return "Kode pos tidak boleh kurang dari 3 karakter";
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
