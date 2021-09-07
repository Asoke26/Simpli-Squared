SELECT COUNT(*)
FROM aka_name AS an
join name AS n on (n.gender ='f' AND n.id = an.person_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id,ci.person_id AS ci_person_id,ci.person_role_id AS ci_person_role_id FROM cast_info as ci join role_type as rt on (ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND rt.role_t ='actress' AND rt.id = ci.role_id)) S1 on (n.id = S1.ci_person_id AND S1.ci_person_id = an.person_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (cn.country_code ='[us]' AND cn.id = mc.company_id)) S2 on (S2.mc_movie_id = S1.ci_movie_id ) 
join title AS t on (t.production_year > 2000 AND t.id = S1.ci_movie_id AND t.id = S2.mc_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it on (it.info = 'release dates' AND it.id = mi.info_type_id)) S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = S1.ci_movie_id AND S2.mc_movie_id = S3.mi_movie_id ) 
join char_name AS chn on (chn.id = S1.ci_person_role_id );