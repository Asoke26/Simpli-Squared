SELECT COUNT(*)
FROM movie_companies AS mc
join company_type AS ct on (mc.note NOT LIKE '%(TV)%' AND mc.note LIKE '%(USA)%' AND ct.kind = 'production companies' AND ct.id = mc.company_type_id ) 
join title AS t on (t.production_year > 1990 AND t.id = mc.movie_id ) 
JOIN (SELECT mi.movie_id AS mi_movie_id FROM movie_info AS mi
 join info_type AS it on (mi.info IN ('Sweden','Norway', 'Germany', 'Denmark', 'Swedish','Denish','Norwegian', 'German', 'USA','American') AND it.id = mi.info_type_id ))S1 on (t.id = S1.mi_movie_id AND mc.movie_id = S1.mi_movie_id );