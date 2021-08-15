import sys,os


# Retrive plans - OUTPUT - plan_dict
PLAN_PATH = "plans.txt"
plans = open(PLAN_PATH,'r').readlines()
plan_dict = dict()

for plan in plans:
	if not plan.strip():
		continue
	key = plan.split(':')[0].strip()
	val = plan.split(':')[1].strip()
	plan_dict[key] = val

# for key,val in plan_dict.items():
# 	print(key,val)

# Parse Queries for SELECT and JOIN CONDITIONS - OUTPUT - SELECT_MAPPING, JOIN_MAPPING

QUERY_PATH = "join-order-benchmark/"
EXPLICIT_PATH = "output-query/"
files = ['1a','1b','1c','1d','2a','2b','2c','2d','3a','3b','3c','4a','4b','4c','5a','5b','5c','6a','6b','6c','6d','6e','6f', \
        '7a','7b','7c','8a','8b','8c','8d','9a','9b','9c','9d','10a','10b','10c','11a','11b','11c','11d','12a','12b','12c', \
        '13a','13b','13c','13d','14a','14b','14c','15a','15b','15c','15d','16a','16b','16c','16d','17a','17b','17c','17d', \
        '17e','17f','18a','18b','18c','19a','19b','19c','19d','20a','20b','20c','21a','21b','21c','22a','22b','22c','22d', \
        '23a','23b','23c','24a','24b','25a','25b','25c','26a','26b','26c','27a','27b','27c','28a','28b','28c','29a','29b', \
        '29c','30a','30b','30c','31a','31b','31c','32a','32b','33a','33b','33c']
# files = ["7a"]
print(files)
for file in files:
	print("####################### Query ###################################################",file)
	query = open(QUERY_PATH+file+".sql",'r').read()
	# print(query)
	AS_MAPPING = dict()
	FROM = query.split("WHERE")[0].split("FROM")[1]
	FROM = FROM.split(',')

	for tbl_as in FROM:
	    tbl = tbl_as.split("AS")[0].strip()
	    as_ = tbl_as.split("AS")[1].strip()
	    AS_MAPPING[as_] = tbl

	query_lines = open(QUERY_PATH+file+".sql",'r').readlines()
	SELECT_MAPPING = dict()
	JOIN_MAPPING = dict()
	for key in AS_MAPPING.keys():
		SELECT_MAPPING[key] = list()
		JOIN_MAPPING[key] = list()


	whr_flag = False
	for predicate in query_lines:
		if ';' in predicate:
			predicate = predicate.replace(';','')
		if not predicate.strip():
			continue
		if "WHERE" in predicate:
			whr_flag = True
		if whr_flag == True:
			if "WHERE" in predicate:
				predicate = predicate.replace("WHERE","",1).strip()
			elif "AND" in predicate:
				predicate = predicate.replace("AND","",1).strip()

			if '=' not in predicate:
				key1 = predicate.split('.')[0].replace('(','')
				# print("SELECT_MAPPING ",predicate,key1)
				SELECT_MAPPING[key1].append(predicate)
				continue
			left = predicate.split('=')[0].strip()
			right = predicate.split('=')[1].strip()
			if '.' in left and '.' in right and 'id' in predicate:
				left_key = left.split('.')[0]
				right_key = right.split('.')[0]
				JOIN_MAPPING[left_key].append(predicate)
				JOIN_MAPPING[right_key].append(predicate)
			else:
				key2 = predicate.split('.')[0]
				if '(' in key2:
					key2 = key2.replace('(','')
				# print("ELSE ",predicate,key2)
				SELECT_MAPPING[key2].append(predicate)

	# for key,val in SELECT_MAPPING.items():
	# 	print(key,val)
	# print("\n\n")
	# for key,val in JOIN_MAPPING.items():
	# 	print(key,val)


	# Build subquery
	subquery_col_map = dict()
	def update_join_map(_tbl1,_tbl2,sub_no):
		for pred in JOIN_MAPPING[_tbl1]:
			pred_copy = pred
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			if left in subquery_col_map.keys():
				# print("CHECK ! LEFT ",left)
				pred = pred.replace(left,subquery_col_map[left])
				right_tbl = right.split('.')[0]
				JOIN_MAPPING[right_tbl].remove(pred_copy)
				JOIN_MAPPING[right_tbl].append(pred)
			elif right in subquery_col_map.keys():
				# print("CHECK ! RIGHT ",right)
				pred = pred.replace(right,subquery_col_map[right])
				left_tbl = left.split('.')[0]
				JOIN_MAPPING[left_tbl].remove(pred_copy)
				JOIN_MAPPING[left_tbl].append(pred)
			JOIN_MAPPING[sub_no].append(pred)
		del JOIN_MAPPING[_tbl1]

		for pred in JOIN_MAPPING[_tbl2]:
			pred_copy = pred
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			if left in subquery_col_map.keys():
				# print("CHECK ! LEFT ",left)
				pred = pred.replace(left,subquery_col_map[left])
				right_tbl = right.split('.')[0]
				JOIN_MAPPING[right_tbl].remove(pred_copy)
				JOIN_MAPPING[right_tbl].append(pred)
			elif right in subquery_col_map.keys():
				# print("CHECK ! RIGHT ",right)
				pred = pred.replace(right,subquery_col_map[right])
				left_tbl = left.split('.')[0]
				JOIN_MAPPING[left_tbl].remove(pred_copy)
				JOIN_MAPPING[left_tbl].append(pred)
			JOIN_MAPPING[sub_no].append(pred)
		del JOIN_MAPPING[_tbl2]

		# print("\n\n")
		# print("Updated join map # ")
		# for key,val in JOIN_MAPPING.items():
		# 	print(key,val)

	def expose_columns(_tbl1,_tbl2,sub_no):
		columns_visited = []
		select_stmt = ""
		for pred in JOIN_MAPPING[_tbl1]:
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			left_tbl = left.split('.')[0].strip()
			right_tbl = right.split('.')[0].strip()
			left_attr = left.split('.')[1].strip()
			right_attr = right.split('.')[1].strip()
			if left_tbl!=_tbl2 or right_tbl!=_tbl2:
				# print("tbl 1 , _tbl2 , predicate",_tbl1,_tbl2,pred)
				if left_tbl==_tbl1 and left not in columns_visited:
					select_stmt += left+' AS '+left_tbl+'_'+left_attr+','
					columns_visited.append(left)
					subquery_col_map[left] = sub_no+'.'+left_tbl+'_'+left_attr
				elif right_tbl==_tbl1 and right not in columns_visited:
					select_stmt += right+' AS '+right_tbl+'_'+right_attr+','
					columns_visited.append(right)
					subquery_col_map[right] = sub_no+'.'+right_tbl+'_'+right_attr
		# print("SELECT --tbl1",select_stmt)
		for pred in JOIN_MAPPING[_tbl2]:
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			left_tbl = left.split('.')[0].strip()
			right_tbl = right.split('.')[0].strip()
			left_attr = left.split('.')[1].strip()
			right_attr = right.split('.')[1].strip()
			if left_tbl!=_tbl1 or right_tbl!=_tbl1:
				# print("--- tbl 1 , _tbl2 , predicate",_tbl1,_tbl2,pred)
				if left_tbl==_tbl2 and left not in columns_visited:
					select_stmt += left+' AS '+left_tbl+'_'+left_attr+','
					columns_visited.append(left)
					subquery_col_map[left] = sub_no+'.'+left_tbl+'_'+left_attr
				elif right_tbl==_tbl2 and right not in columns_visited:
					select_stmt += right+' AS '+right_tbl+'_'+right_attr+','
					columns_visited.append(right)
					subquery_col_map[right] = sub_no+'.'+right_tbl+'_'+right_attr
		# print("SELECT --tbl2",select_stmt)
		return select_stmt

	def build_subquery(_tbl1,_tbl2,sub_no):
		stmt = ""
		for pred in SELECT_MAPPING[_tbl1]:
			stmt += pred+" AND "
		for pred in SELECT_MAPPING[_tbl2]:
			stmt += pred+" AND "
		for pred in JOIN_MAPPING[_tbl1]:
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			left_tbl = left.split('.')[0].strip()
			right_tbl = right.split('.')[0].strip()
			left_attr = left.split('.')[1].strip()
			right_attr = right.split('.')[1].strip()

			if left_tbl == _tbl2 or right_tbl == _tbl2:
				stmt += pred
				JOIN_MAPPING[_tbl1].remove(pred)
				JOIN_MAPPING[_tbl2].remove(pred)

		columns = expose_columns(_tbl1,_tbl2,sub_no)[:-1]
		subquery_stmt = "(SELECT "+columns+" FROM "+AS_MAPPING[_tbl1]+' as '+_tbl1+' join '+AS_MAPPING[_tbl2]+' as '+_tbl2 +' on ('+stmt+')) '+sub_no
		# print("subquery_stmt # ",subquery_stmt)
		# print("Update Join Map #### ")
		# for key,val in JOIN_MAPPING.items():
		# 	print(key,val)

		# print("Statement -- ",stmt)
		# print("columns -- ",columns)
		# print("subquery -- ",subquery_stmt)
		# print("subquery col Map-- ",subquery_col_map)
		update_join_map(_tbl1,_tbl2,sub_no)
		# for key,val in JOIN_MAPPING.items():
		# 	print(key,val)
		return subquery_stmt



	s = 1
	qry_plan = plan_dict[file.split('.')[0]]
	qry_plan_copy = qry_plan
	
	qry_plan = qry_plan.split(' ')
	subquery_dict = dict()
	subquery = []
	subquery_str = ""
	for tbl in qry_plan:
		# print(tbl)
		if '(' in tbl:
			subquery_str += tbl+" "
			tbl = tbl.replace('(','')
			subquery.append(tbl)
		elif ')' in tbl:
			subquery_str += tbl
			tbl = tbl.replace(')','')
			subquery.append(tbl)
			subquery_dict['S'+str(s)] = subquery.copy()
			qry_plan_copy = qry_plan_copy.replace(subquery_str,'S'+str(s))
			subquery.clear()
			subquery_str = ""
			s += 1
	# print("subquery ",subquery_dict)
	# print("qry_plan_copy ",qry_plan_copy)

	for key,val in subquery_dict.items():
		JOIN_MAPPING[key] = []
		subquery_dict[key] = build_subquery(val[0],val[1],key)

	# print("Updated join map # ")
	# for key,val in JOIN_MAPPING.items():
	# 	print(key,val)
	# print("Updated subquery_dict # ")
	# for key,val in subquery_dict.items():
	# 	print(key,val)

	# Full Query 
	visited = []
	not_visited = qry_plan_copy.strip().split()
	visited.append(not_visited[0])
	not_visited.remove(visited[0])
	sql_stmt = "SELECT COUNT(*)\nFROM "+AS_MAPPING[visited[0]]+" AS "+visited[0]+"\n"
	i = 0
	first_tbl_flag = True
	while(len(not_visited) != 0):
		tbl = not_visited[i]
		if 'S' in tbl:
			sql_stmt += 'JOIN '
			sql_stmt += subquery_dict[tbl] + ' on ('
		else:
			sql_stmt += 'join '
			sql_stmt += AS_MAPPING[tbl]+' AS '+tbl+	 ' on ('
			if first_tbl_flag == True:
				for pred in SELECT_MAPPING[visited[0]]:
					sql_stmt += pred+' AND '
				first_tbl_flag = False	
			for pred in SELECT_MAPPING[tbl]:
				sql_stmt += pred+' AND '

		# print("1 SQL STMT ### ",sql_stmt)
		for pred in JOIN_MAPPING[tbl]:
			pred = pred.strip()
			left = pred.split('=')[0].strip()
			right = pred.split('=')[1].strip()
			left_tbl = left.split('.')[0].strip()
			right_tbl = right.split('.')[0].strip()
			if left_tbl in visited or right_tbl in visited:
				sql_stmt += pred+' AND '
		sql_stmt = sql_stmt[:-4]+') \n'
		visited.append(tbl)
		not_visited.remove(tbl)
		# print("2 SQL STMT ### ",sql_stmt)
		# i += 1
	sql_stmt = sql_stmt.strip()+';'
	# print("visited ",visited)
	# print("not visited ",not_visited)
	# print("sql_stmt --- ")
	# print("Updated join map # ")
	# for key,val in JOIN_MAPPING.items():
	# 	print(key,val)
	# print("Updated subquery_dict # ")
	# for key,val in subquery_dict.items():
	# 	print(key,val)
	print(sql_stmt)
	w_f = open(EXPLICIT_PATH+file+'.sql','w')
	w_f.write(sql_stmt)
	w_f.close()
	print("#######################################################################################################")
