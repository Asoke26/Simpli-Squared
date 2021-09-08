SELECT COUNT(*)
FROM aka_name AS an
join name AS n on (n.gender ='f' AND n.name LIKE '%Angel%' AND an.person_id = n.id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id,ci.person_id AS ci_person_id,t.id AS t_id FROM cast_info AS ci
 join role_type AS rt on (ci.note = '(voice)' AND rt.role_t ='actress' AND ci.role_id = rt.id ) join title AS t on (t.production_year BETWEEN 2007 AND 2010 AND ci.movie_id = t.id ) join char_name AS chn on (chn.id = ci.person_role_id ))S1 on (n.id = S1.ci_person_id AND an.person_id = S1.ci_person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_name AS cn on (mc.note LIKE '%(200%)%' AND (mc.note LIKE '%(USA)%'  OR mc.note LIKE '%(worldwide)%') AND cn.country_code ='[us]' AND mc.company_id = cn.id ))S2 on (S1.ci_movie_id = S2.mc_movie_id AND S1.t_id = S2.mc_movie_id );