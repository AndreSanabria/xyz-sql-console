function handleDropdownChange(event) {
  const value = event.target.value;
  if (value) {
    document.getElementById('sqlInput').value = value;
  }
}

function runQuery() {
  const sql = document.getElementById('sqlInput').value;
  const errorDiv = document.getElementById('errorMsg');
  const tableHead = document.querySelector('#resultTable thead');
  const tableBody = document.querySelector('#resultTable tbody');

  errorDiv.textContent = '';
  errorDiv.className = '';
  tableHead.innerHTML = '';
  tableBody.innerHTML = '';

  fetch('/query', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sql })
  })
    .then(res => res.json())
    .then(data => {
      if (data.error) {
        errorDiv.textContent = 'Error: ' + data.error;
        errorDiv.className = 'text-danger';
        return;
      }

      if (!data.fields || data.results.length === 0) {
        errorDiv.textContent = 'Query executed successfully, but returned no results.';
        errorDiv.className = 'text-success';
        return;
      }

      const headers = data.fields.map(field => `<th>${field.name}</th>`).join('');
      tableHead.innerHTML = `<tr>${headers}</tr>`;

      data.results.forEach(row => {
        const rowHtml = Object.values(row).map(val => `<td>${val}</td>`).join('');
        tableBody.innerHTML += `<tr>${rowHtml}</tr>`;
      });
    })
    .catch(err => {
      errorDiv.textContent = 'Fetch error: ' + err.message;
      errorDiv.className = 'text-danger';
    });
}

function randomizeInsert() {
  const presetQuery = document.getElementById('presetQueries').value;
  if (!presetQuery.startsWith("INSERT INTO")) {
    alert("Please select an INSERT query from the preset dropdown to randomize.");
    return;
  }

  const tableMatch = presetQuery.match(/INSERT INTO (\w+)/i);
  if (!tableMatch) {
    alert("Could not detect table name.");
    return;
  }

  const tableName = tableMatch[1];
  let randomizedQuery = "";

  const firstNames = ['Alex', 'Maria', 'James', 'Sophia', 'Daniel', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava'];
  const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones'];
  const cities = ['Dallas', 'Austin', 'Houston', 'Miami', 'Chicago'];
  const states = ['TX', 'FL', 'CA', 'NY', 'IL'];
  const genders = ['M', 'F'];
  const phoneTypes = ['Mobile', 'Home', 'Work'];
  const sizes = ['Small', 'Medium', 'Large'];
  const styles = ['Classic', 'Modern', 'Retro', 'Sport', 'Minimal'];

  function rand(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
  }

  switch (tableName) {
    case "Person":
      const id = Math.floor(60 + Math.random() * 41);
      const fName = rand(firstNames);
      const lName = rand(lastNames);
      const age = Math.floor(Math.random() * 47 + 18);
      const gender = rand(genders);
      const email = `${fName.toLowerCase()}.${lName.toLowerCase()}${id}@example.com`;
      const address = `${Math.floor(Math.random() * 9999)} Main St`;
      const city = rand(cities);
      const state = rand(states);
      const zip = `${Math.floor(10000 + Math.random() * 89999)}`;
      randomizedQuery = `INSERT INTO Person (PersonID, FirstName, LastName, Age, Gender, Email, AddressLine1, City, State, ZipCode) VALUES (${id}, '${fName}', '${lName}', ${age}, '${gender}', '${email}', '${address}', '${city}', '${state}', '${zip}')`;
      break;

    case "PhoneNumber":
      const pn = `555-${Math.floor(100 + Math.random() * 900)}-${Math.floor(1000 + Math.random() * 9000)}`;
      randomizedQuery = `INSERT INTO PhoneNumber (PersonID, PhoneNumber, PhoneType) VALUES (999, '${pn}', '${rand(phoneTypes)}')`;
      break;

    case "Employee":
      const ranks = ['Junior', 'Mid', 'Senior', 'Lead'];
      const titles = ['Developer', 'Analyst', 'Manager', 'Engineer', 'Consultant'];
      const supervisorID = Math.floor(2 + Math.random() * 51);
      randomizedQuery = `INSERT INTO Employee (PersonID, ERank, Title, SupervisorID) VALUES (999, '${rand(ranks)}', '${rand(titles)}', ${supervisorID})`;
      break;

    case "Customer":
      randomizedQuery = `INSERT INTO Customer (PersonID, PreferredSalesRepID) VALUES (999, 23)`;
      break;

    case "Product":
      const prodID = Math.floor(1000 + Math.random() * 9000);
      const listPrice = (Math.random() * 200 + 10).toFixed(2);
      const weight = (Math.random() * 5 + 0.5).toFixed(2);
      randomizedQuery = `INSERT INTO Product (ProductID, ProductType, Size, ListPrice, Weight, Style) VALUES (${prodID}, 'Gadget', '${rand(sizes)}', ${listPrice}, ${weight}, '${rand(styles)}')`;
      break;

    case "PartType":
      const partID = Math.floor(500 + Math.random() * 400);
      const weightVal = (Math.random() * 2).toFixed(2);
      randomizedQuery = `INSERT INTO PartType (PartTypeID, PartName, Weight) VALUES (${partID}, 'Screw', ${weightVal})`;
      break;

    default:
      alert("Randomization for this table is not implemented yet.");
      return;
  }

  document.getElementById('sqlInput').value = randomizedQuery;
}

window.addEventListener('DOMContentLoaded', () => {
  document.getElementById('runBtn').addEventListener('click', runQuery);
  document.getElementById('randomizeBtn').addEventListener('click', randomizeInsert);
  document.getElementById('presetQueries').addEventListener('change', handleDropdownChange);
  document.getElementById('viewQueries').addEventListener('change', handleDropdownChange);
  document.getElementById('projectQueries').addEventListener('change', handleDropdownChange);
  document.getElementById('mnQueries').addEventListener('change', handleDropdownChange);
});
