SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link ='features' AND lt.id = ml.link_type_id ) 
join title AS t on (t.production_year BETWEEN 1980 AND 1984 AND ml.linked_movie_id = t.id ) 
JOIN (SELECT ci.movie_id AS ci_movie_id,ci.person_id AS ci_person_id,n.id AS n_id FROM cast_info AS ci
 join name AS n on (n.name_pcode_cf LIKE 'D%' AND n.gender='m' AND ci.person_id = n.id ))S1 on (t.id = S1.ci_movie_id AND S1.ci_movie_id = ml.linked_movie_id ) 
join aka_name AS an on (an.name LIKE '%a%' AND an.person_id = S1.ci_person_id AND S1.n_id = an.person_id ) 
JOIN (SELECT pi.person_id AS pi_person_id FROM person_info AS pi
 join info_type AS it on (pi.note ='Volker Boehm' AND it.info ='mini biography' AND it.id = pi.info_type_id ))S2 on (S2.pi_person_id = an.person_id AND S2.pi_person_id = S1.ci_person_id AND S1.n_id = S2.pi_person_id );