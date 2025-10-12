import streamlit as st
from neo4j import GraphDatabase
import pandas as pd
import os
from dotenv import load_dotenv

# ---------------------------
# Neo4j connection setup
# ---------------------------
dotenv_path = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv()

uri = os.getenv("NEO4J_URI") # Local Neo4j runs on this port
user = os.getenv("NEO4J_USER")
password = os.getenv("NEO4J_PASSWORD")
driver = GraphDatabase.driver(uri, auth=(user, password))

# ---------------------------
# Query function
# ---------------------------
def run_query(q):
    with driver.session() as session:
        result = session.run(q)
        return [r.data() for r in result]

# ---------------------------
# Streamlit Page Config
# ---------------------------
st.set_page_config(page_title="Fraud Detection Dashboard", layout="wide")
st.title("Fraud Detection Analytics Dashboard (Neo4j)")

# ---------------------------
# KPIs Section
# ---------------------------
col1, col2, col3 = st.columns(3)
accounts = run_query("MATCH (a:Account) RETURN count(a) AS c")[0]['c']
transactions = run_query("MATCH ()-[t:TRANSFERRED_TO]->() RETURN count(t) AS c")[0]['c']
countries = run_query("MATCH (c:Country) RETURN count(c) AS c")[0]['c']

col1.metric("Accounts", accounts)
col2.metric("Transactions", transactions)
col3.metric("Countries", countries)

st.divider()

# ---------------------------
# High-Risk Countries
# ---------------------------
st.subheader("High-Risk Countries (Risk > 0.7)")
risk_data = run_query("""
MATCH (c:Country)
WHERE c.risk > 0.7
RETURN c.name AS Country, c.risk AS Risk
ORDER BY Risk DESC
""")
df_risk = pd.DataFrame(risk_data)
st.dataframe(df_risk)

st.divider()

# ---------------------------
# Shared Devices
# ---------------------------
st.subheader("Shared Devices (Used by Multiple Accounts)")
shared = run_query("""
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(b:Account)
WHERE a<>b
RETURN d.id AS Device, count(*) AS Connections
ORDER BY Connections DESC LIMIT 10
""")
df_shared = pd.DataFrame(shared)
st.bar_chart(df_shared.set_index("Device"))

st.divider()

# ---------------------------
# High-Risk Transaction Paths
# ---------------------------
st.subheader("High-Risk Transaction Paths (to risky countries)")
paths = run_query("""
MATCH (a:Account)-[:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
RETURN a.id AS Sender, b.id AS Receiver, c.name AS Country, c.risk AS Risk
LIMIT 20
""")
st.dataframe(pd.DataFrame(paths))

st.divider()

# ---------------------------
# Top 10 Senders
# ---------------------------
st.subheader("💰 Top 10 Senders (by Total Amount Sent)")
top_senders = run_query("""
MATCH (a:Account)-[t:TRANSFERRED_TO]->()
RETURN a.id AS Sender, sum(t.amount) AS TotalSent
ORDER BY TotalSent DESC LIMIT 10
""")
df_top = pd.DataFrame(top_senders)
st.bar_chart(df_top.set_index("Sender"))

st.success("Dashboard connected successfully to Neo4j!")