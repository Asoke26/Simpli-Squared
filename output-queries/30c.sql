SELECT COUNT(*)
FROM complete_cast AS cc
join comp_cast_type AS cct1 on (cct1.kind = 'cast' AND cct1.id = cc.subject_id ) 
join comp_cast_type AS cct2 on (cct2.kind ='complete+verified' AND cct2.id = cc.status_id ) 
join title AS t on (t.id = cc.movie_id ) 
JOIN (SELECT mi_idx.movie_id AS mi_idx_movie_id FROM movie_info_idx as mi_idx join info_type as it2 on (it2.info = 'votes' AND it2.id = mi_idx.info_type_id)) S1 on (t.id = S1.mi_idx_movie_id AND S1.mi_idx_movie_id = cc.movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword IN ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity',   'hospital') AND k.id = mk.keyword_id)) S2 on (t.id = S2.mk_movie_id AND S2.mk_movie_id = cc.movie_id AND S1.mi_idx_movie_id = S2.mk_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it1 on (mi.info IN ('Horror',    'Action', 'Sci-Fi', 'Thriller', 'Crime',  'War') AND it1.info = 'genres' AND it1.id = mi.info_type_id)) S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = cc.movie_id AND S3.mi_movie_id = S1.mi_idx_movie_id AND S3.mi_movie_id = S2.mk_movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info as ci join name as n on (ci.note IN ('(writer)', '(head writer)',  '(written by)', '(story)',  '(story editor)') AND n.gender = 'm' AND n.id = ci.person_id)) S4 on (t.id = S4.ci_movie_id AND S4.ci_movie_id = cc.movie_id AND S4.ci_movie_id = S1.mi_idx_movie_id AND S4.ci_movie_id = S2.mk_movie_id AND S4.ci_movie_id = S3.mi_movie_id );