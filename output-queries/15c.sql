SELECT COUNT(*)
FROM aka_title AS att
join title AS t on (t.production_year > 1990 AND t.id = att.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id,mc.company_id AS mc_company_id FROM movie_companies as mc join company_type as ct on (ct.id = mc.company_type_id)) S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = att.movie_id ) 
join company_name AS cn on (cn.country_code = '[us]' AND cn.id = S1.mc_company_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.id = mk.keyword_id)) S2 on (t.id = S2.mk_movie_id AND S2.mk_movie_id = att.movie_id AND S2.mk_movie_id = S1.mc_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it1 on (mi.note LIKE '%internet%' AND mi.info IS NOT NULL AND (mi.info LIKE 'USA:% 199%'  OR mi.info LIKE 'USA:% 200%') AND it1.info = 'release dates' AND it1.id = mi.info_type_id)) S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = att.movie_id AND S3.mi_movie_id = S1.mc_movie_id AND S2.mk_movie_id = S3.mi_movie_id );