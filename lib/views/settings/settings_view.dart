import 'package:finaxis_web/widgets/animated_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool dark = false; bool emailNotif = true; bool smsNotif = false; String lang = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Row(
        children: [
           AnimatedSidebar(
            selectedIndex: 1,
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  Get.offNamed('/dashboard');
                  break;
                case 1:
                  // already on Applicants
                  break;
                case 2:
                  Get.offNamed('/applicants');
                  break;
              }
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 12),
                      Row(children: const [CircleAvatar(radius: 24, child: Icon(Icons.person)), SizedBox(width: 12), Expanded(child: TextField(decoration: InputDecoration(labelText: 'Display Name')))]),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Preferences', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 12),
                      Row(children: [
                        const Text('Theme'), const Spacer(), Switch(value: dark, onChanged: (v){ setState(()=> dark=v); })
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Text('Language'), const Spacer(), DropdownButton<String>(value: lang, items: const [DropdownMenuItem(value:'English', child: Text('English')), DropdownMenuItem(value:'Arabic', child: Text('Arabic'))], onChanged: (v){ setState(()=> lang=v??'English'); })
                      ]),
                      const SizedBox(height: 8),
                      SwitchListTile(title: const Text('Email Notifications'), value: emailNotif, onChanged: (v)=> setState(()=> emailNotif=v)),
                      SwitchListTile(title: const Text('SMS Notifications'), value: smsNotif, onChanged: (v)=> setState(()=> smsNotif=v)),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
