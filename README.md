# 🚀 Fraud Detection with Neo4j — Guide

<p align="center">
  <img src="images/dashboard_preview.png" alt="Fraud Detection Dashboard Preview" width="750">
</p>

<p align="center">
  <em>End-to-end fraud detection pipeline using Neo4j graphs and Streamlit dashboards.<br>
  Model transactions as nodes and relationships to uncover shared devices, high-risk jurisdictions, and suspicious money flows.</em>
</p>

---

## 🧭 Table of Contents
1. [Prerequisites](#-prerequisites)
2. [Repository Structure](#-repository-structure)
3. [Quick Start](#-quick-start)
4. [Detailed Steps](#-detailed-steps)
5. [Setting Neo4j Credentials](#-setting-neo4j-credentials)
6. [Lab Questions](#-lab-questions)
7. [What to Submit](#-what-to-submit)
8. [Troubleshooting](#-troubleshooting)
9. [Appendix](#-appendix)

---

## 🧰 Prerequisites

Install the following before starting:

- [Git](https://git-scm.com/)
- [Python 3.9+](https://www.python.org/downloads/) (3.10 or 3.11 recommended)
- [Neo4j Desktop](https://neo4j.com/download/)
- [VS Code](https://code.visualstudio.com/) *(optional but recommended)*

Install required Python packages later using:

```bash
pip install -r requirements.txt


⸻

📂 Repository Structure

fraud-detection-neo4j/
│
├── data/
│   └── transactions.csv           # (generated) main CSV dataset
│
├── scripts/
│   ├── data_gen.py                # script to generate transactions.csv
│   ├── neo4j_import.cypher        # Cypher script to create nodes/relationships
│   ├── fraud_lab_queries.cypher   # (optional) lab queries for students
│   └── streamlit_app.py           # Streamlit dashboard (reads Neo4j)
│
├── images/                        # exported visuals
│   ├── graph_shared_devices.png
│   └── dashboard_preview.png
│
├── requirements.txt
└── README.md


⸻

⚡ Quick Start

If you just want to get everything running quickly:

# 1️⃣ Clone this repo
git clone https://github.com/arjunghosh4/fraud-detection-neo4j.git
cd fraud-detection-neo4j

# 2️⃣ Create a virtual environment
python -m venv .venv
source .venv/bin/activate        # macOS / Linux
# OR
.venv\Scripts\activate           # Windows

# 3️⃣ Install dependencies
pip install -r requirements.txt

# 4️⃣ Generate the dataset
python scripts/data_gen.py

# 5️⃣ Import data into Neo4j
#   - Start Neo4j Desktop
#   - Copy data/transactions.csv → Neo4j import folder
#   - Run this inside Neo4j Browser:
:source scripts/neo4j_import.cypher

# 6️⃣ Run the Streamlit dashboard
streamlit run scripts/streamlit_app.py

Then open your browser at http://localhost:8501 🎨

⸻

🔍 Detailed Steps

1️⃣ Create a New Neo4j DBMS
	1.	Open Neo4j Desktop.
	2.	Create a new Project → Name it Fraud Lab.
	3.	Add a Local DBMS:
	•	Name: fraud-detection-db
	•	Password: neo4j2025 (or any password you choose)
	4.	Start the DBMS (click ▶️ Play).
	5.	Note the Import folder path:
	•	Right-click → Manage → Files → find “Import Folder”.

2️⃣ Copy CSV File into Import Folder

# Example macOS/Linux:
cp data/transactions.csv "/Users/<you>/Library/Application Support/Neo4j Desktop/Application/relate-data/dbmss/<db-id>/import/"

# Example Windows (PowerShell):
Copy-Item -Path ".\data\transactions.csv" -Destination "C:\Users\<you>\Neo4j\relate-data\dbmss\<db-id>\import"

3️⃣ Load Data into Neo4j

In Neo4j Browser, run:

LOAD CSV WITH HEADERS FROM "file:///transactions.csv" AS row
RETURN count(row);

You should see the total row count.
Then import:

:source scripts/neo4j_import.cypher

This creates:
	•	Account, Device, and Country nodes
	•	Relationships: TRANSFERRED_TO, USED_DEVICE, and LOCATED_IN

⸻

🔐 Setting Neo4j Credentials

Before running the Streamlit app, create a .env file inside scripts/ with:

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=neo4j2025

⚠️ Replace neo4j2025 with your own DBMS password.
Keep this file private — do not commit it to GitHub.

If you don’t want to use .env, you can also set environment variables manually:

macOS / Linux

export NEO4J_URI="bolt://localhost:7687"
export NEO4J_USER="neo4j"
export NEO4J_PASSWORD="your_password"

Windows (PowerShell)

$env:NEO4J_URI="bolt://localhost:7687"
$env:NEO4J_USER="neo4j"
$env:NEO4J_PASSWORD="your_password"

Once credentials are set, run:

streamlit run scripts/streamlit_app.py


⸻

🧪 Lab Questions

These queries help visualize different fraud detection patterns.
Run them in Neo4j Browser and export results as PNGs.

#	Objective	Sample Cypher Query
1	Count nodes by label	MATCH (n) RETURN labels(n), count(n);
2	Accounts using same device	MATCH (a:Account)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(b:Account) WHERE a<>b RETURN a,d,b;
3	Devices with >1 linked accounts	MATCH (d:Device)<-[:USED_DEVICE]-(a:Account) WITH d,count(a) AS c WHERE c>1 RETURN d,c;
4	Accounts in risky countries	MATCH (a:Account)-[:LOCATED_IN]->(c:Country) WHERE c.risk>0.7 RETURN a,c;
5	Circular money flow	MATCH p=(a:Account)-[:TRANSFERRED_TO*2..4]->(a) RETURN p LIMIT 10;
6	Top devices by connected accounts	MATCH (d:Device)<-[:USED_DEVICE]-(a:Account) RETURN d.id, count(a) ORDER BY count(a) DESC LIMIT 5;

Export visuals as PNG using the camera icon in Neo4j Browser.

⸻

🧾 What to Submit

If submitting as coursework:
	•	✅ /images/ folder with at least 4 exported visuals
	•	✅ Queries used and short 2–3 line interpretations
	•	✅ Optional: Streamlit screenshot (dashboard_preview.png)
	•	✅ A link to your GitHub repo or zipped folder

⸻

🧯 Troubleshooting

🔸 LOAD CSV gives “file not found”
Ensure transactions.csv is inside the Neo4j import folder.

🔸 Streamlit fails to connect
Check your .env file:

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password

and make sure the Neo4j DBMS is running.

🔸 No results in queries
Run:

MATCH (n) RETURN count(n);

If it returns 0, re-run the import.

🔸 Graph too cluttered
Use smaller LIMIT values or the “Radial” layout before exporting PNGs.

⸻

📘 Appendix

# Clear graph (re-import fresh data)
MATCH (n) DETACH DELETE n;

# Verify counts
MATCH (n) RETURN labels(n), count(*);

# Reload data
:source scripts/neo4j_import.cypher


⸻


<p align="center">
  <em>Developed by Arjun Krishna Ghosh — visualize fraud detection through connected data and graph analytics.</em>
</p>
```