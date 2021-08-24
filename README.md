# Simpli-Squared

This repository contains code and instructions used in **Simpli-Squared: A Very Simple Yet Unexpectedly Powerful
Join Ordering Algorithm**.

## Files

**1. join-orderingSimplified.py :**  This file has the code for the join ordering simplified algorithm. <br />
     - Input : JOB(Join Ordering Benchmark) queries. <br />
     - Output : plans in ```plans.txt``` file. <br />

**2. sql-generator.py :** This code transforms the output plans from ```plans.txt``` into sql. <br />
     - Input : JOB(Join Ordering Benchmark) queries and ```plans.txt``` file. <br />
     - Output : SQL plans which respects join orders. <br />
     
## How to Run ?
Create a database using 
**Prerequisites -** 
The following softwares are required to run experiments <br />
- ```collections, operator``` (Python Packages)
- PostgreSQL 14.2.

**Step 1 :** Create a database using imdb dataset. Dataset used in paper can be found in http://homepages.cwi.nl/~boncz/job/imdb.tgz .
**Step 2 :** Run join ordering simplified alorithm to obtain the plans. <br />
``` python3 join-orderingSimplified.py ```  <br />
**Step 3 :** Run SQL generator to translate the plans from step 1 into SQL queries. <br />
``` python3 sql-generator.py ```


