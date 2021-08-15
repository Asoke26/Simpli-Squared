# Join Ordering Simplified

This repository contains code and instructions used in **Join Ordering Simplified paper**.

## Files

**1. join-orderingSimplified.py :**  This file has the code of join ordering simplified algorithm. <br />
     - Input : JOB(Join Ordering Benchmark) queries. <br />
     - Output : plans in ```plans.txt``` file. <br />

**2. sql-generator.py :** This code transforms output plans from last phase into sql. <br />
     - Input : JOB(Join Ordering Benchmark) queries and ```plans.txt``` file. <br />
     - Output : SQL plans which respects join orders. <br />
     
## How to Run ?

**Prerequisites -** 
Install below packages from python <br />
```collections, operator, termcolor```

**Step 1 :** Run join ordering simplified alorithm to obtain the plans. <br />
``` python3 join-orderingSimplified.py ```  <br />
**Step 2 :** Run SQL generator to translate the plans into SQL queries. <br />
``` python3 sql-generator.py ```


