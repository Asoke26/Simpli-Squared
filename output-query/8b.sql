SELECT COUNT(*)
FROM aka_name AS an
join name AS n on (n.name LIKE '%Yo%' AND n.name NOT LIKE '%Yu%' AND an.person_id = n.id ) 
JOIN (SELECT ci.person_id AS ci_person_id,ci.movie_id AS ci_movie_id FROM cast_info as ci join role_type as rt on (ci.note ='(voice: English version)' AND rt.role_t ='actress' AND ci.role_id = rt.id)) S1 on (n.id = S1.ci_person_id AND an.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (mc.note LIKE '%(Japan)%' AND mc.note NOT LIKE '%(USA)%' AND (mc.note LIKE '%(2006)%'  OR mc.note LIKE '%(2007)%') AND cn.country_code ='[jp]' AND mc.company_id = cn.id)) S2 on (S1.ci_movie_id = S2.mc_movie_id ) 
join title AS t on (t.production_year BETWEEN 2006 AND 2007 AND (t.title LIKE 'One Piece%'  OR t.title LIKE 'Dragon Ball Z%') AND S1.ci_movie_id = t.id AND t.id = S2.mc_movie_id );