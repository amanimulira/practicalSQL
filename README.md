# Retail Store Database Schema

## Overview
This repository contains a SQL schema for a simple retail store management system. It models key entities such as customers, employees, transactions, items, promotions, and transaction details. The schema includes tables for data storage and views for common queries and reports.

The database is designed for tracking sales, inventory, promotions, and basic analytics (e.g., transaction counts, stock levels, and costs). It assumes a relational database management system (RDBMS) like MySQL or PostgreSQL, due to features like `MONTH()` function and `NATURAL JOIN`.

**Key Features:**
- Entity-Relationship model with primary and foreign keys for data integrity.
- Views for pre-computed reports, such as employee transaction counts and inventory tracking.
- Supports basic promotions (e.g., "buy X get Y free") tied to item types.

## Prerequisites
- An RDBMS supporting standard SQL (e.g., MySQL 5.7+, PostgreSQL 10+).
- Basic SQL knowledge for execution and data insertion.

## Schema Structure

### Tables
The schema defines six tables:

1. **Customers**  
   Stores customer profiles.  
   - `birth_day`: DATE  
   - `first_name`: VARCHAR(20)  
   - `last_name`: VARCHAR(20)  
   - `c_id`: INT (PRIMARY KEY)  

2. **Employees**  
   Stores employee profiles (similar to Customers).  
   - `birth_day`: DATE  
   - `first_name`: VARCHAR(20)  
   - `last_name`: VARCHAR(20)  
   - `e_id`: INT (PRIMARY KEY)  

3. **Transactions**  
   Records sales transactions, linking employees and customers.  
   - `e_id`: INT (FOREIGN KEY REFERENCES Employees(e_id))  
   - `c_id`: INT (FOREIGN KEY REFERENCES Customers(c_id))  
   - `date`: DATE  
   - `t_id`: INT (PRIMARY KEY)  

4. **Promotion**  
   Defines promotional offers by item type (e.g., buy X get Y free).  
   - `number_to_buy`: INT  
   - `how_many_are_free`: INT  
   - `type`: INT (PRIMARY KEY)  

5. **Items**  
   Manages inventory items with pricing and stock.  
   - `price_for_each`: INT  
   - `type`: INT  
   - `amount_in_stock`: INT  
   - `name`: VARCHAR(20) (PRIMARY KEY)  

6. **ItemsInTransactions**  
   Links items to transactions (line items; supports multiple items per transaction).  
   - `name`: VARCHAR(20) (FOREIGN KEY REFERENCES Items(name))  
   - `t_id`: INT (FOREIGN KEY REFERENCES Transactions(t_id))  
   - `iit_id`: INT (PRIMARY KEY)  

### Views
Six views are provided for querying derived data:

1. **LouisTransactions**  
   Counts transactions handled by employee "Louis Davies" in September (any year).  
   - Output: `number_of_transactions` (INT)  

2. **PeopleInShop**  
   Lists people (employees and customers) involved in transactions on '2022-9-28', ordered by birth_day.  
   - Output: `birth_day` (DATE), `first_name` (VARCHAR), `last_name` (VARCHAR)  

3. **ItemsLeft1**  
   Calculates remaining stock for item types 1 and 2 (amount_in_stock minus transaction counts).  
   - Output: `name` (VARCHAR), `type` (INT), `amount_left` (INT)  
   - Ordered by type, name.  

4. **ItemsLeft2**  
   Similar to ItemsLeft1, but for types 3 and 4, using LEFT JOIN to include unsold items.  
   - Output: `name` (VARCHAR), `type` (INT), `amount_left` (INT)  
   - Ordered by type, name.  

5. **IITRanking**  
   Ranks line items by transaction ID, type, price, and iit_id (descending). Includes a count-based rank.  
   - Output: `iit_id` (INT), `t_id` (INT), `type` (INT), `price` (INT), `rnk` (INT)  
   - Note: Potential issue with cross join; may produce inflated results.  

6. **TransactionCost**  
   Computes transaction cost as sum of distinct item prices, filtered by promotion types.  
   - Output: `t_id` (INT), `cost` (INT)  
   - Note: Does not fully apply promotion logic (e.g., discounts); sums unique prices only.  

## Installation and Usage
1. **Create the Database**:  
   Run the SQL script in your RDBMS:  
   ```sql
   -- Paste the full CREATE TABLE and CREATE VIEW statements here.
   ```

2. **Insert Sample Data**:  
   Example:  
   ```sql
   INSERT INTO Customers (birth_day, first_name, last_name, c_id) VALUES ('1990-01-01', 'John', 'Doe', 1);
   -- Add more inserts for other tables.
   ```

3. **Query Examples**:  
   - Get Louis's September transactions: `SELECT * FROM LouisTransactions;`  
   - Check inventory for type 1/2: `SELECT * FROM ItemsLeft1;`  
   - Calculate costs: `SELECT * FROM TransactionCost;`

## Notes and Limitations
- **Quantity Tracking**: ItemsInTransactions lacks an explicit `quantity` column; assumes one unit per entry. For multiples, insert duplicate rows or add a quantity field.
- **Promotion Application**: The Promotion table exists but isn't fully utilized in views (e.g., TransactionCost doesn't compute discounts).
- **Potential Errors**: 
  - Redundant conditions in ItemsLeft1 (e.g., `type = 1 AND type = 1`).
  - Cross joins in IITRanking and TransactionCost may cause duplication; consider adding JOIN conditions (e.g., ON Items.name = ItemsInTransactions.name).
  - Date formats and functions (e.g., `MONTH()`) may vary by RDBMS; test compatibility.
  - No triggers or procedures for automatic stock updates.
- **Extensions**: Add columns like `quantity` in ItemsInTransactions, or views for full promotion discounts.
- **Testing**: Recommended to use a tool like SQLite for quick prototyping, but note dialect differences (e.g., SQLite lacks `MONTH()` natively).

## Contributing
Feel free to fork and submit pull requests for improvements, such as fixing view queries or adding sample data.

## License
This schema is provided under the MIT License. See LICENSE file for details (if applicable).

Last updated: August 22, 2025
