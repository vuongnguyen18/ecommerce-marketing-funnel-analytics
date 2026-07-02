# ecommerce-marketing-funnel-analytics
End-to-end Power BI and SQL Server project analysing e-commerce customer journey, marketing funnel conversion, traffic source performance, customer segments, and drop-off opportunities.

# E-commerce Customer Journey & Conversion Funnel Analytics

## Project Overview

This project analyses an e-commerce customer journey from website sessions and product interactions to completed purchases. The goal is to identify which traffic sources, devices, and customer segments drive the strongest conversion, where users drop off before purchase, and what actions the business should take to improve funnel performance.

**Domain:** Marketing Analytics  
**Tools:** SQL Server, Power BI, DAX, Python  
**Dashboard Focus:** Conversion funnel, traffic source performance, device performance, customer segment analysis, and drop-off recommendations.

---

## Business Question

**Which traffic sources, devices, and customer segments drive the highest conversion, and where do users drop off before purchase?**

This question was translated into a practical analytics workflow:

```text
Business Question
→ SQL Cleaning
→ Metric Layer
→ Power BI Dashboard
→ Python Analysis
→ Recommendation
```

---

## Portfolio Workflow

### 1. Business Question

The project starts with a marketing analytics question:

> Which traffic sources, devices, and customer segments drive the highest conversion, and where do users drop off before purchase?

The analysis focuses on understanding user behaviour across the funnel:

```text
View → Click → Add to Cart → Purchase
```

### 2. SQL Cleaning

SQL Server was used to clean, validate, and transform the raw e-commerce data before loading it into Power BI.

The cleaning process included:

- Checking missing values across customer, session, interaction, product, and purchase data.
- Checking duplicate keys such as `user_id`, `session_id`, `interaction_id`, and `purchase_id`.
- Validating transaction fields such as `quantity`, `unit_price`, and `total_amount`.
- Recalculating purchase amount using `quantity × unit_price` to check transaction accuracy.
- Checking relationship consistency across users, sessions, interactions, and purchases.
- Removing non-essential fields from the final reporting model to keep the dashboard focused on marketing funnel analysis.
- Creating a session-level fact table for Power BI.

The final SQL output was designed as a Power BI-ready star schema.

### 3. Metric Layer

The metric layer defines the key measures used across the dashboard.

Core metrics include:

- Total Sessions
- Total Users
- Converted Sessions
- Total Purchases
- Total Revenue
- Average Order Value
- Revenue per Session
- Revenue per User
- Purchase Conversion Rate

Funnel metrics include:

- Sessions with View
- Sessions with Click
- Sessions with Add to Cart
- Sessions with Purchase
- View-to-Click Rate
- Click-to-Cart Rate
- Cart-to-Purchase Rate
- Drop-off Rate

These measures were created using DAX and organised into dedicated measure tables in Power BI.

### 4. Power BI Dashboard

A multi-page Power BI dashboard was built to analyse funnel performance, traffic source effectiveness, device performance, customer behaviour, and customer segment conversion.

Dashboard pages:

1. **Executive Overview**  
   Summarises overall funnel health, revenue, conversion rate, monthly trend, traffic source conversion, and drop-off distribution.

2. **Channel Performance**  
   Compares traffic sources and device types by sessions, conversion rate, revenue per session, and source-device performance.

3. **Customer Segment Analysis**  
   Analyses customer value by loyalty tier, income level, age group, referrer source, and device type. This page uses a decomposition tree and heatmap to identify high-value customer groups and conversion-supporting channels.

4. **Conversion Opportunities**  
   Converts funnel findings into action. This page focuses on drop-off stages, funnel transition rates, source-level drop-off patterns, and business recommendations.

### 5. Python Analysis

Python can be used as an analytical extension to examine session-level funnel progression and identify where users dropped off across the journey from product view to purchase.

Potential Python analysis includes:

- Creating a session-level funnel progression table.
- Identifying whether each session reached view, click, add-to-cart, and purchase stages.
- Calculating drop-off stage per session.
- Exporting funnel progression outputs for deeper EDA or validation against the Power BI model.

> Note: Add the Python notebook to the repository when the Python analysis is completed.

### 6. Recommendation

The final page provides an action framework based on where users leave the funnel.

The recommendations focus on:

- Prioritising high-converting traffic sources.
- Retargeting users with high engagement but no purchase.
- Reviewing checkout friction for users who drop after cart.
- Improving product and landing page content for earlier-stage drop-off.
- Using source-level heatmaps to prioritise the traffic channels that require action.

---

## Data Model

The Power BI model uses a simplified star schema with one main fact table and supporting dimensions.

### Fact Table

#### `fact_session_funnel`

Grain: **one row per session**

This table summarises session-level funnel behaviour, including:

- Session information
- User key
- Session date
- Device key
- Referrer source key
- Funnel stage flags
- Interaction counts
- Purchase counts
- Session revenue
- Funnel stage
- Drop-off stage

### Dimension Tables

#### `dim_users`

Contains customer profile attributes:

- `user_id`
- `age`
- `age_group`
- `gender`
- `country`
- `city`
- `signup_date`
- `income_level`
- `preferred_category`
- `loyalty_tier`

#### `dim_device`

Contains device type information:

- `device_id`
- `device_type`

#### `dim_referrer_source`

Contains traffic source information:

- `referrer_source_id`
- `referrer_source`
- `Referrer Source Label`

#### `Dim_Date`

Created in Power BI to support Australian date formatting and time-based analysis.

---

## Model Relationships

The model follows a one-to-many relationship structure:

```text
dim_users[user_id] 1 → * fact_session_funnel[user_id]

dim_device[device_id] 1 → * fact_session_funnel[device_id]

dim_referrer_source[referrer_source_id] 1 → * fact_session_funnel[referrer_source_id]

Dim_Date[Date] 1 → * fact_session_funnel[session_date]
```

Recommended relationship settings:

```text
Cardinality: One-to-many
Cross filter direction: Single
Active: Yes
```

---

## Model Schema

Add the schema screenshot to your GitHub repository, for example:

```text
images/model_schema.png
```

Then reference it in this README:

```md
![Power BI Model Schema](images/model_schema.png)
```

---

## SQL Cleaning Details

### 1. Raw Tables

The raw CSV files were imported into SQL Server as flat tables:

```text
dbo.users
dbo.sessions
dbo.interactions
dbo.purchases
dbo.products
dbo.reviews
```

For the dashboard scope, the final model focused on:

```text
users
sessions
interactions
purchases
```

The `products` and `reviews` tables were excluded from the first dashboard version to keep the analysis focused on marketing funnel performance.

### 2. Data Quality Checks

The SQL cleaning process included:

#### Row count checks

Used to confirm that all source tables were imported successfully.

#### Missing value checks

Checked missing values across key fields such as:

- `user_id`
- `session_id`
- `interaction_id`
- `purchase_id`
- `start_time`
- `device_type`
- `referrer_source`
- `interaction_type`
- `quantity`
- `unit_price`
- `total_amount`

#### Duplicate key checks

Checked duplicates for:

- `user_id`
- `session_id`
- `interaction_id`
- `purchase_id`

#### Invalid value checks

Checked for invalid values such as:

- Negative dwell time
- Invalid age
- Quantity less than or equal to zero
- Negative unit price
- Negative total amount

#### Transaction validation

Validated purchase accuracy by comparing:

```text
calculated_amount = quantity × unit_price
```

against the original source field:

```text
total_amount
```

#### Relationship integrity checks

Validated relationships across tables:

- Sessions linked to valid users
- Interactions linked to valid sessions
- Purchases linked to valid users
- Purchases linked to valid sessions
- Purchases linked to valid interactions

### 3. Clean Views

Clean views were created to standardise fields and remove unnecessary columns before creating final reporting tables.

Examples:

```text
vw_clean_users
vw_clean_sessions
vw_clean_interactions
vw_clean_purchases
```

These views standardised text fields, converted date/time columns, filtered invalid records, and prepared session-level data for modelling.

### 4. Final Reporting Tables

The final Power BI reporting tables were created from the clean views:

```text
dim_users
dim_device
dim_referrer_source
fact_session_funnel
```

`Dim_Date` was created in Power BI to allow better control over date formatting and Australian locale settings.

---

## Dashboard Pages

## Page 1: Executive Overview

### Main Question

**How is the overall funnel performing?**

### What this page answers

- How are current traffic and revenue performing?
- What is the current purchase conversion rate?
- Where do users drop off before purchase?
- Which referrer sources generate the strongest conversion?

### Key visuals

- KPI cards
- Customer journey funnel
- Monthly conversion trend
- Sessions by drop-off stage
- Conversion rate by traffic source

---

## Page 2: Channel Performance

### Main Question

**Which traffic sources and devices drive better conversion and revenue quality?**

### What this page answers

- Which traffic sources bring the most sessions?
- Which channels convert best?
- Which sources generate higher revenue per session?
- How does device type affect conversion performance?

### Key visuals

- Sessions by traffic source
- Conversion rate by traffic source
- Revenue per session by traffic source
- Traffic volume vs conversion scatter plot
- Source-device performance matrix or heatmap

---

## Page 3: Customer Segment Analysis

### Main Question

**Which customer segments should the marketing team prioritise for targeting?**

### What this page answers

- Which customer segments generate higher revenue per session?
- Which age groups bring the most sessions and strongest conversion?
- Which loyalty tiers create stronger customer value?
- Which source-device combinations support better conversion?

### Key visuals

- Customer value decomposition tree
- Sessions and conversion rate by age group
- Revenue by loyalty tier
- Source and device conversion heatmap

---

## Page 4: Conversion Opportunities

### Main Question

**Where are the biggest conversion opportunities, and what should the business do next?**

### What this page answers

- Where do users drop off before purchase?
- Which funnel transition is the weakest?
- Which traffic sources are linked to drop-off?
- What actions should the business take next?

### Key visuals

- Funnel transition rates
- Sessions by drop-off stage
- Drop-off heatmap by traffic source
- Insight and action guide

---

## Insight & Action Guide

Use the selected filters to identify the largest drop-off stage, weakest funnel transition, and highest drop-off traffic sources. The recommendations below provide an action framework based on where users leave the funnel.

### 1. Drop after View

Users viewed products or pages but did not continue to click.

Recommended actions:

- Improve landing page relevance based on the selected traffic source.
- Make product value proposition and key benefits clearer above the fold.
- Review page loading speed, product images, and headline clarity.
- Strengthen call-to-action visibility to encourage the next step.

### 2. Drop after Click

Users clicked but did not move to cart.

Recommended actions:

- Review product detail pages, pricing clarity, and offer presentation.
- Improve product descriptions, ratings, trust signals, and comparison information.
- Add stronger recommendations or related products to guide decision-making.
- Test CTA wording, placement, and button visibility.

### 3. Drop after Cart

Users added items to cart but did not complete purchase.

Recommended actions:

- Prioritise cart abandonment recovery through email, remarketing, or reminders.
- Review checkout friction such as delivery fees, payment options, account creation, and form length.
- Improve transparency around shipping cost, delivery time, return policy, and total price.
- Consider limited-time offers or free-shipping thresholds for high-intent users.

### 4. Weak Cart → Purchase Rate

Cart → Purchase is the final and most critical conversion step.

Recommended actions:

- Investigate checkout completion barriers.
- Check whether users abandon after seeing unexpected costs.
- Review payment errors, checkout speed, and mobile checkout experience.
- A/B test simplified checkout flow or guest checkout options.

### 5. Source-level Drop-off

The heatmap shows which traffic sources contribute most to each drop-off stage.

Recommended actions:

- Prioritise sources with high drop-off volume, not only low conversion rate.
- For high Drop after View sources, review landing page and traffic relevance.
- For high Drop after Cart sources, focus on retargeting and checkout optimisation.
- Compare source performance with Revenue per Session before reducing campaign spend.

---

## Example DAX Measures

### Total Sessions

```DAX
Total Sessions =
DISTINCTCOUNT ( fact_session_funnel[session_id] )
```

### Total Revenue

```DAX
Total Revenue =
SUM ( fact_session_funnel[session_revenue] )
```

### Converted Sessions

```DAX
Converted Sessions =
CALCULATE (
    [Total Sessions],
    fact_session_funnel[has_purchase] = TRUE()
)
```

### Purchase Conversion Rate

```DAX
Purchase Conversion Rate =
DIVIDE ( [Converted Sessions], [Total Sessions] )
```

### Revenue per Session

```DAX
Revenue per Session =
DIVIDE ( [Total Revenue], [Total Sessions] )
```

### View to Click Rate

```DAX
View to Click Rate =
DIVIDE ( [Sessions with Click], [Sessions with View] )
```

### Click to Cart Rate

```DAX
Click to Cart Rate =
DIVIDE ( [Sessions with Add to Cart], [Sessions with Click] )
```

### Cart to Purchase Rate

```DAX
Cart to Purchase Rate =
DIVIDE ( [Converted Sessions], [Sessions with Add to Cart] )
```

---

## Repository Structure

Recommended GitHub structure:

```text
ecommerce-marketing-funnel-analytics/
│
├── README.md
├── dashboard/
│   └── ecommerce_marketing_funnel.pbix
│
├── sql/
│   └── Data_Cleaning.sql
│
├── python/
│   └── funnel_analysis.ipynb
│
├── images/
│   ├── model_schema.png
│   ├── executive_overview.png
│   ├── channel_performance.png
│   ├── customer_segments.png
│   └── conversion_opportunities.png
│
└── data/
    └── README_data_source.md
```

> Note: If the dataset is large or restricted, do not upload raw data directly. Instead, provide a data source link or a short data description.

---

## Key Takeaways

- Built a focused end-to-end marketing analytics project using SQL Server and Power BI.
- Transformed raw e-commerce data into a clean session-level funnel model.
- Created a Power BI-ready star schema with one main fact table.
- Defined a marketing metric layer covering traffic, conversion, revenue, and drop-off behaviour.
- Built a multi-page dashboard to analyse executive funnel performance, channel effectiveness, customer segments, and conversion opportunities.
- Converted dashboard findings into an action guide for marketing and conversion optimisation.

---

## Project Summary for Portfolio

Built an end-to-end e-commerce marketing funnel analytics project using SQL Server and Power BI to analyse customer journey performance, traffic source effectiveness, device behaviour, customer segment conversion, and funnel drop-off opportunities. The project includes SQL-based data cleaning, a Power BI-ready star schema, DAX metric layer, interactive dashboard pages, and business recommendations for improving conversion performance.
