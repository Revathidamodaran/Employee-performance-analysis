Create database Appleemployee;
USE Appleemployee;

#Duplicates in the Employee Table
SELECT EmployeeID, COUNT(*) 
FROM Employee
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

#Check for Duplicates in Performance, Training, and Feedback
SELECT MetricID, COUNT(*) 
FROM Performance
GROUP BY MetricID
HAVING COUNT(*) > 1;

SELECT COUNT(*) 
FROM Performance
WHERE EmployeeSatisfactionScore < 1 OR EmployeeSatisfactionScore > 5;

SELECT 
    COUNT(*) AS TotalRows,
    COUNT(EmployeeID) AS RowsWithEmployeeID,
    COUNT(Name) AS RowsWithName,
    COUNT(Department) AS RowsWithDepartment,
    COUNT(Role) AS RowsWithRole
FROM Employee;

SELECT COUNT(*) 
FROM Performance
WHERE ProjectCompletionRate IS NULL OR TotalTasksCompleted IS NULL;

ALTER TABLE Employee ADD PRIMARY KEY (EmployeeID);

ALTER TABLE Performance 
ADD PRIMARY KEY (MetricID),
ADD FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);

ALTER TABLE Training 
ADD PRIMARY KEY (TrainingID),
ADD FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);

ALTER TABLE Feedback 
ADD PRIMARY KEY (FeedbackID),
ADD FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);

#Employee Performance Overview
SELECT e.EmployeeID, e.Name, e.Department, p.ProjectCompletionRate, p.TotalTasksCompleted, p.EmployeeSatisfactionScore
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID;

#Top Performers by Project Completion Rate
SELECT e.EmployeeID, e.Name, p.ProjectCompletionRate
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
ORDER BY p.ProjectCompletionRate DESC
LIMIT 10;

#Department-wise Performance
SELECT e.Department, AVG(p.ProjectCompletionRate) AS AvgCompletionRate
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department
ORDER BY AvgCompletionRate DESC;

#Training Effectiveness
SELECT e.Name, t.TrainingProgram, t.TrainingHours, p.ProjectCompletionRate
FROM Employee e
JOIN Training t ON e.EmployeeID = t.EmployeeID
JOIN Performance p ON e.EmployeeID = p.EmployeeID
ORDER BY p.ProjectCompletionRate DESC;

#Feedback Analysis
SELECT f.FeedbackType, COUNT(*) AS FeedbackCount
FROM Feedback f
GROUP BY f.FeedbackType
ORDER BY FeedbackCount DESC;

#Employee Satisfaction by Department
SELECT e.Department, AVG(p.EmployeeSatisfactionScore) AS AvgSatisfaction
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department
ORDER BY AvgSatisfaction DESC;

#Employee Feedback Summary
SELECT e.Name, COUNT(f.FeedbackID) AS FeedbackCount
FROM Employee e
JOIN Feedback f ON e.EmployeeID = f.EmployeeID
GROUP BY e.EmployeeID
ORDER BY FeedbackCount DESC;


#Performance Trends Over Time
SELECT e.Name, p.PerformanceReviewDate, p.ProjectCompletionRate
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
ORDER BY p.PerformanceReviewDate;


#Employee permorfance table view
CREATE VIEW Appleperformance AS
SELECT 
    e.EmployeeID, 
    e.Name, 
    e.Department, 
    p.ProjectCompletionRate, 
    p.TotalTasksCompleted, 
    p.EmployeeSatisfactionScore,
    t.TrainingProgram, 
    t.TrainingHours, 
    f.FeedbackType, 
    f.Comments
FROM Employee e
LEFT JOIN Performance p ON e.EmployeeID = p.EmployeeID
LEFT JOIN Training t ON e.EmployeeID = t.EmployeeID
LEFT JOIN Feedback f ON e.EmployeeID = f.EmployeeID;

SELECT * FROM Appleperformance;
