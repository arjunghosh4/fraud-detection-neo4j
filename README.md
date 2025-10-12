Fraud Detection with Neo4j — Guide

![Fraud Detection Dashboard Preview](images/dashboard_preview.png)

Project: fraud-detection-neo4j
Purpose: A hands-on lab to show how transaction data can be modeled and analyzed as a graph to detect shared identifiers, risky jurisdictions, and suspicious transaction patterns.
What you will get working:
	•	Single CSV dataset → import to Neo4j
	•	Neo4j graph with Account, Device, Country nodes and relationships
	•	Several Cypher lab queries with visuals you can export (PNG)
	•	A Streamlit dashboard that reads the same Neo4j DB and shows KPIs

⸻

Table of Contents
	1.	Prerequisites
	2.	Repository structure (what’s in the repo)
	3.	Quick start (one-command checklist)
	4.	Detailed steps
	•	Clone repo
	•	Create & activate Python environment
	•	Generate dataset
	•	Install Neo4j Desktop & create DBMS
	•	Import CSV into Neo4j (copy file → run Cypher)
	•	Run verification and analysis queries
	•	Export visuals (PNG)
	•	Run Streamlit dashboard
	5.	Lab questions (10 queries for students)
	6.	What to submit
	7.	Troubleshooting & FAQs
	8.	Appendix — useful commands & Cypher snippets

⸻

1) Prerequisites

Before you start, install the following on your machine:
	•	Git (for cloning the repo)
	•	Python 3.9+ (3.10 or 3.11 recommended)
	•	Neo4j Desktop (free) or access to a Neo4j instance (Neo4j Aura or Neo4j Desktop)
	•	Neo4j Desktop download: https://neo4j.com/download/
	•	Optional but recommended: a code editor (VS Code)

You will also install Python packages listed in requirements.txt later.

⸻

2) Repository structure (what you should see)

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
├── images/                        # put exported PNGs here
│   ├── graph_shared_devices.png
│   └── dashboard_preview.png
│
├── README.md                      # this file
└── requirements.txt

⸻

3) Quick start (one-command checklist)

If you just want to run everything quickly, follow these four steps:
	1.	Clone this repo:

git clone https://github.com/arjunghosh4/fraud-detection-neo4j.git
cd fraud-detection-neo4j

	2.	Create Python environment & install packages:

python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS / Linux:
source .venv/bin/activate
pip install -r requirements.txt

	3.	Generate the CSV:

python scripts/data_gen.py

	4.	Start Neo4j Desktop, create and start a local DBMS, copy data/transactions.csv into the DBMS import folder, then open Neo4j Browser and run:

:source scripts/neo4j_import.cypher

	5.	Run Streamlit (optional):

streamlit run scripts/streamlit_app.py

Detailed instructions below.

⸻

4) Detailed step-by-step instructions

A — Clone the repo

Open a terminal and run:

git clone https://github.com/arjunghosh4/fraud-detection-neo4j.git
cd fraud-detection-neo4j

⸻

B — Create and activate Python virtual environment (recommended)

python -m venv .venv

# Windows (PowerShell)
.venv\Scripts\Activate.ps1

# Windows (cmd.exe)
.venv\Scripts\activate

# macOS / Linux
source .venv/bin/activate

Install dependencies:

pip install -r requirements.txt

requirements.txt should include:

pandas
streamlit
neo4j
py2neo


⸻

C — Generate the dataset (one CSV)

We provide scripts/data_gen.py to create a realistic synthetic dataset.

Run:

python scripts/data_gen.py

This creates data/transactions.csv. Confirm it exists:

ls data
# or on Windows
dir data

Note: If you want to tweak the amount of data or sharing behavior (e.g., more shared devices), open scripts/data_gen.py and edit the parameters at the top.

⸻

D — Install Neo4j Desktop and create a DBMS
	1.	Download and install Neo4j Desktop from neo4j.com.
	2.	Open Neo4j Desktop.
	3.	Create a new Project (click + New → Project, name it Fraud Lab).
	4.	Inside the project, Add → Local DBMS.
	•	Name: fraud-detection-db
	•	Password: choose a password (for examples we use neo4j — but pick something secure).
	5.	Start the DBMS (click play ▶). Wait until it’s Running.

Find the import folder path:
	•	Click the three dots (⋮) next to your DBMS → Manage → Files → you will see Import Folder: <path>.

⸻

E — Copy transactions.csv into Neo4j import folder

Copy the generated CSV into the DBMS import folder:

Windows example (PowerShell)

Copy-Item -Path ".\data\transactions.csv" -Destination "C:\Users\<you>\Neo4j\relate-data\dbmss\<db-id>\import"

macOS / Linux example

cp data/transactions.csv "/Users/<you>/Library/Application Support/Neo4j Desktop/Application/relate-data/dbmss/<db-id>/import/"

⸻

F — Import CSV into Neo4j using the provided Cypher

Open Neo4j Browser (click Query or Open Browser in Neo4j Desktop). Log in (user: neo4j, password: the one you set).

First test that Neo4j sees the CSV:

LOAD CSV WITH HEADERS FROM "file:///transactions.csv" AS row
RETURN count(row);

You should see the number of rows (e.g., 2000).

Then run the import script (copy-paste or use :source):

Option A — paste script
Open the file scripts/neo4j_import.cypher in your editor, copy its contents, paste into Neo4j Browser and run.

Option B — run source
If your Neo4j Browser has access to the repo path or you placed the .cypher in the import folder, you can run:

:source scripts/neo4j_import.cypher

(Usually paste/copy is easiest.)

This script:
	•	Creates Account nodes for from_account and to_account
	•	Creates Device and Country nodes
	•	Sets Country.risk property
	•	Creates TRANSFERRED_TO relationships (with amount, time, ip)
	•	Creates USED_DEVICE and LOCATED_IN relationships

⸻

G — Verify graph creation (quick checks)

Run these queries in Neo4j Browser to confirm:

Counts by label

MATCH (n) RETURN labels(n) AS label, count(n) AS count;

Sample graph view

MATCH (a:Account)-[r]->(b) RETURN a,r,b LIMIT 50;

If everything looks good, proceed to the lab queries below.

⸻

H — Export visuals (PNG) to include in your report
	1.	Run one of the lab queries (see next section).
	2.	In the result panel, switch to the Graph view.
	3.	Arrange layout:
	•	Right-click graph → Layout → Radial / Force-directed / Hierarchical
	•	Use the style (palette) icon to color labels as you like (Account, Device, Country)
	4.	Click the camera icon (top-right) → Download as PNG.
	5.	Save into images/ folder in the repo:
	•	images/Q4_shared_devices.png, etc.

Add the PNG file(s) to the repo:

git add images/Q4_shared_devices.png
git commit -m "Add shared devices visualization"
git push

⸻

I — Run the Streamlit dashboard

Open a new terminal (ensure your Python virtual environment is activated) and start Streamlit:

streamlit run scripts/streamlit_app.py

Then open http://localhost:8501 in your browser.

⸻

Setting Neo4j Credentials (using .env file)

Before running the dashboard, create a small .env file inside the scripts/ folder with your Neo4j details:

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password

⚠️ Replace neo4jpwd with the password you used when creating your DBMS in Neo4j Desktop.
Keep this file private, do not commit it to GitHub.

The app automatically loads these credentials using python-dotenv.

If you prefer to set them manually for testing, you can also run:

macOS / Linux

export NEO4J_URI="bolt://localhost:7687"
export NEO4J_USER="neo4j"
export NEO4J_PASSWORD="your_password"

Windows (PowerShell)

$env:NEO4J_URI="bolt://localhost:7687"
$env:NEO4J_USER="neo4j"
$env:NEO4J_PASSWORD="your_password"

⸻

Once credentials are set, the Streamlit app connects to Neo4j and shows KPIs,
top devices, and high-risk transactions from the graph database.

If credentials are missing, the app will stop and show an on-screen warning.

⸻

5) Lab questions (10 queries) — student exercises

What to deliver for each question:
	•	Query text (copy into your answers)
	•	PNG exported from Neo4j (put in /images/)
	•	Short interpretation (2–4 sentences): what pattern is visible and why it might be suspicious

⸻

6) What to submit (suggested)

If your professor expects a deliverable, submit a small package (either a GitHub link to your repo or a zip containing):
	•	scripts/ folder with data_gen.py, neo4j_import.cypher, fraud_lab_queries.cypher, streamlit_app.py
	•	data/transactions.csv (or instructions to generate)
	•	images/ folder with exported PNGs (at least 4 visuals)
	•	README.md (this file) with:
	•	Steps you followed
	•	List of queries you ran
	•	Explanations for each saved image

⸻

7) Troubleshooting & FAQs

Q: LOAD CSV gives “file not found” or Failed to fetch file
A: Make sure transactions.csv is in your DBMS import folder (the path shown in Neo4j Desktop → Manage → Files). Use file:///transactions.csv exactly.

Q: Permission denied / import fails
A: Ensure the DBMS is running before running LOAD CSV. Restart DBMS and try again.

Q: Streamlit fails to connect to Neo4j
A: Edit scripts/ .env to set the correct Neo4j password and URI. Example:

The app loads credentials automatically from your .env file.
If Streamlit fails to connect, confirm that your .env file (in scripts/) contains:

NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password

and that your Neo4j Desktop DBMS is running locally.

Q: Queries return no results
A: Try a simple check:

MATCH (n) RETURN count(n);

If zero, the import did not run — re-run neo4j_import.cypher.

Q: PNGs too small or crowded
A: Use LIMIT to reduce returned nodes. Try different layouts (Radial, Force-directed) and increase Neo4j Browser zoom before exporting.

⸻

8) Appendix — useful commands & snippets

Clear the graph (if you want to re-import fresh data):

MATCH (n) DETACH DELETE n;

Run a single file of Cypher commands (paste into Neo4j Browser):
	•	Open the .cypher file and paste contents → run
	•	OR :source scripts/fraud_lab_queries.cypher (browser support varies; copy-paste is safest)

Neo4j Browser tips
	•	Use the left sidebar to access query history and favorites
	•	Use the Graph Style palette to color nodes by label and show label text
	•	Use the camera icon to export images

⸻