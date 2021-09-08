SELECT COUNT(*)
FROM movie_companies AS mc
join company_name AS cn on (cn.country_code ='[us]' AND cn.id = mc.company_id ) 
join title AS t on (mc.movie_id = t.id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword ='character-name-in-title' AND mk.keyword_id = k.id ))S1 on (t.id = S1.mk_movie_id AND mc.movie_id = S1.mk_movie_id );