SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link LIKE '%follow%' AND lt.id = ml.link_type_id ) 
join title AS t on (t.production_year BETWEEN 2000 AND 2010 AND ml.movie_id = t.id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id,mc.company_id AS mc_company_id FROM movie_companies as mc join company_type as ct on (mc.note IS NULL AND ct.kind ='production companies' AND mc.company_type_id = ct.id)) S1 on (t.id = S1.mc_movie_id AND ml.movie_id = S1.mc_movie_id ) 
join company_name AS cn on (cn.country_code !='[pl]' AND (cn.name LIKE '%Film%'   OR cn.name LIKE '%Warner%') AND S1.mc_company_id = cn.id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword ='sequel' AND mk.keyword_id = k.id)) S2 on (t.id = S2.mk_movie_id AND ml.movie_id = S2.mk_movie_id AND S2.mk_movie_id = S1.mc_movie_id ) 
join movie_info AS mi on (mi.info IN ('Germany',  'German') AND mi.movie_id = t.id AND ml.movie_id = mi.movie_id AND S1.mc_movie_id = mi.movie_id AND S2.mk_movie_id = mi.movie_id );