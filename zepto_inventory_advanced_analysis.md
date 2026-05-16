# Zepto Inventory - Advanced Interactive Analysis Follow-up

This document outlines an interactive, advanced follow-up to the core PostgreSQL data analysis. Having completed the initial Exploratory Data Analysis (EDA) and data cleaning, you can now elevate your project with interactive dashboards and advanced SQL analytics.

## 1. Advanced SQL Business Insights

To derive deeper insights from your inventory, try running these advanced queries in PostgreSQL:

### A. Inventory Aging & Capital Blocked
Calculate the total capital tied up in inventory for each category to identify where your money is locked.
```sql
SELECT 
    category,
    SUM(availableQuantity) as total_items_in_stock,
    SUM(mrp * availableQuantity) as total_capital_blocked
FROM zepto
WHERE OutOfStock = FALSE
GROUP BY category
ORDER BY total_capital_blocked DESC;
```

### B. High Discount vs. Movement Analysis
Identify if high discounts are actually offered on products that are abundant in stock.
```sql
SELECT 
    name,
    discountPercent,
    availableQuantity,
    CASE 
        WHEN discountPercent >= 20 AND availableQuantity > 50 THEN 'Clearance Candidate'
        WHEN discountPercent < 5 AND availableQuantity < 10 THEN 'Restock Alert'
        ELSE 'Normal'
    END as stock_status
FROM zepto
ORDER BY discountPercent DESC, availableQuantity DESC;
```

## 2. Interactive Data Visualization with Python

To make this analysis "interactive", you can connect your PostgreSQL database to a Python environment (like Jupyter Notebook or a Streamlit app).

### Setup Interactive Environment
1. **Install required libraries:**
   ```bash
   pip install pandas sqlalchemy psycopg2-binary streamlit plotly
   ```

2. **Connect to PostgreSQL using Python:**
   ```python
   import pandas as pd
   from sqlalchemy import create_engine

   # Replace with your actual credentials
   engine = create_engine('postgresql://username:password@localhost:5432/your_database')

   # Load data directly from your database
   query = "SELECT * FROM zepto;"
   df = pd.read_sql(query, engine)
   ```

### Create a Streamlit Dashboard
You can create an interactive web app with just a few lines of code. Save this as `app.py` and run `streamlit run app.py`:

```python
import streamlit as st
import pandas as pd
import plotly.express as px
from sqlalchemy import create_engine

st.title("🛒 Zepto Inventory Interactive Dashboard")

# Connect to database
@st.cache_data
def load_data():
    engine = create_engine('postgresql://username:password@localhost:5432/your_database')
    return pd.read_sql("SELECT * FROM zepto;", engine)

df = load_data()

# Interactive Filters
category = st.sidebar.selectbox("Select Category", df['category'].unique())
filtered_df = df[df['category'] == category]

# Visualization 1: Discount vs MRP
st.subheader(f"Price vs Discount for {category}")
fig = px.scatter(filtered_df, x="mrp", y="discountpercent", size="availablequantity", 
                 hover_name="name", color="outofstock")
st.plotly_chart(fig)

# Visualization 2: Top Products by Revenue Potential
st.subheader("Top Revenue Potential")
filtered_df['revenue_potential'] = filtered_df['discountedsellingprice'] * filtered_df['availablequantity']
top_revenue = filtered_df.nlargest(10, 'revenue_potential')
fig2 = px.bar(top_revenue, x="name", y="revenue_potential", color="revenue_potential")
st.plotly_chart(fig2)
```

## 3. Next Steps for the GitHub Repository

To make your GitHub repository stand out to recruiters and peers:

1. **Add a `requirements.txt`**: List all the tools and libraries used.
2. **Add Visuals to `README.md`**: Run the SQL queries, take screenshots of the results in pgAdmin, and embed them in your README.
3. **Include the ERD**: If you expand this to a multi-table schema (e.g., separating `Categories` and `Products`), include an Entity-Relationship Diagram.
