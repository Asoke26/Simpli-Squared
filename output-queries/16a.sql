SELECT COUNT(*)
FROM aka_name AS an
join name AS n on (an.person_id = n.id ) 
JOIN (SELECT ci.person_id AS ci_person_id,ci.movie_id AS ci_movie_id,t.id AS t_id FROM cast_info AS ci
 join title AS t on (t.episode_nr >= 50 AND t.episode_nr < 100 AND ci.movie_id = t.id ))S1 on (n.id = S1.ci_person_id AND an.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_name AS cn on (cn.country_code ='[us]' AND mc.company_id = cn.id ))S2 on (S1.ci_movie_id = S2.mc_movie_id AND S1.t_id = S2.mc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword ='character-name-in-title' AND mk.keyword_id = k.id ))S3 on (S1.ci_movie_id = S3.mk_movie_id AND S1.t_id = S3.mk_movie_id AND S2.mc_movie_id = S3.mk_movie_id );