SELECT COUNT(*)
FROM complete_cast AS cc
join comp_cast_type AS cct1 on (cct1.kind = 'cast' AND cct1.id = cc.subject_id ) 
join comp_cast_type AS cct2 on (cct2.kind LIKE '%complete%' AND cct2.id = cc.status_id ) 
join title AS t on (t.production_year > 2000 AND t.id = cc.movie_id ) 
join kind_type AS kt on (kt.kind = 'movie' AND kt.id = t.kind_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword IN ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser') AND k.id = mk.keyword_id)) S1 on (t.id = S1.mk_movie_id AND S1.mk_movie_id = cc.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id,ci.person_id AS ci_person_id FROM cast_info as ci join char_name as chn on (chn.name IS NOT NULL AND (chn.name LIKE '%man%' OR chn.name LIKE '%Man%') AND chn.id = ci.person_role_id)) S2 on (t.id = S2.ci_movie_id AND S2.ci_movie_id = cc.movie_id AND S1.mk_movie_id = S2.ci_movie_id ) 
join name AS n on (n.id = S2.ci_person_id );