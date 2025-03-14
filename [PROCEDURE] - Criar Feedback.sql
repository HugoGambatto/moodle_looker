-- Procedure para criar a tabela de consumo no DataStudio

DELIMITER $$
CREATE PROCEDURE criar_tabela_feedback()
BEGIN
	DROP TABLE IF EXISTS MART_DadosFeedback;
	CREATE TABLE IF NOT EXISTS MART_DadosFeedback AS
    -- ####  Começa aqui a query
    
		   Select qrs.choice_id
			, qqc.content
			, qq.id as question_id
			, qq.name as question_name
			, qq.surveyid
			, qs.name as survey_name
			, FROM_UNIXTIME(qr.submitted) as subimitted
			, qr.complete
			, qr.id as response_id
			, qr.grade
			, q.id as questionnaireid
			, q.name as quationnairename
			, q.course
			, course.fullname as course_name
			, cat.name as category_name
			, FROM_UNIXTIME(q.closedate) as closedate
			, qr.userid
			, vu.username
			, CONCAT(vu.firstname, ' ', vu.lastname) as nomecompleto
		    , vu.firstname
		    , gr.name as grupo
		from mdl_questionnaire_resp_single as qrs
		join mdl_questionnaire_question as qq
			on qq.id = qrs.question_id
		join mdl_questionnaire_quest_choice as qqc
			on qqc.id = qrs.choice_id
		join mdl_questionnaire_response as qr
			on qr.id = qrs.response_id
		join view_dados_usuarios as vu
			on vu.id = qr.userid
		join mdl_questionnaire as q
			on q.id = qr.questionnaireid
		join mdl_questionnaire_survey as qs
			on qs.id = qq.surveyid
		join mdl_course as course
			on course.id = q.course
		join mdl_course_categories as cat
			on cat.id = course.category
		left join mdl_groups as gr
			on gr.courseid = course.id
		left join mdl_groups_members as grm
			on grm.groupid = gr.id
				and grm.userid = vu.id
		where qq.name in ('fb_aula', 'fb_tutor', 'fb_professor', 'fb_modulo', 'fb_comportamental');

-- #### Termina aqui a query
END$$
DELIMITER ;
