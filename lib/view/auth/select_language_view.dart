import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/configs/extensions.dart';
import 'package:team_quest/configs/routes/routes_name.dart';
import 'package:team_quest/model/language_model.dart';
import 'package:team_quest/view/auth/widgets/login_button_widget.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';

class SelectLanguageScreen extends StatefulWidget {
  final String uid;
  const SelectLanguageScreen({super.key, required this.uid});

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final List<LanguageModel> _languages = [
    LanguageModel(name: 'English', imagePath: 'assets/images/english_flag.png'),
    LanguageModel(name: 'Italian', imagePath: 'assets/images/italian_flag.png'),
    LanguageModel(name: 'Chinese', imagePath: 'assets/images/chinese_flag.png'),
    LanguageModel(name: 'French', imagePath: 'assets/images/french_flag.png'),
    LanguageModel(name: 'German', imagePath: 'assets/images/german_flag.png'),
    LanguageModel(name: 'Spanish', imagePath: 'assets/images/spanish_flag.png'),
    LanguageModel(name: 'Russian', imagePath: 'assets/images/russian_flag.png'),
  ];

  late AuthViewModel authViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Language'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Choose Your Language',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                05.width,
                Image.asset(
                  _languages.first.imagePath,
                  height: 24,
                  width: 24,
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Please search and then choose your personal language.',
              style: TextStyle(fontSize: 14, color: AppColors.blackColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(),
              decoration: InputDecoration(
                hintText: 'Search for your language',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  String language = _languages[index].name;

                  return Consumer<AuthViewModel>(
                    builder: (context, provider, child) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // selectedTileColor: AppColors.greyColor.withOpacity(0.1),
                        selected: provider.selectedLanguage == language,
                        leading: Image.asset(
                          _languages[index].imagePath,
                          height: 25,
                          width: 25,
                        ),
                        title: Text(language),
                        trailing: provider.selectedLanguage == language
                            ? const Icon(Icons.check_circle,
                                color: AppColors.blackColor)
                            : null,
                        onTap: () {
                          provider.setUserLanguage(language);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: PrimaryButton(
                  title: "Confirm",
                  onPress: () async {
                    bool result = await authViewModel.setLanguage(
                        language: authViewModel.selectedLanguage,
                        uid: widget.uid);

                    if (result && context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RoutesName.home, (route) => false);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
