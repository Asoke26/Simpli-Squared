SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (mi_idx.info < '8.5' AND it2.info = 'rating' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.production_year > 2005 AND t.id = mi_idx.movie_id ) 
join kind_type AS kt on (kt.kind IN ('movie', 'episode') AND kt.id = t.kind_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (ct.id = mc.company_type_id ) join company_name AS cn on (cn.country_code != '[us]' AND cn.id = mc.company_id ))S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = mi_idx.movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword IN ('murder',  'murder-in-title',  'blood',   'violence') AND k.id = mk.keyword_id ))S2 on (t.id = S2.mk_movie_id AND S2.mk_movie_id = mi_idx.movie_id AND S2.mk_movie_id = S1.mc_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info AS mi
 join info_type AS it1 on (mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND it1.info = 'countries' AND it1.id = mi.info_type_id ))S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = mi_idx.movie_id AND S3.mi_movie_id = S1.mc_movie_id AND S2.mk_movie_id = S3.mi_movie_id );