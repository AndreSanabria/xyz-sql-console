CREATE DATABASE IF NOT EXISTS XYZ;
USE XYZ;

-- Person & Contact Info
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT CHECK (Age < 65),
    Gender CHAR(1),
    Email VARCHAR(100),
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10)
);

CREATE TABLE PhoneNumber (
    PersonID INT,
    PhoneNumber VARCHAR(20),
    PhoneType VARCHAR(20), -- e.g., Mobile, Work, Home
    PRIMARY KEY (PersonID, PhoneNumber),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- Subtypes of Person (ISA hierarchy)
CREATE TABLE Employee (
    PersonID INT PRIMARY KEY,
    ERank VARCHAR(50),
    Title VARCHAR(50),
    SupervisorID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (SupervisorID) REFERENCES Employee(PersonID)
);

CREATE TABLE Customer (
    PersonID INT PRIMARY KEY,
    PreferredSalesRepID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (PreferredSalesRepID) REFERENCES Employee(PersonID)
);

CREATE TABLE PotentialEmployee (
    PersonID INT PRIMARY KEY,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- Departments
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- Employee-Department Assignment History (temporal)
CREATE TABLE EmployeeDepartmentHistory (
    HistoryID INT PRIMARY KEY,
    EmployeeID INT,
    DepartmentID INT,
    StartTime DATETIME,
    EndTime DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(PersonID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- Job Postings
CREATE TABLE JobPosition (
    JobID INT PRIMARY KEY,
    JobDescription VARCHAR(255),
    PostedDate DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- Job Applications
CREATE TABLE Application (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT, -- Can be employee or potential employee
    ApplicationDate DATE,
    FOREIGN KEY (JobID) REFERENCES JobPosition(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Person(PersonID)
);

-- Interview Info
CREATE TABLE Interview (
    InterviewID INT PRIMARY KEY,
    JobID INT,
    InterviewTime DATETIME,
    FOREIGN KEY (JobID) REFERENCES JobPosition(JobID)
);

CREATE TABLE InterviewResult (
    InterviewID INT,
    InterviewerID INT,
    IntervieweeID INT,
    Grade DECIMAL(5,2),
    PRIMARY KEY (InterviewID, InterviewerID, IntervieweeID),
    FOREIGN KEY (InterviewID) REFERENCES Interview(InterviewID),
    FOREIGN KEY (InterviewerID) REFERENCES Employee(PersonID),
    FOREIGN KEY (IntervieweeID) REFERENCES Person(PersonID)
);

ALTER TABLE InterviewResult
MODIFY Grade DECIMAL(5,2) CHECK (Grade BETWEEN 0 AND 100);

-- Products and Parts
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductType VARCHAR(50),
    Size VARCHAR(50),
    ListPrice DECIMAL(10,2),
    Weight DECIMAL(10,2),
    Style VARCHAR(50)
);

CREATE TABLE PartType (
    PartTypeID INT PRIMARY KEY,
    PartName VARCHAR(100),
    Weight DECIMAL(10,2)
);

CREATE TABLE ProductPart (
    ProductID INT,
    PartTypeID INT,
    QuantityUsed INT,
    PRIMARY KEY (ProductID, PartTypeID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (PartTypeID) REFERENCES PartType(PartTypeID)
);

-- Vendors and their Parts
CREATE TABLE Vendor (
    VendorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(200),
    AccountNumber VARCHAR(50),
    CreditRating INT,
    PurchasingWebServiceURL VARCHAR(255)
);

CREATE TABLE VendorPart (
    VendorID INT,
    PartTypeID INT,
    Price DECIMAL(10,2),
    PRIMARY KEY (VendorID, PartTypeID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
    FOREIGN KEY (PartTypeID) REFERENCES PartType(PartTypeID)
);

-- Marketing Sites and Employee-Site Relations
CREATE TABLE MarketingSite (
    SiteID INT PRIMARY KEY,
    SiteName VARCHAR(100),
    SiteLocation VARCHAR(100)
);

CREATE TABLE SiteStaffing (
    EmployeeID INT,
    SiteID INT,
    PRIMARY KEY (EmployeeID, SiteID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(PersonID),
    FOREIGN KEY (SiteID) REFERENCES MarketingSite(SiteID)
);

-- Sales
CREATE TABLE Sale (
    SaleID INT PRIMARY KEY,
    SalesmanID INT,
    CustomerID INT,
    ProductID INT,
    SaleTime DATETIME,
    SiteID INT,
    FOREIGN KEY (SalesmanID) REFERENCES Employee(PersonID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(PersonID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (SiteID) REFERENCES MarketingSite(SiteID)
);

-- Salaries
CREATE TABLE Salary (
    TransactionNumber INT,
    EmployeeID INT,
    PayDate DATE,
    Amount DECIMAL(10,2),
    PRIMARY KEY (TransactionNumber, EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(PersonID)
);

-- Optional: Project Table
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    DepartmentID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- Optional: Employee participation in Projects
CREATE TABLE ProjectStaff (
    ProjectID INT,
    EmployeeID INT,
    Role VARCHAR(50),
    PRIMARY KEY (ProjectID, EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(PersonID)
);
-- -----View 1: Avg Monthly Salary per Employee----------------------------------------------------
CREATE OR REPLACE VIEW View1_AvgMonthlySalary AS
SELECT 
    e.PersonID AS EmployeeID,
    p.FirstName,
    p.LastName,
    ROUND(AVG(s.Amount), 2) AS AvgMonthlySalary
FROM Employee e
JOIN Salary s ON e.PersonID = s.EmployeeID
JOIN Person p ON e.PersonID = p.PersonID
GROUP BY e.PersonID, p.FirstName, p.LastName;
SELECT * FROM View1_AvgMonthlySalary;
-- -------------------------------------------------------------------------
-- -----View 2: Number of Interview Rounds Passed per Job per Interviewee-------
CREATE OR REPLACE VIEW View2_InterviewPassCounts AS
SELECT 
    i.JobID,
    ir.IntervieweeID,
    COUNT(DISTINCT ir.InterviewID) AS PassedRounds
FROM InterviewResult ir
JOIN Interview i ON ir.InterviewID = i.InterviewID
WHERE ir.Grade >= 3.5
GROUP BY i.JobID, ir.IntervieweeID;

SELECT * FROM View2_InterviewPassCounts;
-- -------------------------------------------------------------------------
-- -----View 3: Number of Items Sold per Product Type----------------------------
CREATE OR REPLACE VIEW View3_ProductsSoldByType AS
SELECT 
    pr.ProductType,
    COUNT(s.SaleID) AS ItemsSold
FROM Sale s
JOIN Product pr ON s.ProductID = pr.ProductID
GROUP BY pr.ProductType;

SELECT * FROM View3_ProductsSoldByType;
-- -------------------------------------------------------------------------
-- -----View 4: Part Purchase Cost per Product (lowest vendor price per part)-----
CREATE OR REPLACE VIEW View4_PartCostPerProduct AS
SELECT 
    pp.ProductID,
    SUM(pp.QuantityUsed * vp.MinPrice) AS TotalPartCost
FROM ProductPart pp
JOIN (
    SELECT PartTypeID, MIN(Price) AS MinPrice
    FROM VendorPart
    GROUP BY PartTypeID
) vp ON pp.PartTypeID = vp.PartTypeID
GROUP BY pp.ProductID;

SELECT * FROM View4_PartCostPerProduct;
-- -------------------------------------------------------------------------

-- 1. Interviewers who interviewed “Hellen Cole” for job 11111
SELECT DISTINCT ir.InterviewerID, p.FirstName, p.LastName
FROM InterviewResult ir
JOIN Interview i ON ir.InterviewID = i.InterviewID
JOIN Person p ON ir.InterviewerID = p.PersonID
WHERE i.JobID = 11111
  AND ir.IntervieweeID = (
    SELECT PersonID FROM Person
    WHERE FirstName = 'Hellen' AND LastName = 'Cole'
  );

-- 2. Jobs posted by department “Marketing” in January 2011
SELECT j.JobID, j.JobDescription, j.PostedDate
FROM JobPosition j
JOIN Department d ON j.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Marketing'
  AND MONTH(j.PostedDate) = 1 AND YEAR(j.PostedDate) = 2011;

SELECT d.DepartmentName, j.JobID, j.PostedDate
FROM JobPosition j
JOIN Department d ON j.DepartmentID = d.DepartmentID
ORDER BY j.PostedDate;

-- 3. Employees with no supervisees
SELECT e.PersonID, p.FirstName, p.LastName
FROM Employee e
JOIN Person p ON e.PersonID = p.PersonID
WHERE e.PersonID NOT IN (
    SELECT DISTINCT SupervisorID
    FROM Employee
    WHERE SupervisorID IS NOT NULL
);

-- 4. Marketing sites with no sales in March 2011
SELECT m.SiteID, m.SiteName
FROM MarketingSite m
WHERE m.SiteID NOT IN (
    SELECT s.SiteID
    FROM Sale s
    WHERE MONTH(s.SaleTime) = 3 AND YEAR(s.SaleTime) = 2011
);

-- 5. Jobs with no hires after one month of being posted
SELECT j.JobID, j.JobDescription
FROM JobPosition j
WHERE j.JobID NOT IN (
    SELECT DISTINCT i.JobID
    FROM Interview i
    JOIN InterviewResult ir ON i.InterviewID = ir.InterviewID
    WHERE ir.Grade >= 3.5
)
AND DATEDIFF(CURDATE(), j.PostedDate) > 30;

-- 6. Salesmen who sold all product types with price > $200
SELECT s.SalesmanID
FROM Sale s
JOIN Product p ON s.ProductID = p.ProductID
WHERE p.ListPrice > 59
GROUP BY s.SalesmanID
HAVING COUNT(DISTINCT p.ProductType) = (
    SELECT COUNT(DISTINCT ProductType) FROM Product
);

SELECT DISTINCT ProductID, ProductType, ListPrice 
FROM Product 
WHERE ListPrice > 200;

-- 7. Departments with no job postings between Jan 1 and Feb 1, 2011
SELECT d.DepartmentID, d.DepartmentName
FROM Department d
WHERE d.DepartmentID NOT IN (
    SELECT j.DepartmentID
    FROM JobPosition j
    WHERE j.PostedDate BETWEEN '2011-01-01' AND '2011-02-01'
);

-- 8. Employees who applied to job 12345
SELECT DISTINCT p.PersonID, p.FirstName, p.LastName
FROM Application a
JOIN Person p ON a.ApplicantID = p.PersonID
WHERE a.JobID = 12345
  AND a.ApplicantID IN (SELECT PersonID FROM Employee);

-- 9. Best-selling product type
SELECT p.ProductType, COUNT(s.SaleID) AS SalesCount
FROM Sale s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY p.ProductType
ORDER BY SalesCount DESC
LIMIT 1;

-- 10. Product type with highest net profit (ListPrice − Part Cost)
SELECT p.ProductType, 
       ROUND(AVG(p.ListPrice - pc.TotalPartCost), 2) AS AvgNetProfit
FROM Product p
JOIN View4_PartCostPerProduct pc ON p.ProductID = pc.ProductID
GROUP BY p.ProductType
ORDER BY AvgNetProfit DESC
LIMIT 1;

-- 11. Employees who worked in all departments
SELECT e.PersonID
FROM Employee e
JOIN EmployeeDepartmentHistory edh ON e.PersonID = edh.EmployeeID
GROUP BY e.PersonID
HAVING COUNT(DISTINCT edh.DepartmentID) = (SELECT COUNT(*) FROM Department);

-- 12. Interviewees selected (avg grade ≥ 3.5, ≥ 5 interviews)
SELECT ir.IntervieweeID, ROUND(AVG(ir.Grade), 2) AS AvgGrade, COUNT(DISTINCT ir.InterviewID) AS InterviewCount
FROM InterviewResult ir
GROUP BY ir.IntervieweeID
HAVING AvgGrade >= 3.5 AND InterviewCount >= 5;

-- 13. Name, phone, email of selected interviewees and jobs they applied to
SELECT p.FirstName, p.LastName, p.Email, ph.PhoneNumber, a.JobID
FROM Person p
JOIN PhoneNumber ph ON p.PersonID = ph.PersonID
JOIN Application a ON a.ApplicantID = p.PersonID
WHERE p.PersonID IN (
    SELECT ir.IntervieweeID
    FROM InterviewResult ir
    GROUP BY ir.IntervieweeID
    HAVING AVG(ir.Grade) >= 3.5 AND COUNT(DISTINCT ir.InterviewID) >= 5
);

-- 14. Employee with highest average monthly salary
SELECT e.PersonID, p.FirstName, p.LastName, ROUND(AVG(s.Amount), 2) AS AvgSalary
FROM Salary s
JOIN Employee e ON s.EmployeeID = e.PersonID
JOIN Person p ON e.PersonID = p.PersonID
GROUP BY e.PersonID, p.FirstName, p.LastName
ORDER BY AvgSalary DESC
LIMIT 1;

-- 15. Vendor who supplies part “Cup” under 4 pounds with the lowest price
SELECT v.VendorID, v.Name, vp.Price
FROM Vendor v
JOIN VendorPart vp ON v.VendorID = vp.VendorID
JOIN PartType pt ON vp.PartTypeID = pt.PartTypeID
WHERE pt.PartName = 'Cup' AND pt.Weight < 4
ORDER BY vp.Price ASC
LIMIT 1;


CREATE USER 'xyz_user'@'localhost' IDENTIFIED BY 'xyz_password';
GRANT ALL PRIVILEGES ON XYZ.* TO 'xyz_user'@'localhost';
FLUSH PRIVILEGES;

DELIMITER //

CREATE TRIGGER only_one_ceo_allowed
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
  IF NEW.SupervisorID IS NULL THEN
    IF (SELECT COUNT(*) FROM Employee WHERE SupervisorID IS NULL) >= 1 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Only one CEO (no supervisor) is allowed.';
    END IF;
  END IF;
END;
//

DELIMITER ;