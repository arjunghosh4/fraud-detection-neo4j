// Q1: How many accounts, devices, and countries are in our network? Idea: Understand what entities exist before visualizing relationships.
MATCH (n)
RETURN labels(n) AS NodeType, count(*) AS Count;

// Q2: Show all accounts that used a device. Idea: To see how accounts and devices connect, check 1:1 or 1:M relationships between users and devices
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)
RETURN a, d
LIMIT 50;

// Q3: Show all devices that are shared by more than one account. Idea: To reveal shared-device hubs (possible collusion or shared infrastructure)
MATCH (d:Device)<-[:USED_DEVICE]-(a:Account)
WITH d, count(a) AS accounts
WHERE accounts > 1
RETURN d, accounts
ORDER BY accounts DESC
LIMIT 10;

// Q4: Find all accounts that share the same device. Idea: Shows account groups controlled by a single device/user
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(b:Account)
WHERE a <> b
RETURN a, d, b
LIMIT 100;

// Q5: Show devices used by the same account multiple times (account hopping). Idea: Detect multi-device access per account, so accounts accessed from multiple devices (possible account takeover or shared login credentials)
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)
WITH a, count(d) AS devices
WHERE devices > 1
MATCH (a)-[:USED_DEVICE]->(d)
RETURN a, d;

// Q6: Find the top 5 devices with the most connected accounts. Idea: most heavily shared devices (fraud hotspots)
MATCH (d:Device)<-[:USED_DEVICE]-(a:Account)
RETURN d.id AS Device, count(a) AS Accounts
ORDER BY Accounts DESC
LIMIT 5;

// Q7: Show transactions flowing into high-risk countries. Idea: Highlights flows into risky jurisdictions (suspicious activity patterns)
MATCH (a:Account)-[:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
RETURN a, b, c
LIMIT 50;

// Q8: Find all transaction loops (money leaving and returning to same account). Idea: Path finding for classic money-laundering pattern, funds circulated through accounts to obscure origins
MATCH p=(a:Account)-[:TRANSFERRED_TO*2..4]->(a)
RETURN p
LIMIT 10;

// Q9: Detect accounts 2 hops away from high-risk countries. Idea: Indirect connections can carry risk, so showing the network effect of bad actors
MATCH (a:Account)-[:TRANSFERRED_TO*1..2]->(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
RETURN DISTINCT a, b, c
LIMIT 100;

// 10: Find “bridge” accounts that connect multiple shared devices. Idea: Identify accounts that tie fraud clusters together, basically connectors between fraud rings (nodes for investigation)
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)
WITH a, collect(d.id) AS devices, size(collect(d.id)) AS numDevices
WHERE numDevices > 1
RETURN a, numDevices, devices
ORDER BY numDevices DESC
LIMIT 10;

// 11. Find all high-risk accounts located in risky countries. Idea: Add flag as true for high risk countries
MATCH (a:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
SET a.flagged = true
RETURN a.id AS Account, c.name AS Country, c.risk AS RiskScore
ORDER BY RiskScore DESC
LIMIT 20;

// 12. Trace the transaction flow from high-risk accounts
MATCH (a:Account {flagged:true})-[:TRANSFERRED_TO*1..3]->(b:Account)
RETURN DISTINCT a, b
LIMIT 50;

// 13. Rank countries by total number of transactions
MATCH (a:Account)-[:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
RETURN c.name AS Country, count(*) AS TransactionCount
ORDER BY TransactionCount DESC
LIMIT 10;

// 14. Find accounts that both send and receive transactions
MATCH (a:Account)-[:TRANSFERRED_TO]->(:Account)-[:TRANSFERRED_TO]->(a)
RETURN DISTINCT a
LIMIT 50;

// 15. Compute average transaction amount per country
MATCH (a:Account)-[t:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
RETURN c.name AS Country, round(avg(t.amount),2) AS AvgAmount
ORDER BY AvgAmount DESC
LIMIT 10;

// 16. Find accounts using devices that appear in multiple risky countries
MATCH (a:Account)-[:USED_DEVICE]->(d:Device)<-[:USED_DEVICE]-(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
RETURN DISTINCT a, d, c
LIMIT 50;

// 17. Identify transaction chains longer than 3 hops
MATCH p=(a:Account)-[:TRANSFERRED_TO*4..6]->(b:Account)
RETURN p
LIMIT 10;

// 18. Detect “hub” accounts - those connected to many others
MATCH (a:Account)-[:TRANSFERRED_TO]->(b:Account)
WITH a, count(b) AS degree
WHERE degree > 5
RETURN a.id AS HubAccount, degree
ORDER BY degree DESC
LIMIT 10;

// 19. Propagate risk through connected accounts
MATCH (a:Account)-[:TRANSFERRED_TO*1..2]->(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
SET a.indirect_risk = true
RETURN DISTINCT a, c
LIMIT 50;

// 20. Find IPs associated with transactions to multiple countries
MATCH (a:Account)-[t:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
WITH t.ip AS ip, collect(DISTINCT c.name) AS countries
WHERE size(countries) > 1
RETURN ip, countries, size(countries) AS CountryCount
ORDER BY CountryCount DESC
LIMIT 10;

// 21. Find high-risk transactions coming from risky IP clusters
MATCH (a:Account)-[t:TRANSFERRED_TO]->(b:Account)-[:LOCATED_IN]->(c:Country)
WHERE c.risk > 0.7
WITH t.ip AS ip, collect(DISTINCT a.id) AS senders, collect(DISTINCT c.name) AS riskyCountries
RETURN ip, size(senders) AS Senders, riskyCountries
ORDER BY Senders DESC
LIMIT 10;