SELECT COUNT(*)
FROM aka_name AS a1
join name AS n1 on (a1.person_id = n1.id ) 
JOIN (SELECT ci.person_id AS ci_person_id,ci.movie_id AS ci_movie_id FROM cast_info as ci join role_type as rt on (rt.role_t ='writer' AND ci.role_id = rt.id)) S1 on (n1.id = S1.ci_person_id AND a1.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (cn.country_code ='[us]' AND mc.company_id = cn.id)) S2 on (S1.ci_movie_id = S2.mc_movie_id ) 
join title AS t on (S1.ci_movie_id = t.id AND t.id = S2.mc_movie_id );