 Q1: How many accounts, devices, and countries are in our network? Idea: Understand what entities exist before visualizing relationships.
 Q2: Show all accounts that used a device. Idea: To see how accounts and devices connect, check 1:1 or 1:M relationships between users and devices
 Q3: Show all devices that are shared by more than one account. Idea: To reveal shared-device hubs (possible collusion or shared infrastructure)
 Q4: Find all accounts that share the same device. Idea: Shows account groups controlled by a single device/user
 Q5: Show devices used by the same account multiple times (account hopping). Idea: Detect multi-device access per account, so accounts accessed from multiple devices (possible account takeover or shared login credentials)
 Q6: Find the top 5 devices with the most connected accounts. Idea: most heavily shared devices (fraud hotspots)
 Q7: Show transactions flowing into high-risk countries. Idea: Highlights flows into risky jurisdictions (suspicious activity patterns)
 Q8: Find all transaction loops (money leaving and returning to same account). Idea: Path finding for classic money-laundering pattern, funds circulated through accounts to obscure origins
 Q9: Detect accounts 2 hops away from high-risk countries. Idea: Indirect connections can carry risk, so showing the network effect of bad actors
 10: Find “bridge” accounts that connect multiple shared devices. Idea: Identify accounts that tie fraud clusters together, basically connectors between fraud rings (nodes for investigation)
 11. Find all high-risk accounts located in risky countries. Idea: Add flag as true for high risk countries
 12. Trace the transaction flow from high-risk accounts
 13. Rank countries by total number of transactions
 14. Find accounts that both send and receive transactions
 15. Compute average transaction amount per country
 16. Find accounts using devices that appear in multiple risky countries
 17. Identify transaction chains longer than 3 hops
 18. Detect “hub” accounts - those connected to many others
 19. Propagate risk through connected accounts
 20. Find IPs associated with transactions to multiple countries
 21. Find high-risk transactions coming from risky IP clusters
 22. Identify accounts that are both a 'Hub' (high transaction degree) and are flagged for high risk. Idea: Combining two separate indicators (high connection count and high-risk flag) to pinpoint the most critical accounts for investigation. This leverages the pre-calculated risk flag and the calculated degree centrality.
 23. Find devices used by accounts that have transacted with high-risk countries AND accounts that share the same device. Idea: Detecting shared devices where one user has confirmed high-risk activity (transaction to a risky country) and another account is connected to the same device. This links high-risk transaction patterns to potential collusion via shared infrastructure.
 24. Calculate the risk score of a country based not only on its internal risk but also on the average risk score of countries it transfers funds to. Idea: Creating a derived, external risk metric (a form of propagation) for a country by analyzing where its accounts send money. This is a deeper look into the country's network position.
 25. Find the shortest path (in terms of accounts) between the two accounts with the highest total transaction amounts. Idea: A pathfinding query used for investigative purposes to see how two seemingly unrelated high-value targets (potential ringleaders) are connected in the network.