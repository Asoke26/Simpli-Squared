SELECT COUNT(*)
FROM complete_cast AS cc
join comp_cast_type AS cct1 on (cct1.kind = 'cast' AND cct1.id = cc.subject_id ) 
join comp_cast_type AS cct2 on (cct2.kind LIKE '%complete%' AND cct2.id = cc.status_id ) 
join title AS t on (t.production_year > 2005 AND t.id = cc.movie_id ) 
join kind_type AS kt on (kt.kind = 'movie' AND kt.id = t.kind_id ) 
JOIN (SELECT mi_idx.movie_id AS mi_idx_movie_id FROM movie_info_idx AS mi_idx
 join info_type AS it2 on (mi_idx.info > '8.0' AND it2.info = 'rating' AND it2.id = mi_idx.info_type_id ))S1 on (t.id = S1.mi_idx_movie_id AND cc.movie_id = S1.mi_idx_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword IN ('superhero', 'marvel-comics', 'based-on-comic', 'fight') AND k.id = mk.keyword_id ))S2 on (t.id = S2.mk_movie_id AND S2.mk_movie_id = cc.movie_id AND S2.mk_movie_id = S1.mi_idx_movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join char_name AS chn on (chn.name IS NOT NULL AND (chn.name LIKE '%man%' OR chn.name LIKE '%Man%') AND chn.id = ci.person_role_id ) join name AS n on (n.id = ci.person_id ))S3 on (t.id = S3.ci_movie_id AND S3.ci_movie_id = cc.movie_id AND S3.ci_movie_id = S1.mi_idx_movie_id AND S2.mk_movie_id = S3.ci_movie_id );