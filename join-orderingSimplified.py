import os,sys
# from termcolor import colored
from operator import itemgetter
from collections import OrderedDict

# Number of Total Tuples 
TT_dict = {"aka_name":901343,"aka_title":361472,"cast_info":36244344,"char_name":3140339,"company_name":234997, \
	"company_type":4,"comp_cast_type":4,"complete_cast":135086,"info_type":113,"keyword":134170,"kind_type":7, \
	"link_type":18,"movie_companies":2609129,"movie_info_idx":1380035,"movie_keyword":4523930,"movie_link":29997, \
	"name":4167491,"role_type":12,"title":2528312,"movie_info":14835720,"person_info":2963664}

# Sort a list based on Total number tuples
def TT_sort(_tbls,_AS_mapping,_order):
  tbl_tuples = dict()
  for tbl in _tbls:
    tbl_tuples[tbl] = TT_dict[_AS_mapping[tbl]] 
    
  tbl_tuples_sorted = OrderedDict(sorted(tbl_tuples.items(), key=itemgetter(1) , reverse= _order))
  return list(tbl_tuples_sorted.keys())

def build_join_graph():
  for join_pred in join_predicates:
    left = join_pred.split('=')[0]
    right = join_pred.split('=')[1]
    left_tbl = left.split('.')[0].strip()
    right_tbl = right.split('.')[0].strip()
    
    if left_tbl in FK_FK:
      FK_join_graph[left_tbl].append(right_tbl)

    if right_tbl in FK_FK:
      FK_join_graph[right_tbl].append(left_tbl)

  return join_graph

def update_join_graph(_tbl,_FK_join_graph):
  for key,val in _FK_join_graph.items():
    if _tbl in val:
      val.remove(_tbl)
      _FK_join_graph[key] = val

  return _FK_join_graph

def lonely_tbl(cur_join_cands,all_FK_join_cands):
  tbl_list = " "
  for tbl in cur_join_cands:
    if tbl not in all_FK_join_cands:
      tbl_list += tbl+" "
  if tbl_list.isspace():
    return ""
  else:
    return tbl_list[:-1]

def common_item(a, b):
    a_set = set(a)
    b_set = set(b)
    if (a_set & b_set):
        return True 
    else:
        return False

def plan_validation(plan,complete_join_graph):
  plan_copy = plan
  plan = plan.split(' ')
  subquery_dict = dict()
  subquery = []
  subquery_str = ""
  s = 1
  for tbl in plan:
    if '(' in tbl:
      subquery_str += tbl+" "
      tbl = tbl.replace('(','')
      subquery.append(tbl)
    elif ')' in tbl:
      subquery_str += tbl
      tbl = tbl.replace(')','')
      subquery.append(tbl)
      subquery_dict['S'+str(s)] = subquery.copy()
      plan_copy = plan_copy.replace(subquery_str,'S'+str(s))
      subquery.clear()
      subquery_str = ""
      s += 1
  # print("New PLAN ", plan_copy)
  # print("subquery dict ",subquery_dict)

  visited = []
  plan_copy = plan_copy.replace("  "," ")
  not_visited = plan_copy.strip().split(' ')
  # print("Not visited ",not_visited)
  visited.append(not_visited[0])
  not_visited.remove(visited[0])
  connections = []
  order = visited.copy()
  i = 0
  while (len(not_visited) != 0):
    cur = not_visited[0]
    if 'S' in cur:
      cand1 = subquery_dict[cur][0]
      cand2 = subquery_dict[cur][1]
      connections.extend(complete_join_graph[cand1])
      connections.extend(complete_join_graph[cand2])
    else:
      connections.extend(complete_join_graph[cur])

    if common_item(visited,connections) == True:
      if 'S' in cur:
        visited.append(cand1)
        visited.append(cand2)
        order.append(cur)
      else:
        visited.append(cur)
        order.append(cur)
      not_visited.remove(cur)
      connections.clear()
    else:
      # print("No FK connections found")
      s = i + 1
      while s < len(not_visited):
        connections.clear()
        cand = not_visited[s]
        if 'S' in cand:
          cand1 = subquery_dict[cand][0]
          cand2 = subquery_dict[cand][1]
          connections.extend(complete_join_graph[cand1])
          connections.extend(complete_join_graph[cand2])
        else:
          connections.extend(complete_join_graph[cand])
        if common_item(visited,connections) == True:
          if 'S' in cur:
            visited.append(cand1)
            visited.append(cand2)
            order.append(cand)
          else:
            visited.append(cand)
            order.append(cand)
          not_visited.remove(cand)
          connections.clear()
          break
        else:
          s += 1
  order = ' '.join(order)
  for key,val in subquery_dict.items():
    sub = "("+val[0]+" "+val[1]+")"
    order = order.replace(key,sub)
  return order




PATH = "join-order-benchmark/"
plan_file = open('plans.txt','w')
# files = os.listdir(PATH)
files = ['1a','1b','1c','1d','2a','2b','2c','2d','3a','3b','3c','4a','4b','4c','5a','5b','5c','6a','6b','6c','6d','6e','6f', \
        '7a','7b','7c','8a','8b','8c','8d','9a','9b','9c','9d','10a','10b','10c','11a','11b','11c','11d','12a','12b','12c', \
        '13a','13b','13c','13d','14a','14b','14c','15a','15b','15c','15d','16a','16b','16c','16d','17a','17b','17c','17d', \
        '17e','17f','18a','18b','18c','19a','19b','19c','19d','20a','20b','20c','21a','21b','21c','22a','22b','22c','22d', \
        '23a','23b','23c','24a','24b','25a','25b','25c','26a','26b','26c','27a','27b','27c','28a','28b','28c','29a','29b', \
        '29c','30a','30b','30c','31a','31b','31c','32a','32b','33a','33b','33c']
for file in files:
  # Reading the query
  query = open(PATH+file+'.sql').read()
  # print(query)
  # print(query)

  # Parse the query and retrive join predicates
  join_predicates = []
  AS_mapping = dict()

  FROM = query.split("WHERE")[0].split("FROM")[1]
  FROM = FROM.split(',')
  for tbl_as in FROM:
    tbl = tbl_as.split("AS")[0].strip()
    as_ = tbl_as.split("AS")[1].strip()
    AS_mapping[as_] = tbl

  where = query.split("WHERE")[1]
  predicates = where.split("AND")
  for predicate in predicates:
    if '=' not in predicate:
      continue
    left = predicate.split('=')[0].strip()
    right = predicate.split('=')[1].strip()
    if '.' in left and '.' in right and 'id' in predicate:
      join_predicates.append(predicate.strip())


  # Get FK-FK joins and join graphs for FK keys
  FK_FK = []
  FK_join_graph = dict()
  complete_join_graph = dict()
  for key in AS_mapping.keys():
    complete_join_graph[key] = []


  for join_pred in join_predicates:
    left = join_pred.split('=')[0]
    right = join_pred.split('=')[1]
    left_tbl = left.split('.')[0].strip()
    right_tbl = right.split('.')[0].strip()
    left_attr = left.split('.')[1].strip()
    right_attr = right.split('.')[1].strip()
    if left_attr != 'id' and right_attr != 'id' :
      FK_FK.append(left_tbl)
      FK_FK.append(right_tbl)
      complete_join_graph[left_tbl].append(right_tbl)
      complete_join_graph[right_tbl].append(left_tbl)
    else:
      complete_join_graph[left_tbl].append(right_tbl)
      complete_join_graph[right_tbl].append(left_tbl)


  # If no FK-FK join exists
  all_FK_join_cands = []
  if not FK_FK:
    join_graph = dict()
    visited_tbl = dict()
    tables = AS_mapping.keys()
    tables = TT_sort(tables,AS_mapping,True)
    for tbl in tables:
      join_graph[tbl] = []
      visited_tbl[tbl] = False

    for join_pred in join_predicates:
      left = join_pred.split('=')[0]
      right = join_pred.split('=')[1]
      left_tbl = left.split('.')[0].strip()
      right_tbl = right.split('.')[0].strip()
      join_graph[left_tbl].append(right_tbl)
      join_graph[right_tbl].append(left_tbl)

    join_order = [tables[0]]
    join_candidates_2 = []
    cur_candidate = join_order[0]
    while(cur_candidate != None):
      visited_tbl[cur_candidate] = True
      for tbl in join_graph[cur_candidate]:
        if visited_tbl[tbl] == False:
          join_candidates_2.append(tbl)
      join_candidates_2 = TT_sort(join_candidates_2,AS_mapping,False)
      if not join_candidates_2:
        cur_candidate = None
        break
      cur_candidate = join_candidates_2[0]
      join_candidates_2.remove(cur_candidate)
      join_order.append(cur_candidate)

    str1 = file+" : "+' '.join(join_order)
    print(str1)
    plan_file.write(str1+'\n')

  else:
    FK_FK = list(set(FK_FK))
    for fk in FK_FK:
      FK_join_graph[fk] = []

    for join_pred in join_predicates:
      left = join_pred.split('=')[0]
      right = join_pred.split('=')[1]
      left_tbl = left.split('.')[0].strip()
      right_tbl = right.split('.')[0].strip()
      
      if left_tbl in FK_FK:
        FK_join_graph[left_tbl].append(right_tbl)

      if right_tbl in FK_FK:
        FK_join_graph[right_tbl].append(left_tbl)


    # Sort FK-FK based on total tuples order desc.
    FK_FK = TT_sort(FK_FK,AS_mapping,False)
    for key,val in FK_join_graph.items():
      all_FK_join_cands.extend(val)

    # print(FK_join_graph)
    # print(set(all_FK_join_cands))

    for key,val in FK_join_graph.items():
      FK_join_graph[key] = TT_sort(val,AS_mapping,False)
    # print(FK_join_graph)
    #  Enumerate over FK-FK :
    #   a) sort FK key graph on total tuples order asce. {ci : {t,n,mk},mk:{k,t,ci}}
    #   b) Enumerate over FK key graph:

    join_order = str(FK_FK[0])
    visited = dict()
    subqry_flag = False
    for key,val in AS_mapping.items():
      visited[key] = False

    # Removing FK join candidates
    for _tbl in FK_FK:
      FK_join_graph = update_join_graph(_tbl,FK_join_graph)

    # Enumerate over FK key graph:
    for FK in FK_FK:
      visited[FK] = True
      join_candidates = FK_join_graph[FK].copy() #TT_sort(FK_join_graph[FK],AS_mapping,False)
      if not join_candidates:
        join_order += str(FK)+" "
        continue

      if FK != FK_FK[0]:
        join_order += " ("+str(FK)
        subqry_flag = True

      i = 0
      for tbl in join_candidates:
        if tbl not in FK_FK and visited[tbl]==False:
          visited[tbl] = True
          FK_join_graph = update_join_graph(tbl,FK_join_graph) 
          if i==0 and subqry_flag==True:
            join_order += " "+str(tbl)+lonely_tbl(complete_join_graph[tbl],all_FK_join_cands)+') '
            subqry_flag = False
          else:
            join_order += " "+str(tbl)+lonely_tbl(complete_join_graph[tbl],all_FK_join_cands)+" "

    join_order = plan_validation(join_order,complete_join_graph)
    join_order = file+" : "+join_order
    plan_file.write(join_order+'\n')
    print(join_order,'green')
plan_file.close()
