SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it2 on (it2.info = 'votes' AND it2.id = mi_idx.info_type_id ) 
join title AS t on (t.id = mi_idx.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it1 on (mi.info IN ('Horror', 'Action', 'Sci-Fi', 'Thriller', 'Crime', 'War') AND it1.info = 'genres' AND it1.id = mi.info_type_id)) S1 on (t.id = S1.mi_movie_id AND S1.mi_movie_id = mi_idx.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info as ci join name as n on (ci.note IN ('(writer)', '(head writer)','(written by)', '(story)',  '(story editor)') AND n.gender = 'm' AND n.id = ci.person_id)) S2 on (t.id = S2.ci_movie_id AND S2.ci_movie_id = mi_idx.movie_id AND S2.ci_movie_id = S1.mi_movie_id );