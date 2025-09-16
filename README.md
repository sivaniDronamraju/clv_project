# Customer Lifetime Value (CLV) Data Mart

This project builds a reusable dbt + BigQuery analytics stack focused on predicting and tracking customer lifetime value. It includes cohort analysis, churn detection, product affinity, and trend insights, all powered by SQL transformations and business-ready marts.

## Project Overview
- Tracks and predicts customer lifetime value using transaction data.  
- Implements retention and churn analysis, revenue trends, and product performance insights.  
- Provides reproducible transformations with dbt, version control, and documentation.  
- Publishes ready-to-use marts for reporting and dashboards.  

## Architecture
- Staging: Cleans raw Instacart sources and standardizes customer, order, and product keys.  
- Intermediate: Assembles behavioral metrics (recency, frequency, monetary value, cohorts, affinity).  
- Mart: Publishes CLV fact models and KPI lookups for business reporting and exploration.  

## Setup Instructions
1. Install prerequisites and authenticate with Google Cloud (Python 3.10+, dbt-core>=1.5, dbt-bigquery, Google Cloud SDK, BigQuery dataset; export `GOOGLE_APPLICATION_CREDENTIALS` to your service account key).
2. Create and activate a virtual environment, then install dependencies:
   ```bash
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   pip install dbt-bigquery
   ```
3. Create `%USERPROFILE%\.dbt\profiles.yml` (or `~/.dbt/profiles.yml`) with your BigQuery target:
   ```yaml
   instacart_dbt:
     outputs:
       dev:
         type: bigquery
         method: service-account
         project: your_gcp_project
         dataset: clv_dev
         location: US
         threads: 4
         timeout_seconds: 300
         keyfile: "{{ env_var('GOOGLE_APPLICATION_CREDENTIALS') }}"
     target: dev
   ```
4. Build and document the project:
   ```bash
   dbt deps
   dbt seed
   dbt run
   dbt test
   dbt docs generate
   ```
5. Connect Tableau (or preferred BI) to the mart dataset and schedule refreshes.

## Business Questions Solved
1. Cohort Analysis & Retention: Calculate monthly retention by cohort with pivoted activity.
2. Order Recency & Frequency: Measure average days between orders and maximum gap per customer.
3. Customer Churn & Prediction: Flag top spenders inactive for 90 days with a churn_risk indicator.
4. Product Affinity & Recommendation: Surface top five product pairings from shared order baskets.
5. Seasonal Trend Analysis: Compare monthly AOV splits for returning versus first-time customers.
6. "Golden Basket" Analysis: Identify multi-department loyalists with 90th percentile AOV.
7. Geographic & Customer Segmentation: Correlate regional CLV with preferred ordering times.
8. Loyalty Program Impact: Track time to more than ten orders and the subsequent spend uplift.
9. Product Category Performance: Rank categories by margin and estimate return rates.
10. Customer Behavioral Shift: Detect over 20% declines in basket size between early and recent orders.

## Deliverables
- Production-ready CLV mart tables with dimensional context for downstream analytics.
- Advanced SQL templates answering the ten business questions for reuse in notebooks or BI.
- Tableau dashboard concept with retention, churn, and profitability KPIs tailored for stakeholders.

## Repository Structure
```text
clv_project/
|-- data/
|-- instacart_dbt/
|   |-- dbt_project.yml
|   |-- models/
|   |   |-- staging/
|   |   |-- intermediate/
|   |   `-- marts/
|   |-- seeds/
|   `-- target/
|-- logs/
|-- requirements.txt
`-- README.md
```
Intermediate and mart directories are populated as CLV transformations are promoted.
## Future Improvements
- Add incremental intermediate models for churn scoring and region-aware CLV projections.
- Parameterize cohort windows and churn thresholds for automated scenario testing.
- Integrate automated data quality monitors (freshness, volume) into dbt tests and docs.
- Deploy CI/CD pipelines and schedule mart refreshes via dbt Cloud or Cloud Composer.

