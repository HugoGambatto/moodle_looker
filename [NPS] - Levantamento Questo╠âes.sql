-- Módulo 800
-- Tutor 700



-- Buscar o nome do Quizz
-- Buscar a data da resposta
SELECT qa.userid
	, qa.quiz
	, case 
		when mq.name like '%5_FB%' then 'TUTOR'
		when mq.name like '%7_FB%' then 'AULA'
		else 'OUTRO'
	END TipoFeedback
	, FROM_UNIXTIME(qa.timefinish, '%Y-%m-%d') AS date
	, qa.id AS attempt_id
	, mq.name AS question_name
	, mq.id as question_id
	, qaa.responsesummary as user_response
	, qa.sumgrades
	, cat.name as curso
	, c.fullname as turma
FROM mdl_quiz_attempts qa
INNER JOIN mdl_question_attempts qaa 
	ON qa.uniqueid = qaa.questionusageid
INNER JOIN mdl_question mq 
	ON qaa.questionid = mq.id
	
join moodle.mdl_question_versions as qv
	on qv.questionid = mq.id
join moodle.mdl_question_bank_entries as qbe
	on qbe.id = qv.questionbankentryid
join moodle.mdl_question_categories as qcat
	on qcat.id = qbe.questioncategoryid
	
INNER JOIN mdl_user_enrolments ue 
	ON qa.userid = ue.userid
	
INNER JOIN mdl_enrol e 
	ON ue.enrolid = e.id

INNER JOIN mdl_course c 
	ON e.courseid = c.id

INNER JOIN mdl_course_categories as cat
	on cat.id = c.category

WHERE qcat.idnumber in (001)
	and qaa.responsesummary REGEXP '^[0-9]+$'
	and qaa.responsesummary is not Null
	-- and mq.id in (700, 800)
	and (mq.name like '%5_FB%' or mq.name like '%7_FB%')
ORDER BY qa.userid, qa.quiz, qa.id;
