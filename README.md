# Sierra ILS Collection Development - INN-Reach Overdue Automated Report
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/python-%233670A0.svg?style=for-the-badge&logo=python&logoColor=ffdd54)

## Summary
**What it does:** This automated report lists collection items loaned to INN-Reach (Link+) libraries that are 30+ days overdue.

**Impact:** Empowers collection development librarians by automatically delivering a monthly scheduled report that includes actionable insights on items to consider for repurchase.

## Features and Deliverables

**Automated Email:**

<img width="730" height="563" alt="Link+ Overdue Items Email" src="https://github.com/user-attachments/assets/6048dedd-42fa-4f76-a85a-67a46b22d136" />

**Attached Excel Report:**

<img width="1310" height="918" alt="Link-Overdue" src="https://github.com/user-attachments/assets/d30175c8-cf89-4ede-8d2f-fb40eb9be0b6" />


<img width="1307" height="921" alt="Link-Overdue" src="https://github.com/user-attachments/assets/0a870939-4133-4869-8e12-9b670abe43f5" />

## Data Pipeline Architecture
This repository features an automated data pipeline that generates, formats, and distributes Excel reports via email. The system integrates Windows Task Scheduler, a Batch script, SQL, and Python to handle the end-to-end workflow without manual intervention. The automated process is fully productionized within a Windows environment.

**Workflow Overview:**

[Windows Task Scheduler] ──> [orchestrator.bat] ──> [main.py] ──> [Sub-modules & SQL] ──> [Report delivered to Email Inbox]

**Repository Contents & Security Note:**

To comply with data security policies, the core Python automation scripts have been omitted from this public repository. Instead, this repository provides:
- The SQL Data-Extraction Script: The exact logic used to pull and aggregate Sierra ILS production data.
- Manual Alternative: If you do not have an automated environment, you can run the provided SQL script manually in pgAdmin and export the results directly to a spreadsheet.

## Acknowledgments
The automated pipeline is built off the brilliant work of Gem Stone-Logan. For more information on implementing the automated system, please see her IUG presentations, [Automating Reports with Python.](https://www.gemstonelogan.com/presentations.html)
