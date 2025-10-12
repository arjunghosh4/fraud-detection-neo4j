"""
data_gen.py
------------
Generates synthetic transaction data for fraud detection demo in Neo4j.

Output: ../data/transactions.csv
"""

import pandas as pd
import random
from datetime import datetime, timedelta
import os

# Set up reproducibility
random.seed(42)

# Output path
DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")
os.makedirs(DATA_DIR, exist_ok=True)
CSV_PATH = os.path.join(DATA_DIR, "transactions.csv")

# Parameters
NUM_ACCOUNTS = 300
NUM_TRANSACTIONS = 2000
NUM_DEVICES = 100
COUNTRIES = [
    ("USA", 0.2),
    ("UK", 0.3),
    ("Germany", 0.25),
    ("Canada", 0.2),
    ("Singapore", 0.35),
    ("Cayman Islands", 0.9),
    ("Panama", 0.85),
    ("India", 0.25),
    ("France", 0.3),
    ("UAE", 0.4),
]

accounts = [f"ACC{str(i).zfill(4)}" for i in range(1, NUM_ACCOUNTS + 1)]
devices = [f"D{str(i).zfill(3)}" for i in range(1, NUM_DEVICES + 1)]

# Generate transactions
def random_date():
    start = datetime.now() - timedelta(days=30)
    delta = timedelta(seconds=random.randint(0, 30 * 24 * 60 * 60))
    return (start + delta).strftime("%Y-%m-%d %H:%M:%S")

transactions = []
for _ in range(NUM_TRANSACTIONS):
    sender = random.choice(accounts)
    receiver = random.choice(accounts)
    while receiver == sender:
        receiver = random.choice(accounts)

    device = random.choice(devices)
    country, risk = random.choice(COUNTRIES)
    amount = round(random.uniform(10, 2000), 2)
    if random.random() < 0.05:
        # occasionally high amount or high-risk
        amount = round(random.uniform(5000, 20000), 2)
        country, risk = random.choice([("Cayman Islands", 0.9), ("Panama", 0.85)])
    ip_octets = [str(random.randint(10, 255)) for _ in range(4)]
    ip_address = ".".join(ip_octets)

    transactions.append({
        "from_account": sender,
        "to_account": receiver,
        "amount": amount,
        "device_id": device,
        "ip_address": ip_address,
        "country": country,
        "risk_score": risk,
        "timestamp": random_date(),
    })

df = pd.DataFrame(transactions)
df.to_csv(CSV_PATH, index=False)

print(f"Generated {len(df)} transactions at {CSV_PATH}")
print(df.head(10))