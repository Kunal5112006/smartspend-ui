# SmartSpend — Working UI Starter

Mint-green Flutter frontend based on the SmartSpend concept. This package
contains the app source, session-only sample data and tests. Android project
files are generated on your PC using your installed Flutter SDK.

## Windows par run karna

1. ZIP extract karo. Extracted `smartspend_ui` folder kholo.
2. Isi folder mein `pubspec.yaml`, `lib`, aur `SETUP_WINDOWS.cmd` dikhne chahiye.
3. `SETUP_WINDOWS.cmd` double-click karo. Flutter pehle se PATH mein hona chahiye.
   Script Android project files generate karegi aur dependencies resolve karegi.
4. Android Studio mein **Open** se poora `smartspend_ui` folder kholo.
   Sirf `android` subfolder mat kholo.
5. Device Manager se Android emulator start karo. Flutter device dropdown mein
   emulator select karo, `lib/main.dart` kholo, aur Run dabao.

Terminal use karna ho toh extracted folder mein PowerShell kholo aur run karo:

```powershell
flutter create --platforms=android --android-language=java --project-name=smartspend_ui --no-pub .
flutter pub get
flutter run
```

Last `.` command ka part hai: iska meaning current extracted folder hai.
`--overwrite` add mat karna. Source files already included hain.
Old project delete karne ki zaroorat nahi; ye ek separate folder hai.

Flutter 3.22 / Dart 3.4 or newer is the source compatibility target. A supported
stable Flutter SDK and its matching Android setup are recommended. Android files
are generated locally so the Gradle setup comes from your Flutter installation.
The first setup/build needs internet to download required dependencies.

## Is version mein kya working hai

- **Dashboard:** Monthly budget, spent, remaining, budget bar and recent expenses.
- **Add expense:** Amount, category, note, date, Cash/UPI/Card tag; Save updates state.
- **History:** Search by note/category/payment/date; category chips and month navigation.
- **Edit/delete:** Tap a transaction. Edit and save, or use the delete icon and confirm.
- **Reports:** Category totals and a donut chart calculated from session expenses.
- **Budget:** Dashboard pencil or Profile > Monthly budget opens the editor.
- **Warnings:** At 80% budget usage, show a warning; above budget, show overspend.
- **Profile:** Edit display name, About dialog, and confirmed demo reset.
- **Navigation:** Home, History, Reports and Profile; expense forms have back navigation.
- **Empty states:** Months with no expenses and searches with no matches.

The app opens with current-month sample expenses totalling **₹1,840**, a
**₹5,000** budget, and **₹3,160** remaining. Sample dates adapt to the month
when the app starts. Prior months initially have no expenses.

**No database or persistent storage is connected.** Changes remain only while
the app process is running. Closing/restarting or a Flutter hot restart restores
sample data. Switching pages keeps changes. There is no login, account service,
cloud sync, real payment processing, export, or scheduled notification in this version.
Cash/UPI/Card are expense-record labels only. Login is intentionally deferred
because this demo does not create accounts.

## Madam ko 2-minute demo

1. Home par ₹5,000 budget, ₹1,840 spent aur ₹3,160 remaining dikhao.
2. Add expense kholo; `80`, Food, `College lunch`, UPI enter karke Save karo.
3. Home par spent **₹1,920** aur remaining **₹3,080** dikhao.
4. History kholo, `College lunch` search karo, transaction edit karke `100` karo.
5. Reports kholo: Food ka amount/chart update dikhao.
6. Budget `2000` karke near-limit warning dikhao, phir `1500` karke overspend.
7. Profile > Reset demo data se original sample wapas lao.

Explain: “This is the frontend prototype. Navigation, forms and calculated
reports use temporary data. Persistent database storage will be added after approval.”

## File map

| File | Purpose |
|---|---|
| `lib/main.dart` | App theme, navigation shell and shared state ownership |
| `lib/screens.dart` | Dashboard, History, Reports, Profile and expense form |
| `lib/ui.dart` | Shared cards, month control, budget dialog, donut painter |
| `lib/demo_store.dart` | Expense model, sample data, totals and currency helpers |
| `test/demo_store_test.dart` | Balance, edits, month boundaries and currency cases |
| `test/widget_test.dart` | Add-expense, navigation and search interaction test |

Amounts are stored as integer paise, so money calculations avoid floating-point
rounding errors. There are no third-party Flutter packages or downloaded assets.
Java is selected for the generated Android host; the app UI is written in Dart.

## Verification

All included Dart files passed a tree-sitter syntax parse during preparation.
**Flutter/Dart SDK and an Android emulator were unavailable in the preparation
environment, so `flutter analyze`, `flutter test`, Android build and visual
runtime checks have not been run.** The generated concept image is a design
reference, not a screenshot of this app running.

After setup, run these in the project folder:

```powershell
flutter analyze
flutter test
flutter run
```

If Flutter is not recognized, fix Flutter's PATH first. If no device is found,
start an emulator and run `flutter devices`. If the build fails, keep the exact
error message so the specific setup issue can be fixed.

Official references:
- [Flutter CLI: create, analyze, test and run](https://docs.flutter.dev/reference/flutter-cli)
- [Flutter Android setup](https://docs.flutter.dev/platform-integration/android/setup)
- [Material NavigationBar](https://api.flutter.dev/flutter/material/NavigationBar-class.html)

## After approval

Keep the UI and replace the in-memory `DemoStore` layer with a data repository.
The database choice, authentication requirement and persistence behavior can be
decided after feedback. No database credentials or backend configuration are needed now.
