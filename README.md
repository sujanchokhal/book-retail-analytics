# book-retail-analytics
**Retail analytics case study built from scratch using Python, SQL queries, and interactive Power BI visuals.**
**This project demonstrates a complete data pipeline for an online book retail scenario using web-scraped product data. The data is processed and analyzed to simulate a real-world e-commerce analytics workflow. The goal is to extract meaningful business insights from product listings by applying web scraping, SQL-based analysis, and data visualization.**

**##  Tools Used**
- Python (Web Scraping)
- SQL Server (Relational Database)
- Power BI (Interactive Dashboard)
- Excel (output of scrapping)

**Business Insights**
•	Top book categories based on average rating and price
•	Highest-rated books across all categories
•	Inventory (stock availability) overview
•	Correlation between price and rating
•	Distribution of books by rating level
•	Average pricing per category

**Web Scraping**
From the link: https://books.toscrape.com/, scraped all categories and all books on the first page.
For each book, it includes:
  •	Name
  •	Category
  •	Price
  •	Stock Amount
  •	Rating
It has been Put all categories in a CSV file and all book data into a separate CSV file.
The scraping component has been implemented in Python

**SQL Database setup**
Made a local database to store the data with the CSV’s. 
Tables for this database includes primary keys, foreign key(s) and has been normalized.
![image](https://github.com/user-attachments/assets/85d0db1b-b7e6-44f8-902d-f19a63826c95)

**SQL Queries**
From the local database, the following insightful has been included.
1.	the top three categories with the highest average rating and the lower price?
![image](https://github.com/user-attachments/assets/38d2e035-39b8-4e2a-8b12-8b9b293dd8c7)

2.	Which are the top 5 books by rating?
![image](https://github.com/user-attachments/assets/5204b44a-6422-4070-bdc3-f85e8d03548b)

3.	Which categories have the most 5-star rated books?
![image](https://github.com/user-attachments/assets/9476b6f6-3802-4e15-94f1-0110b1bc15c9)

4.	Which books are priced above the overall average price?
![image](https://github.com/user-attachments/assets/79b38eb1-23a1-4c65-b158-131c9a33d7dd)

 **  Visualization**
With the database, connected the to Power Business Intelligence (Power BI) 
visual showing the output of the queries but included a slicer on the side.
![image](https://github.com/user-attachments/assets/a824c504-fb92-4eb9-a75a-e42158f5ca8c)
![image](https://github.com/user-attachments/assets/307ba92b-f902-4b80-9eff-f2935cb3aa00)


**Project Structure**
**File	Description**
scrape_products.py	(Python script to scrape book and category data)
categories.csv	(Cleaned data of all book categories)
products.csv	(Book-level data including price, stock, and rating)
setup_bookstore_database.sql	(SQL schema with tables, keys, and constraints)
analysis_queries.sql	(Business queries for insights)
Book_Retail_Insights.pbix	(Power BI dashboard with interactive filters)




