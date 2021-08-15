SELECT COUNT(*)
FROM movie_companies AS mc
join company_type AS ct on (mc.note LIKE '%(VHS)%' AND mc.note LIKE '%(USA)%' AND mc.note LIKE '%(1994)%' AND ct.kind = 'production companies' AND ct.id = mc.company_type_id ) 
join title AS t on (t.production_year > 2010 AND t.id = mc.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it on (mi.info IN ('USA','America') AND it.id = mi.info_type_id)) S1 on (t.id = S1.mi_movie_id AND mc.movie_id = S1.mi_movie_id );