SELECT COUNT(*)
FROM complete_cast AS cc
join comp_cast_type AS cct1 on (cct1.kind ='cast' AND cct1.id = cc.subject_id ) 
join comp_cast_type AS cct2 on (cct2.kind ='complete+verified' AND cct2.id = cc.status_id ) 
join title AS t on (t.production_year BETWEEN 2000 AND 2010 AND t.id = cc.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies as mc join company_name as cn on (cn.country_code ='[us]' AND cn.id = mc.company_id)) S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = cc.movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword as mk join keyword as k on (k.keyword = 'computer-animation' AND k.id = mk.keyword_id)) S2 on (t.id = S2.mk_movie_id AND S2.mk_movie_id = cc.movie_id AND S1.mc_movie_id = S2.mk_movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info as mi join info_type as it on (mi.info IS NOT NULL AND (mi.info LIKE 'Japan:%200%' OR mi.info LIKE 'USA:%200%') AND it.info = 'release dates' AND it.id = mi.info_type_id)) S3 on (t.id = S3.mi_movie_id AND S3.mi_movie_id = cc.movie_id AND S1.mc_movie_id = S3.mi_movie_id AND S3.mi_movie_id = S2.mk_movie_id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id,ci.person_id AS ci_person_id,ci.person_role_id AS ci_person_role_id FROM cast_info as ci join role_type as rt on (ci.note IN ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND rt.role_t ='actress' AND rt.id = ci.role_id)) S4 on (t.id = S4.ci_movie_id AND S4.ci_movie_id = cc.movie_id AND S1.mc_movie_id = S4.ci_movie_id AND S4.ci_movie_id = S2.mk_movie_id AND S3.mi_movie_id = S4.ci_movie_id ) 
JOIN (SELECT an.person_id AS an_person_id,n.id AS n_id FROM aka_name as an join name as n on (n.gender ='f' AND n.name LIKE '%An%' AND n.id = an.person_id)) S5 on (S4.ci_person_id = S5.an_person_id AND S5.n_id = S4.ci_person_id ) 
JOIN (SELECT pi.person_id AS pi_person_id FROM person_info as pi join info_type as it3 on (it3.info = 'trivia' AND it3.id = pi.info_type_id)) S6 on (S4.ci_person_id = S6.pi_person_id AND S5.n_id = S6.pi_person_id ) 
join char_name AS chn on (chn.id = S4.ci_person_role_id );