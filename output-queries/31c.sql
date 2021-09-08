SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (it2.info = 'votes' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.id = mi_idx.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_name AS cn on (cn.name LIKE 'Lionsgate%' AND cn.id = mc.company_id ))S1 on (t.id = S1.mc_movie_id AND mi_idx.movie_id = S1.mc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword IN ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND k.id = mk.keyword_id ))S2 on (t.id = S2.mk_movie_id AND mi_idx.movie_id = S2.mk_movie_id AND S2.mk_movie_id = S1.mc_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info AS mi
 join info_type AS it1 on (mi.info IN ('Horror', 'Action', 'Sci-Fi',  'Thriller',  'Crime', 'War') AND it1.info = 'genres' AND it1.id = mi.info_type_id ))S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = mi_idx.movie_id AND S3.mi_movie_id = S1.mc_movie_id AND S3.mi_movie_id = S2.mk_movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join name AS n on (ci.note IN ('(writer)', '(head writer)', '(written by)',  '(story)',  '(story editor)') AND n.id = ci.person_id ))S4 on (t.id = S4.ci_movie_id AND S4.ci_movie_id = mi_idx.movie_id AND S4.ci_movie_id = S1.mc_movie_id AND S4.ci_movie_id = S2.mk_movie_id AND S4.ci_movie_id = S3.mi_movie_id );