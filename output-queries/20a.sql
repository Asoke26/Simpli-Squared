SELECT COUNT(*)
FROM complete_cast AS cc
join comp_cast_type AS cct1 on (cct1.kind = 'cast' AND cct1.id = cc.subject_id ) 
join comp_cast_type AS cct2 on (cct2.kind LIKE '%complete%' AND cct2.id = cc.status_id ) 
join title AS t on (t.production_year > 1950 AND t.id = cc.movie_id ) 
join kind_type AS kt on (kt.kind = 'movie' AND kt.id = t.kind_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword IN ('superhero',   'sequel',  'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND k.id = mk.keyword_id ))S1 on (t.id = S1.mk_movie_id AND S1.mk_movie_id = cc.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join char_name AS chn on (chn.name NOT LIKE '%Sherlock%' AND (chn.name LIKE '%Tony%Stark%'  OR chn.name LIKE '%Iron%Man%') AND chn.id = ci.person_role_id ) join name AS n on (n.id = ci.person_id ))S2 on (t.id = S2.ci_movie_id AND S2.ci_movie_id = cc.movie_id AND S1.mk_movie_id = S2.ci_movie_id );