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
