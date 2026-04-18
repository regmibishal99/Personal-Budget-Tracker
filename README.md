# 💰 Budget Tracker

A clean, fully offline personal budget tracker built with **Flutter** and **Hive** local storage. Track your income and expenses by month, visualize spending with an interactive pie chart, and set a monthly salary target — all without any internet connection.

<br>

## 📸 Screenshots

### Home Page/Dashboard
<img width="389" height="714" alt="Screenshot from 2026-04-18 13-59-41" src="https://github.com/user-attachments/assets/e883ec61-2e88-4823-8f1f-fba0226a6ba9" />


### Adding Expences
<img width="389" height="714" alt="Screenshot from 2026-04-18 13-59-52" src="https://github.com/user-attachments/assets/b29f5ade-27df-4e3e-88d3-a9e7861afe62" />

### Adding Income
<img width="389" height="714" alt="Screenshot from 2026-04-18 13-59-57" src="https://github.com/user-attachments/assets/36f176fb-81c7-4990-9b21-ea4211d90779" />

### Delete and Add 
<img width="389" height="714" alt="Screenshot from 2026-04-18 14-00-14" src="https://github.com/user-attachments/assets/9031d498-da8a-436d-8549-54100b266d6b" />



<br>

## ✨ Features

- 📊 **Interactive pie chart** — tap any slice to see spending percentage by category
- 🗓️ **Month & year filter** — view transactions for any specific month
- 💵 **Monthly salary tracker** — set your salary per month and track remaining balance
- ➕ **Add / Edit / Delete** transactions with full form validation
- 👆 **Swipe to delete** — swipe left on any transaction to remove it
- 🌙 **Dark mode** — full Material 3 dark theme support
- 💾 **Offline first** — all data stored locally with Hive, no internet needed
- 🏷️ **9 expense categories** — Food, Housing, Transport, Utilities, Entertainment, Health, Education, Shopping, Other
- 💼 **5 income categories** — Salary, Freelance, Business, Investment, Other

<br>

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Local Storage | Hive + hive_flutter |
| Charts | fl_chart |
| Date Formatting | intl |
| ID Generation | uuid |
| Code Generation | build_runner + hive_generator |

<br>


## 🧠 Key Concepts Used

| Concept | Where Used |
|---|---|
| `HiveObject` + `TypeAdapter` | Transaction & MonthlyBudget models |
| `ValueListenableBuilder` | Reactive UI updates when Hive data changes |
| `CustomScrollView` + Slivers | Mixed scrollable header + list layout |
| `AnimationController` | scale + slide animation |
| `Dismissible` | Swipe-to-delete on transaction tiles |
| `StatefulWidget` | Screens with local UI state (tab, month picker) |
| `StatelessWidget` | Pure display widgets (BalanceCard, SectionTitle) |
| `fold()` | Calculating income/expense totals from list |
| Feature-based architecture | Each feature in its own folder with screens/widgets |

<br>



<div align="center">
  <sub>Built with ❤️ using Flutter</sub>
</div>
