# Simpli-Squared

This repository contains code and instructions used in **Simpli-Squared: A Very Simple Yet Unexpectedly Powerful
Join Ordering Algorithm**.

## Files

**1. join-orderingSimplified.py :**  This file has the code for the join ordering simplified algorithm. <br />
     - Input : JOB(Join Ordering Benchmark) queries. <br />
     - Output : plans in ```plans.txt``` file. Sample plan file can be found here _https://github.com/Asoke26/Simpli-Squared/blob/main/plans.txt_ <br />

**2. sql-generator.py :** This code transforms the output plans from ```plans.txt``` into sql. <br />
     - Input : JOB(Join Ordering Benchmark) queries and ```plans.txt``` file. <br />
     - Output : Rewritten SQL query in explicit representation. <br />


**Prerequisites -** 
- python 3.X.
- ```collections, operator``` (Python Packages)
- PostgreSQL 14.2.


## How to Run ?
**Step 1 :** Create a database using imdb dataset. Step-by-step instructions can be found here(_https://github.com/gregrahn/join-order-benchmark_). Dataset used in paper can be found in _http://homepages.cwi.nl/~boncz/job/imdb.tgz_ . <br />
**Step 2 :** Run join ordering simplified alorithm to obtain the plans. <br />
``` python3 join-orderingSimplified.py ```  <br />
**Step 3 :** Run SQL generator to translate the plans from step 1 into SQL queries. <br />
``` python3 sql-generator.py ``` <br />
The reported result in paper [figure 3] are obtained by running these queries in PostgreSQL database. 



## Tuning PostgreSQL
We change below parameters in PostgreSQL for our experiemnts. They can be found ```/usr/local/pgsql/data/postgresql.conf``` (default location unless set otherwise during installation)

```
shared_buffers = 128 GB
work_mem = 128 GB
effective_cache_size = 128 GB
geqo_threshold = 18
cpu_tuple_cost = 0.01,0.1,1
force_parallel_mode = on
from_collapse_limit = 1 [To prevent sub-query merging]
join_collapse_limit = 1 [To prevent reordering join order]
```

System requires a restart to re-initialize these variables.

Note :
In experiemnts, we use imdb schema with referential integrity which can be found here. Data should be inserted following dependency matric.   
https://github.com/Asoke26/Simpli-Squared/blob/main/join-order-benchmark/schema-with-referential-integrity.sql
