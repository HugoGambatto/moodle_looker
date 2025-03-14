-- Procedure para criar a tabela de consumo no DataStudio

DELIMITER $$
CREATE PROCEDURE criar_tabela_agendada()
BEGIN
	DROP TABLE IF EXISTS MART_DadosQuestoesUsuarios;
    CREATE TABLE IF NOT EXISTS MART_DadosQuestoesUsuarios AS
    SELECT vp.*, qu.questao
	    , qu.somatorio
	    , qu.dataquestao
	    , qu.situacao
	    , qu.curso
	    , qu.turma
    FROM view_dados_professores AS vp
    LEFT JOIN (
        SELECT sq.userid, sq.nomeusuario, sq.sobrenome, sq.questao, sq.dataquestao, sq.somatorio, sq.situacao, sq.curso, sq.turma
        FROM (
            SELECT DISTINCT utd.userid, utd.firstname AS nomeusuario, utd.lastname AS sobrenome, utd.name AS questao, utd.date AS dataquestao, qas.sumgrades AS somatorio, qas.state AS situacao, cat.name AS curso, c.fullname AS turma
            FROM (
                SELECT u.id AS userid, u.firstname, u.lastname, qa.quiz AS quizid, FROM_UNIXTIME(qa.timestart) AS date, q.name
                FROM mdl_user u
                INNER JOIN mdl_quiz_attempts qa ON u.id = qa.userid
                INNER JOIN mdl_quiz q ON qa.quiz = q.id
                JOIN moodle.mdl_role_assignments AS ass ON ass.userid = u.id
                JOIN moodle.mdl_role AS role ON role.id = ass.roleid
                WHERE u.deleted = 0 AND u.suspended = 0
            ) AS utd
            INNER JOIN mdl_question_attempts qa2 ON utd.quizid = qa2.questionusageid
            INNER JOIN mdl_question mq ON qa2.questionid = mq.id
            INNER JOIN mdl_quiz_attempts qas ON qas.quiz = utd.quizid AND qas.userid = utd.userid
            INNER JOIN mdl_user_enrolments ue ON utd.userid = ue.userid
            INNER JOIN mdl_enrol e ON ue.enrolid = e.id
            INNER JOIN mdl_course c ON e.courseid = c.id
            INNER JOIN mdl_course_categories AS cat ON cat.id = c.category
            INNER JOIN (
                SELECT qas.quiz, qas.userid, MAX(qas.id) AS max_attempt_id
                FROM mdl_quiz_attempts qas
                GROUP BY qas.quiz, qas.userid
            ) AS latest_attempt ON qas.id = latest_attempt.max_attempt_id
            ORDER BY utd.lastname, utd.firstname, utd.name, utd.date, mq.name
        ) AS sq
    ) AS qu ON qu.userid = vp.id;
END$$
DELIMITER ;
