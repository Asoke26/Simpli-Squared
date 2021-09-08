SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it on (it.info = 'bottom 10 rank' AND it.id = mi_idx.info_type_id ) 
join title AS t on (t.production_year BETWEEN 2005 AND 2010 AND t.id = mi_idx.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%' AND ct.kind = 'production companies' AND ct.id = mc.company_type_id ))S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = mi_idx.movie_id );