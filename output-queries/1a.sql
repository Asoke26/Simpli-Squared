SELECT COUNT(*)
FROM movie_info_idx AS mi_idx
join info_type AS it on (it.info = 'top 250 rank' AND it.id = mi_idx.info_type_id ) 
join title AS t on (t.id = mi_idx.movie_id ) 
JOIN (SELECT mc.movie_id AS mc_movie_id FROM movie_companies AS mc
 join company_type AS ct on (mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%' AND (mc.note LIKE '%(co-production)%'   OR mc.note LIKE '%(presents)%') AND ct.kind = 'production companies' AND ct.id = mc.company_type_id ))S1 on (t.id = S1.mc_movie_id AND S1.mc_movie_id = mi_idx.movie_id );