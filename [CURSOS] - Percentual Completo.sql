SELECT c.fullname AS course_name
	, u.id as user_id
	, vu.suspended
	, u.firstname
	, u.lastname
	, vu.cidade
	, vu.uf
	, vu.atribuicao
	, cat.name as categoria_name
	, cs.name as Module
	, ROUND(SUM(CASE WHEN cm.completion = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS completion_percentage
FROM mdl_course_modules_completion as cmc
INNER JOIN mdl_user u 
	ON cmc.userid = u.id
INNER JOIN mdl_course_modules cm 
	ON cmc.coursemoduleid = cm.id
INNER JOIN mdl_course c 
	ON cm.course = c.id
JOIN mdl_course_sections AS cs 
	ON cs.id = cm.section
left join view_dados_usuarios as vu
	on vu.id = u.id
left JOIN mdl_course_categories as cat
	on cat.id = c.category
where cmc.userid = 5834
GROUP BY c.fullname, u.firstname, u.lastname
-- HAVING ROUND(SUM(CASE WHEN cm.completion = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) > 90
ORDER BY u.firstname, c.fullname, cs.name;
