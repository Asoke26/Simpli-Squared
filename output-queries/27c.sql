SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link LIKE '%follow%' AND lt.id = ml.link_type_id ) 
join title AS t on (t.production_year BETWEEN 1950 AND 2010 AND ml.movie_id = t.id ) 
JOIN (SELECT cc.movie_id AS cc_movie_id FROM complete_cast AS cc
 join comp_cast_type AS cct1 on (cct1.kind = 'cast' AND cct1.id = cc.subject_id ) join comp_cast_type AS cct2 on (cct2.kind LIKE 'complete%' AND cct2.id = cc.status_id ))S1 on (t.id = S1.cc_movie_id AND ml.movie_id = S1.cc_movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (mc.note IS NULL AND ct.kind ='production companies' AND mc.company_type_id = ct.id ) join company_name AS cn on (cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND mc.company_id = cn.id ))S2 on (t.id = S2.mc_movie_id AND ml.movie_id = S2.mc_movie_id AND S2.mc_movie_id = S1.cc_movie_id ) 
JOIN (SELECT mk.movie_id AS mk_movie_id FROM movie_keyword AS mk
 join keyword AS k on (k.keyword ='sequel' AND mk.keyword_id = k.id ))S3 on (t.id = S3.mk_movie_id AND ml.movie_id = S3.mk_movie_id AND S3.mk_movie_id = S1.cc_movie_id AND S3.mk_movie_id = S2.mc_movie_id ) 
join movie_info AS mi on (mi.info IN ('Sweden',  'Norway', 'Germany', 'Denmark', 'Swedish','Denish', 'Norwegian',  'German', 'English') AND mi.movie_id = t.id AND ml.movie_id = mi.movie_id AND mi.movie_id = S1.cc_movie_id AND S2.mc_movie_id = mi.movie_id AND S3.mk_movie_id = mi.movie_id );