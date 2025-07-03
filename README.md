# Celebal_Technologies_Internship_Assignments

## Projects :-
### ◎ Project Title :
Create a stored procedure to get the number of hours between two dates having a DateTime format excluding all Sundays and 1st and 2nd Saturdays.

####  Project Details :
See the attach file "Calculate timing hours for a given range of dates".

####  Solution :
See the attach file "Project 1 ( Calculating timing hours for a given range of dates ).sql".

#### ↪ Expected Output : 
Output in table - ( Generated expected result as wanted in the project guidance )

![Screenshot 2025-06-23 001505](https://github.com/user-attachments/assets/453b79b6-3545-4380-8ac6-726b49be1d67)

####  Applications :
✔ HR attendance or payroll systems
✔ Employee working hour tracking
✔ Automated time tracking for project billing
✔ Can be extended with a holiday calendar table for public holiday exclusion

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## WEEK 1 Assignment :-

### ■ Summary :
This SQL assignment, given during my internship, involved querying a transactional database modeled on a retail or e-commerce setup. It aimed to extract and analyze structured data across customers, orders, products, employees, and sales. The 42 queries tested core SQL skills filtering, sorting, grouping, joins, and subqueries through real world business scenarios like identifying top customers, tracking product performance, and calculating revenue. Overall, it provided hands on experience in business data analysis aligned with data-driven decision making.

### Data Source :
Adventure work 2022 dataset from SSMS.

### Problem Statements :
See the attach file "Problem Statements - Level A Task ( Week 1 )"

### Solution :
See the attach file "Week 1 Assignment.sql"


#### ↪ Small Preview - [ Q20 ] List of countries and sales made in each country.
![Screenshot 2025-06-08 191325](https://github.com/user-attachments/assets/ee7c75cb-ce88-4a2a-aa4f-117405abbfcf)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## WEEK 2 Assignment :-

### ■ Summary : 
This project showcases SQL Server Stored Procedures, Functions, Views, and Triggers for managing order processing in a Northwind-style database. It includes inventory-checked order insertion, flexible updates, secure deletions, date formatting functions, dynamic order views, and triggers for maintaining data integrity and stock validation, with sample data used for testing.

### Data Source :
 AdventureWorks 2022 database and Northwind database (with additional test data).

### Problem Statements :
See the attach file "Problem Statements - Level B Task ( Week 2 )"

### Solution :
See the attach file "Week 2 Assignment.sql"

#### ↪ Small Preview - Stored Functions [ Q3 ]
![Screenshot 2025-06-15 233716](https://github.com/user-attachments/assets/23752f3d-c584-48bb-82e9-a7c6a73f1e11)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## WEEK 3 Assignment :- 

### ■ Summary : 
This SQL assignment comprises 20 practical tasks. It involves comprehensive use of DDL (Data Definition Language) for table creation, DML (Data Manipulation Language) for inserting, updating, and querying data, and advanced SQL techniques like CTEs, window functions, subqueries, pivots, and conditional logic. The tasks simulate real-world scenarios such as grouping project timelines, analyzing student-friend salary differences, contest and hacker performance analytics, prime number generation, binary tree classification, cost-to-revenue ratio analysis, weighted averages, and hierarchical employee structures. This assignmenet blends data engineering and analytical logic.

### Data Source :
Provided by the company and some manually created test data as per the guidance.

### Problem Statements :
See the attach file "Problem Statements - Level C Task ( Week 3 )"

### Solution :
See the attach file "Week 3 Assignment.sql"

#### ↪ Small Preview - [ Task 18 ]  Find Weighted average cost of employees month on month in a BU.
![Screenshot 2025-06-22 001117](https://github.com/user-attachments/assets/45572734-7651-47e7-b000-934849703410)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## WEEK 4 Assignment :- 

### ■ Summary : 
This project automates subject allotment based on student preferences and GPA using SQL Server. Students are processed in descending GPA order, and subjects are assigned based on availability and ranked choices. If no preferred subject is available, the student is marked unallotted. The system ensures fair, priority-based allocation with real-time seat updates.

### Data Source :
No external data source is required as the process is fully automated using predefined student, subject, and preference entries within the database.

### Problem Statements :
See the attach file "Student Allotment SQL Problem (Week 4 )"


### Solution :
See the attach file "Week 4 Assignment.sql"

#### ↪ Small Preview - Subject Details table after allotment of some students
![Screenshot 2025-06-25 211952](https://github.com/user-attachments/assets/1c570bdf-be34-477f-a3bf-6f7a6dfa8ba2)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## WEEK 5 Assignment :- (Ongoing)

### ■ Summary : 
This project implements a stored procedure to manage and track student's elective subject changes by maintaining both historical and current allotments. It ensures that when a student requests a new subject, the previous valid entry is marked invalid, and the new subject is recorded as active preserving the full timeline of changes for transparency and auditability.

### Data Source :
No external data source is required, as the process is fully automated using predefined entries within the database. All student, subject, and preference information is managed internally through the SubjectAllotments and SubjectRequest tables, enabling seamless tracking and updating of subject changes without manual intervention or third-party integration.


### Problem Statements :
See the attach file "Subject Change Request Problem (Week 5)"

### Solution :
See the attach file "Week 5 Assignment.sql"

#### ↪ Small Preview -  SubjectAllotment table after implemented the stated workflow
![Screenshot 2025-07-01 000931](https://github.com/user-attachments/assets/66fac8cf-af77-4bff-8f3b-8da99003fbb8)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
