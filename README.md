# Netflix Content & Viewership Analysis 🎬


## 📌 Project Overview
This project focuses on analyzing Netflix’s content catalog, viewer engagement, and profitability using SQL.
The objective is to derive business insights related to content strategy, regional dominance, audience behavior,
and cost efficiency.

---

## 🗂️ Dataset Description
The analysis is based on three interconnected tables:

- **netflix** – Content metadata (title, type, genre, country, release year, etc.)
- **netflix_viewership** – Engagement metrics such as total views and average watch time
- **netflix_content_costs** – Production cost, marketing cost, and estimated revenue

---

## 🧩 Entity Relationship Diagram (ERD)
The ER diagram below shows how the tables are related using `show_id` as the primary key.

![Netflix ER Diagram](images/ER diagram.jpeg)

---

## 🔍 Key Analysis Performed
- Movies vs TV Shows distribution
- Top content-producing countries
- Genre-wise content analysis
- Viewer engagement based on watch time
- Profitability analysis using cost vs revenue
- Ranking top-performing titles using window functions

---

## 🛠️ Tools & Technologies
- **MySQL**
- **SQL (JOINs, CTEs, Window Functions)**
- **GitHub for version control**
- **Data Visualization for insights**

---

## 📈 Key Business Insights
- Movies dominate the catalog, but TV Shows drive retention
- A small percentage of titles generate most of the revenue
- Cost efficiency matters more than high production budgets
- India and the USA are major growth markets for Netflix

---

> ⚠️ *This project is for educational and portfolio purposes only and is not affiliated with Netflix.*
