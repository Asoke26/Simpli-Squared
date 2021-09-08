SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (mi_idx.info > '8.0' AND it2.info = 'rating' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.production_year BETWEEN 2008 AND 2014 AND t.id = mi_idx.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info AS mi
 join info_type AS it1 on (mi.info IN ('Horror',  'Thriller') AND mi.note IS NULL AND it1.info = 'genres' AND it1.id = mi.info_type_id ))S1 on (t.id = S1.mi_movie_id AND S1.mi_movie_id = mi_idx.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join name AS n on (ci.note IN ('(writer)',    '(head writer)',   '(written by)',  '(story)',  '(story editor)') AND n.gender IS NOT NULL AND n.gender = 'f' AND n.id = ci.person_id ))S2 on (t.id = S2.ci_movie_id AND S2.ci_movie_id = mi_idx.movie_id AND S2.ci_movie_id = S1.mi_movie_id );