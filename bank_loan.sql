CREATE TABLE bank_loan (
    id INT PRIMARY KEY,
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(50),
    grade VARCHAR(50),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id INT,
    purpose VARCHAR(50),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount INT,
    total_acc INT,
    total_payment INT
);

COPY bank_loan from 'D:/SQL project Dataset/financial_loan1.csv' DELIMITER ','
CSV HEADER;

ALTER TABLE bank_loan
ALTER COLUMN emp_title TYPE VARCHAR(200),
ALTER COLUMN purpose TYPE VARCHAR(200),
ALTER COLUMN address_state TYPE VARCHAR(100),
ALTER COLUMN emp_length TYPE VARCHAR(100),
ALTER COLUMN home_ownership TYPE VARCHAR(100),
ALTER COLUMN grade TYPE VARCHAR(10),
ALTER COLUMN sub_grade TYPE VARCHAR(10),
ALTER COLUMN loan_status TYPE VARCHAR(100),
ALTER COLUMN application_type TYPE VARCHAR(100),
ALTER COLUMN verification_status TYPE VARCHAR(100);
SELECT * FROM bank_loan;


--Total Loan Applications
SELECT COUNT(id) as Total_Loan_Application from bank_loan;


--Month To Date Loan Applications
SELECT COUNT(id) AS MTD_Total_Applications FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Previous Month To Date Loan Applications
SELECT COUNT(id) AS PMTD_Total_Applications FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan;

--Month to date Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Previous Month to date Total Funded Amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan;

--Month To Date Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Collected FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Previous Month To Date Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Collected FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Average Interest Rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM bank_loan;

--MTD Average Interest
SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD Average Interest
SELECT AVG(int_rate)*100 AS PMTD_Avg_Int_Rate FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Avg DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan;

--MTD_Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD_Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan;

--Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

--Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan;

--Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan
WHERE loan_status = 'Charged Off';

--Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan
WHERE loan_status = 'Charged Off';

--Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan
WHERE loan_status = 'Charged Off';

--Loan Overview
SELECT
        loan_status,
        COUNT(id) AS Total_loan_Application,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        bank_loan
    GROUP BY
        loan_status

--Loan Overview MTD
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 
GROUP BY loan_status;

--Monthly Trends
SELECT 
	EXTRACT(MONTH FROM issue_date) AS month_number,
	TO_CHAR(issue_date, 'Month') AS month_name,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amount,
	SUM(total_payment) AS total_amount_received
FROM bank_loan
GROUP BY 
	EXTRACT(MONTH FROM issue_date), 
	TO_CHAR(issue_date, 'Month')
ORDER BY month_number;

--State Trends
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY address_state
ORDER BY address_state;

--Term
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY term
ORDER BY term;

--EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

--Purpose of Loan
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC;

--Home Ownership
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;















