import pandas as pd


df = pd.read_csv(
    "customer_support_tickets.csv",
    on_bad_lines='skip'
)


df = df.replace(r'\n', ' ', regex=True)


df.to_csv(
    "customer_support_tickets_clean.csv",
    index=False
)

print("Cleaned dataset saved successfully.")