-- QUESTÕES DOS USUÁRIOS


CREATE or REPLACE VIEW view_questoes_user as 
SELECT u.id
	, u.firstname
	, u.lastname
	, cat.name as curso
	, c.fullname as turma
	, q.name as pergunta
	, FROM_UNIXTIME(ue.timestart) AS date
FROM mdl_user u
INNER JOIN mdl_user_enrolments ue 
	ON u.id = ue.userid
	
INNER JOIN mdl_enrol e 
	ON ue.enrolid = e.id
	
INNER JOIN mdl_course c 
	ON e.courseid = c.id

INNER JOIN mdl_course_categories as cat
	on cat.id = c.category
	
INNER JOIN mdl_quiz q 
	ON c.id = q.course
	
INNER JOIN mdl_quiz_attempts qa 
	ON q.id = qa.quiz
	
WHERE u.deleted = 0 
	AND u.suspended = 0 
	AND qa.userid = u.id
ORDER BY u.lastname
	, u.firstname
	, q.name
	, date;