SELECT COUNT(*)
FROM movie_companies AS mc
join company_type AS ct on (ct.id = mc.company_type_id ) 
join company_name AS cn on (cn.country_code = '[ru]' AND cn.id = mc.company_id ) 
join title AS t on (t.production_year > 2005 AND t.id = mc.movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id FROM cast_info AS ci
 join role_type AS rt on (ci.note LIKE '%(voice)%' AND ci.note LIKE '%(uncredited)%' AND rt.role_t = 'actor' AND rt.id = ci.role_id ) join char_name AS chn on (chn.id = ci.person_role_id ))S1 on (t.id = S1.ci_movie_id AND S1.ci_movie_id = mc.movie_id );