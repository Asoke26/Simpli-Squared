SELECT COUNT(*)
FROM movie_link AS ml
join link_type AS lt on (lt.link ='features' AND lt.id = ml.link_type_id ) 
join title AS t on (t.production_year BETWEEN 1980 AND 1984 AND ml.linked_movie_id = t.id ) 
join cast_info AS ci on (t.id = ci.movie_id AND ci.movie_id = ml.linked_movie_id ) 
JOIN (SELECT an.person_id AS an_person_id,n.id AS n_id FROM aka_name as an join name as n on (an.name LIKE '%a%' AND n.name_pcode_cf LIKE 'D%' AND n.gender='m' AND n.id = an.person_id)) S1 on (S1.an_person_id = ci.person_id AND ci.person_id = S1.n_id ) 
JOIN (SELECT pi.person_id AS pi_person_id FROM person_info as pi join info_type as it on (pi.note ='Volker Boehm' AND it.info ='mini biography' AND it.id = pi.info_type_id)) S2 on (S2.pi_person_id = ci.person_id AND S2.pi_person_id = S1.an_person_id AND S1.n_id = S2.pi_person_id );