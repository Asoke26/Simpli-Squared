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

**Prerequisites -** 
The following python packages are required <br />
```collections, operator```

**Step 1 :** Run join ordering simplified alorithm to obtain the plans. <br />
``` python3 join-orderingSimplified.py ```  <br />
**Step 2 :** Run SQL generator to translate the plans from step 1 into SQL queries. <br />
``` python3 sql-generator.py ```


