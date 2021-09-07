SELECT COUNT(*)
FROM aka_name AS an
join name AS n on (an.person_id = n.id ) 
join cast_info AS ci on (n.id = ci.person_id AND an.person_id = ci.person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (cn.country_code ='[us]' AND mc.company_id = cn.id)) S1 on (ci.movie_id = S1.mc_movie_id ) 
join title AS t on (t.episode_nr >= 50 AND t.episode_nr < 100 AND ci.movie_id = t.id AND t.id = S1.mc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword ='character-name-in-title' AND mk.keyword_id = k.id)) S2 on (t.id = S2.mk_movie_id AND ci.movie_id = S2.mk_movie_id AND S1.mc_movie_id = S2.mk_movie_id );