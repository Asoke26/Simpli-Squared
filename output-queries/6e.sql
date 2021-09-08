SELECT COUNT(*)
FROM movie_keyword AS mk
join keyword AS k on (k.keyword = 'marvel-cinematic-universe' AND k.id = mk.keyword_id ) 
join title AS t on (t.production_year > 2000 AND t.id = mk.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join name AS n on (n.name LIKE '%Downey%Robert%' AND n.id = ci.person_id ))S1 on (t.id = S1.ci_movie_id AND S1.ci_movie_id = mk.movie_id );