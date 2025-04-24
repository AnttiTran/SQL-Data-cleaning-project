Nashville Housing Data Cleaning (SQL Project)

This project focuses on cleaning and preparing housing sales data from Nashville for future analysis and visualization. The raw dataset included inconsistencies, missing values, duplicate records, and unstructured data fields. All cleaning was done using SQL in Microsoft SQL Server.

---

Steps Performed
1. **Standardized the Date Format**
- Converted `SaleDate` into a consistent `DATE` format
- Created a new column `SaleDateConverted` with the cleaned format (although this was a bit redundant in the final version)

---

2. **Populated Missing Property Addresses**
- Some property address values were missing but could be filled in by matching on `ParcelID`
- Used a self-join to copy addresses from duplicate parcel records with non-null values

---

3. **Split Full Addresses into Components**
- Broke `PropertyAddress` into two new fields: `PropertySplitAddress` and `PropertySplitCity`
- Used string functions to extract street address and city

---

4. **Split Owner Address into Components**
- `OwnerAddress` was split into:
  - `OwnerSplitAddress`
  - `OwnerSplitCity`
  - `OwnerSplitState`
- Used `PARSENAME` to extract values by replacing commas with underscores

---

5. **Standardized Categorical Values**
- Cleaned the `SoldAsVacant` column:
  - Replaced `'Y'` with `'Yes'`
  - Replaced `'N'` with `'No'`

---

6. **Removed Duplicate Records**
- Used a `ROW_NUMBER()` window function to identify duplicate rows based on multiple key columns
- Filtered for rows where `row_num > 1` (potential duplicates)

---

7. **Dropped Unnecessary Columns**
- Removed unused or redundant columns:
  - `OwnerAddress`
  - `TaxDistrict`
  - `PropertyAddress`
  - `SaleDate` (after conversion)

---

Tools Used
- Microsoft SQL Server
- T-SQL (Transact-SQL)

---

Final Output
The cleaned dataset is now ready for:
- Data visualization (e.g., Power BI, Tableau)
- Trend analysis
- Building dashboards
- Further enrichment (e.g., joining with census or neighborhood data)
