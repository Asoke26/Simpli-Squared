SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (it2.info ='bottom 10 rank' AND mi_idx.info_type_id = it2.id ) 
join title AS t on (t.production_year >2000 AND (t.title LIKE 'Birdemic%'  OR t.title LIKE '%Movie%') AND t.id = mi_idx.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id,mc.company_id AS mc_company_id FROM movie_companies as mc join company_type as ct on (ct.kind IS NOT NULL AND (ct.kind ='production companies'  OR ct.kind = 'distributors') AND ct.id = mc.company_type_id)) S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = mi_idx.movie_id ) 
join company_name AS cn on (cn.country_code ='[us]' AND cn.id = S1.mc_company_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it1 on (it1.info ='budget' AND mi.info_type_id = it1.id)) S2 on (t.id = S2.mi_movie_id AND S2.mi_movie_id = mi_idx.movie_id AND S1.mc_movie_id = S2.mi_movie_id );