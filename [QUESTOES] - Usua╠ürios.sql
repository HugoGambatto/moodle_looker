Select sq.userid
	, sq.nomeusuario
	, sq.sobrenome
	, sq.questao
	, sq.dataquestao
	, sq.somatorio
	, sq.situacao

from (SELECT distinct utd.userid
	, utd.firstname as nomeusuario
	, utd.lastname as sobrenome
	, utd.name AS questao
	, utd.date as dataquestao
	, qas.sumgrades as somatorio
	, qas.state as situacao
-- 	, c.fullname AS course_name
-- 	, cc.name AS category_name
	
FROM (
  SELECT u.id AS userid
	, u.firstname
	, u.lastname
	, qa.quiz AS quizid
	, FROM_UNIXTIME(qa.timestart) AS date
	, q.name
  FROM mdl_user u
  INNER JOIN mdl_quiz_attempts qa 
	ON u.id = qa.userid
  INNER JOIN mdl_quiz q 
	ON qa.quiz = q.id
join moodle.mdl_role_assignments as ass
	on ass.userid = u.id
join moodle.mdl_role as role
	on role.id = ass.roleid
  WHERE u.deleted = 0 
	AND u.suspended = 0
	and role.archetype = 'editingteacher'
) AS utd

INNER JOIN mdl_question_attempts qa2 
	ON utd.quizid = qa2.questionusageid
	
INNER JOIN mdl_question mq 
	ON qa2.questionid = mq.id
	
INNER JOIN mdl_quiz_attempts qas
	ON qas.quiz = utd.quizid 
	AND qas.userid = utd.userid
	
INNER JOIN (
  SELECT qas.quiz, qas.userid, MAX(qas.id) AS max_attempt_id
  FROM mdl_quiz_attempts qas
  GROUP BY qas.quiz, qas.userid
) AS latest_attempt 
	ON qas.id = latest_attempt.max_attempt_id 
	
 ORDER BY utd.lastname, utd.firstname, utd.name, utd.date, mq.name) as sq;