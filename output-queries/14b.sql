SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (mi_idx.info > '6.0' AND it2.info = 'rating' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.production_year > 2010 AND (t.title LIKE '%murder%' OR t.title LIKE '%Murder%'  OR t.title LIKE '%Mord%') AND t.id = mi_idx.movie_id ) 
join kind_type AS kt on (kt.kind = 'movie' AND kt.id = t.kind_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword IN ('murder',  'murder-in-title') AND k.id = mk.keyword_id)) S1 on (t.id = S1.mk_movie_id AND S1.mk_movie_id = mi_idx.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it1 on (mi.info IN ('Sweden',  'Norway', 'Germany',   'Denmark',   'Swedish',   'Denish', 'Norwegian',   'German',  'USA',   'American') AND it1.info = 'countries' AND it1.id = mi.info_type_id)) S2 on (t.id = S2.mi_movie_id AND S2.mi_movie_id = mi_idx.movie_id AND S1.mk_movie_id = S2.mi_movie_id );