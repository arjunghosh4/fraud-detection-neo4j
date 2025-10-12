// neo4j_import.cypher
// --------------------
// Run this in Neo4j Browser after placing transactions.csv in your import folder

LOAD CSV WITH HEADERS FROM "file:///transactions.csv" AS row
MERGE (a:Account {id: row.from_account})
MERGE (b:Account {id: row.to_account})
MERGE (d:Device {id: row.device_id})
MERGE (c:Country {name: row.country})
SET c.risk = toFloat(row.risk_score)
MERGE (a)-[:TRANSFERRED_TO {
    amount: toFloat(row.amount),
    time: row.timestamp,
    ip: row.ip_address
}]->(b)
MERGE (a)-[:USED_DEVICE]->(d)
MERGE (b)-[:USED_DEVICE]->(d)
MERGE (b)-[:LOCATED_IN]->(c);