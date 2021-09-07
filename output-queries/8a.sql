SELECT COUNT(*)
FROM aka_name AS an1
join name AS n1 on (n1.name LIKE '%Yo%' AND n1.name NOT LIKE '%Yu%' AND an1.person_id = n1.id ) 
JOIN (SELECT ci.person_id AS ci_person_id,ci.movie_id AS ci_movie_id FROM cast_info as ci join role_type as rt on (ci.note ='(voice: English version)' AND rt.role_t ='actress' AND ci.role_id = rt.id)) S1 on (n1.id = S1.ci_person_id AND an1.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (mc.note LIKE '%(Japan)%' AND mc.note NOT LIKE '%(USA)%' AND cn.country_code ='[jp]' AND mc.company_id = cn.id)) S2 on (S1.ci_movie_id = S2.mc_movie_id ) 
join title AS t on (S1.ci_movie_id = t.id AND t.id = S2.mc_movie_id );