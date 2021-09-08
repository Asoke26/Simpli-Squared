SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (it2.info = 'votes' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.id = mi_idx.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info AS mi
 join info_type AS it1 on (it1.info = 'budget' AND it1.id = mi.info_type_id ))S1 on (t.id = S1.mi_movie_id AND S1.mi_movie_id = mi_idx.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join name AS n on (ci.note IN ('(producer)',  '(executive producer)') AND n.gender = 'm' AND n.name LIKE '%Tim%' AND n.id = ci.person_id ))S2 on (t.id = S2.ci_movie_id AND S2.ci_movie_id = mi_idx.movie_id AND S2.ci_movie_id = S1.mi_movie_id );