SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.id = ml.link_type_id ) 
join title AS t on (t.production_year > 1950 AND ml.movie_id = t.id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (mc.note IS NOT NULL AND ct.kind != 'production companies' AND ct.kind IS NOT NULL AND mc.company_type_id = ct.id ) join company_name AS cn on (cn.country_code !='[pl]' AND mc.company_id = cn.id ))S1 on (t.id = S1.mc_movie_id AND ml.movie_id = S1.mc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword IN ('sequel',  'revenge', 'based-on-novel') AND mk.keyword_id = k.id ))S2 on (t.id = S2.mk_movie_id AND ml.movie_id = S2.mk_movie_id AND S2.mk_movie_id = S1.mc_movie_id );