SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it on (mi_idx.info > '5.0' AND it.info ='rating' AND it.id = mi_idx.info_type_id ) 
join title AS t on (t.production_year > 2005 AND t.id = mi_idx.movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword LIKE '%sequel%' AND k.id = mk.keyword_id ))S1 on (t.id = S1.mk_movie_id AND S1.mk_movie_id = mi_idx.movie_id );