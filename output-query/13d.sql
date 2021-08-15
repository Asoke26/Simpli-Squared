SELECT COUNT(*)
FROM movie_info_idx AS miidx
join info_type AS it on (it.info ='rating' AND it.id = miidx.info_type_id ) 
join title AS t on (miidx.movie_id = t.id ) 
join kind_type AS kt on (kt.kind ='movie' AND kt.id = t.kind_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id,mc.company_id AS mc_company_id FROM movie_companies as mc join company_type as ct on (ct.kind ='production companies' AND ct.id = mc.company_type_id)) S1 on (S1.mc_movie_id = t.id AND miidx.movie_id = S1.mc_movie_id ) 
join company_name AS cn on (cn.country_code ='[us]' AND cn.id = S1.mc_company_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it2 on (it2.info ='release dates' AND it2.id = mi.info_type_id)) S2 on (S2.mi_movie_id = t.id AND S2.mi_movie_id = miidx.movie_id AND S2.mi_movie_id = S1.mc_movie_id );