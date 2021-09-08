SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link LIKE '%follows%' AND lt.id = ml.link_type_id ) 
join title AS t on (t.production_year = 1998 AND t.title LIKE '%Money%' AND ml.movie_id = t.id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (mc.note IS NULL AND ct.kind ='production companies' AND mc.company_type_id = ct.id ) join company_name AS cn on (cn.country_code !='[pl]' AND (cn.name LIKE '%Film%'  OR cn.name LIKE '%Warner%') AND mc.company_id = cn.id ))S1 on (t.id = S1.mc_movie_id AND ml.movie_id = S1.mc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword ='sequel' AND mk.keyword_id = k.id ))S2 on (t.id = S2.mk_movie_id AND ml.movie_id = S2.mk_movie_id AND S2.mk_movie_id = S1.mc_movie_id );