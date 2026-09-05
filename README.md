# 💸 SmartSpend — Student Expense Tracker

SmartSpend is a Flutter-based Android application designed to help students track daily expenses, manage monthly budgets, and understand their spending habits.

The app brings expense entry, transaction history, budget tracking, and visual reports into a simple interface with a mint-green theme.

> **Current status:** Working UI prototype with temporary, in-memory data. SQLite database integration is planned for the next development phase.

---

## 📌 About the Project

Students regularly spend money on food, transport, books, shopping, and other everyday needs. Small expenses can be difficult to remember, making it harder to understand where a monthly allowance goes.

SmartSpend provides a central place to record these expenses and review spending against a monthly budget.

This project is being developed as a college project using Flutter and Dart in Android Studio. Development begins with the user interface and navigation, followed by database integration after the initial UI review.

---

## 🎯 Project Objectives

- Make daily expense tracking simple and accessible.
- Help students monitor their monthly spending.
- Organize expenses into useful categories.
- Display the remaining monthly budget.
- Present spending information through visual reports.
- Provide a clear history of recorded transactions.
- Build a Flutter application with connected screens and interactive forms.
- Add persistent data storage using SQLite in the next phase.

---

## ✨ Current Features

### 🏠 Dashboard

The dashboard provides an overview of the selected month.

It displays:

- Monthly budget.
- Total expenses.
- Remaining balance.
- Budget usage progress bar.
- Recent transactions.
- A shortcut to add a new expense.
- Budget warnings based on current spending.

Users can move between months to view the corresponding records.

### ➕ Add Expense

Users can record an expense by entering:

| Field | Description |
|---|---|
| Amount | Money spent, entered in Indian rupees |
| Category | The type of expense |
| Note | A short description of the purchase |
| Date | The date of the expense |
| Payment method | Cash, UPI, or Card |

The form validates the amount before saving. Saving an expense updates the dashboard, history, and reports for the current session.

### 🗂️ Expense Categories

Expenses can be organized into:

- Food
- Travel
- Books
- Shopping
- Bills
- Other

Each category has an icon and color to make the interface easier to scan.

### 📜 Expense History

The history screen displays recorded expenses for the selected month.

Users can:

- View expense amounts, categories, and dates.
- Search by note, category, payment method, or displayed date.
- Filter records by category.
- Navigate between months.
- See the total amount for the filtered results.
- Open a transaction to edit or delete it.

### ✏️ Edit and Delete Expenses

Users can correct an existing expense without adding a duplicate record.

Editable details include the amount, category, note, date, and payment method.

Deleting an expense requires confirmation. The dashboard and reports update after a record is changed or removed.

### 📊 Spending Reports

The reports screen helps users understand how their expenses are distributed.

It includes:

- Total spending for the selected month.
- A donut chart showing category-wise spending.
- Category totals and percentages.
- A summary identifying the highest-spending category.
- An empty state for months without expenses.

The chart is drawn using Flutter's `CustomPainter`.

### 💰 Monthly Budget

Users can set and edit their budget for the selected month.

The app calculates:

**Remaining balance = Monthly budget − Total expenses**

The interface displays a warning when spending reaches 80% of the budget and an overspending message when expenses exceed the budget.

These are in-app messages, not scheduled system notifications.

### 👤 Profile

The profile screen includes:

- Editable display name.
- Monthly budget settings.
- Application information.
- An explanation of the preview's temporary storage.
- A reset option to restore the original sample data.

### 🧭 Navigation

The main navigation contains four destinations:

| Destination | Purpose |
|---|---|
| Home | View budget and recent spending |
| History | Search, filter, and manage transactions |
| Reports | Review category-wise spending |
| Profile | Manage display name and demo settings |

The expense form opens as a separate screen with back navigation.

---

## 🛠️ Technology Stack

| Technology | Role |
|---|---|
| Flutter | Application framework and UI |
| Dart | App logic, widgets, forms, and calculations |
| Android Studio | Development environment |
| Java | Generated Android host activity |
| Material Design 3 | Navigation and interface components |
| ChangeNotifier | Shared in-memory application state |
| CustomPainter | Spending chart rendering |
| Git and GitHub | Version control and source hosting |
| SQLite with sqflite | Planned persistent database integration |

The current UI implementation uses Flutter SDK components without third-party runtime packages.

---

## 🎨 UI Design

SmartSpend uses a light interface with emerald-green actions and mint-colored surfaces.

The design includes:

- Rounded cards and form fields.
- Category icons and color accents.
- Clear headings and readable amounts.
- A consistent bottom navigation bar.
- Scrollable screen content.
- Feedback messages for user actions.
- Helpful empty states.

The interface focuses on the information students need most: their spending, remaining budget, and transaction history.

---

## 📱 Screenshots

Screenshots of the running application will be added as the UI is reviewed.

Planned screenshots:

- Dashboard
- Add Expense
- Expense History
- Reports
- Profile

---
