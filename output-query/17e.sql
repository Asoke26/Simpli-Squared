SELECT COUNT(*)
FROM movie_companies AS mc
join company_name AS cn on (cn.country_code ='[us]' AND mc.company_id = cn.id ) 
join title AS t on (t.id = mc.movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword ='character-name-in-title' AND mk.keyword_id = k.id)) S1 on (t.id = S1.mk_movie_id AND mc.movie_id = S1.mk_movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info as ci join name as n on (n.id = ci.person_id)) S2 on (S2.ci_movie_id = t.id AND S2.ci_movie_id = mc.movie_id AND S2.ci_movie_id = S1.mk_movie_id );