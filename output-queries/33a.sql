SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link IN ('sequel',  'follows',  'followed by') AND lt.id = ml.link_type_id ) 
join title AS t1 on (t1.id = ml.movie_id ) 
join kind_type AS kt1 on (kt1.kind IN ('tv series') AND kt1.id = t1.kind_id ) 
join title AS t2 on (t2.production_year BETWEEN 2005 AND 2008 AND t2.id = ml.linked_movie_id ) 
join kind_type AS kt2 on (kt2.kind IN ('tv series') AND kt2.id = t2.kind_id ) 
JOIN (SELECT mi_idx1.movie_id AS mi_idx1_movie_id FROM movie_info_idx AS mi_idx1
 join info_type AS it1 on (it1.info = 'rating' AND it1.id = mi_idx1.info_type_id ))S1 on (t1.id = S1.mi_idx1_movie_id AND ml.movie_id = S1.mi_idx1_movie_id ) 
JOIN (SELECT mi_idx2.movie_id AS mi_idx2_movie_id FROM movie_info_idx AS mi_idx2
 join info_type AS it2 on (mi_idx2.info < '3.0' AND it2.info = 'rating' AND it2.id = mi_idx2.info_type_id ))S2 on (t2.id = S2.mi_idx2_movie_id AND ml.linked_movie_id = S2.mi_idx2_movie_id ) 
JOIN (SELECT mc2.movie_id AS mc2_movie_id FROM movie_companies AS mc2
 join company_name AS cn2 on (cn2.id = mc2.company_id ))S3 on (t2.id = S3.mc2_movie_id AND ml.linked_movie_id = S3.mc2_movie_id AND S2.mi_idx2_movie_id = S3.mc2_movie_id ) 
JOIN (SELECT mc1.movie_id AS mc1_movie_id FROM movie_companies AS mc1
 join company_name AS cn1 on (cn1.country_code = '[us]' AND cn1.id = mc1.company_id ))S4 on (t1.id = S4.mc1_movie_id AND ml.movie_id = S4.mc1_movie_id AND S1.mi_idx1_movie_id = S4.mc1_movie_id );