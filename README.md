
# 📊 XYZ Company SQL Database System – CS 4347 Semester Project

This project is a complete full-stack SQL database solution for managing the internal operations of **XYZ Company**, a fictional mid-sized manufacturer. The system enables querying, visualization, and manipulation of company data including employees, customers, job applications, sales, products, parts, vendors, and more.

> 📅 **Course**: CS 4347 – Database Systems  
> 🧑‍💻 **Student**: Andre Sanabria  
> 🗓️ **Term**: Spring 2025  
> 📌 **Date**: April 6, 2025

---

## 📚 Project Overview

XYZ Company manufactures products using vendor-supplied parts and operates across multiple departments and marketing sites. The database is designed to track:

- Employee information and supervisor relationships
- Departmental history of employees over time
- Job postings, applications, and interview results
- Product composition, part sourcing, and vendor pricing
- Sales data by site and customer
- Salaries, transactions, and staffing

The goal is to provide a **normalized, relational database** that supports **querying**, **views**, and **custom constraints** to simulate real-world business operations.

---

## 🛠️ Technologies Used

- **Frontend**: HTML, Bootstrap 5, JavaScript
- **Backend**: Node.js, Express
- **Database**: MySQL (SQL schema)
- **Notebook**: Jupyter (for data generation)
- **Design Tools**: ER/EER diagrams, dependency diagrams (PDF)

---

## 🔧 Project Setup

### 🧩 Prerequisites

- MySQL server
- Node.js & npm
- VS Code

### 📥 Installation Steps

```bash
git clone https://github.com/YourUsername/xyz-sql-query-console.git
cd xyz-sql-query-console
npm install
```

### 💽 Database Setup

1. Open `XYZ.sql` in MySQL Workbench or CLI.
2. Execute the file to create all tables and constraints.
3. Optional: Use `DataGenerator.ipynb` to populate with mock data.

### ▶️ Running the App

```bash
node server.js
```

Visit `http://localhost:3000` in your browser.

---

## 🎯 Features

### 🔍 Interactive Query Console
- Choose from preset SQL queries categorized by table
- Modify or create custom queries manually
- Get instant visual results in a styled table

### 🧠 Smart Randomization
- Select an `INSERT` query from the dropdown
- Click “Randomize” to autofill a context-aware valid `INSERT` query

### 🗂️ Views Implemented

- Average salary per employee (monthly)
- Interview round pass count per candidate
- Product type sales count
- Total part cost per product

### 🔎 15 Complex Queries (Examples)
- Return employees with no supervisees
- Get product types with highest profit
- Identify best-selling product type
- Find selected interviewees' contact info
- Query vendors offering cheapest part with specific conditions

---

## 🎥 Demo

![Demo of SQL Console](screenshots/demo.gif)

---

## 🧾 Documentation Included

- `XYZ.sql`: Full database schema with PK/FK constraints
- `ViewsAndQueries.pdf`: All SQL views and queries
- `ProblemDescription.txt`: Formal problem statement
- `ProjectQuestions.txt`: Answers to rule-based DB questions
- `NewER.pdf`, `NewEER.pdf`: Conceptual design diagrams
- `NewRelational.pdf`: Logical schema
- `NewDependency.pdf`: Dependency diagram
- `DataGenerator.ipynb`: Notebook to generate sample data
- `Logical.jpg`: Additional schema visualization

---

## 📁 Folder Structure

```
.
├── public/
│   ├── index.html
│   ├── style.css
│   ├── script.js
├── screenshots/
│   ├── demo.gif
├── server.js
├── XYZ.sql
├── package-lock.json
├── DataGenerator.ipynb
├── docs/
│   ├── NewER.pdf
│   ├── NewEER.pdf
│   ├── NewRelational.pdf
│   ├── NewDependency.pdf
│   ├── ViewsAndQueries.pdf
│   ├── Logical.jpg
├── ProblemDescription.txt
├── ProjectQuestions.txt
├── README.md
```

---

## 📌 Notes

- All data and logic comply with 3NF
- Supervisor self-reference is explicitly disallowed
- ISA hierarchy for `Person → {Employee, Customer, PotentialEmployee}`
- Triggers/views can be added for production robustness (e.g., CEO enforcement)

---

## 📬 Contact

**Andre Sanabria**  
📧 [Andre.E.Sanabria.G@gmail.com](mailto:Andre.E.Sanabria.G@gmail.com)  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/andre-san06)
