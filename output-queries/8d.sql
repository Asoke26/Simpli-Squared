SELECT COUNT(*)
FROM aka_name AS an1
join name AS n1 on (an1.person_id = n1.id ) 
JOIN (SELECT ci.person_id AS ci_person_id,ci.movie_id AS ci_movie_id,t.id AS t_id FROM cast_info AS ci
 join role_type AS rt on (rt.role_t ='costume designer' AND ci.role_id = rt.id ) join title AS t on (ci.movie_id = t.id ))S1 on (n1.id = S1.ci_person_id AND an1.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_name AS cn on (cn.country_code ='[us]' AND mc.company_id = cn.id ))S2 on (S1.ci_movie_id = S2.mc_movie_id AND S1.t_id = S2.mc_movie_id );