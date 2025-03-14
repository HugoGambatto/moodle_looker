-- Procedure para criar a tabela de consumo no DataStudio

DELIMITER $$
CREATE PROCEDURE criar_tabela_atividade()
BEGIN
	DROP TABLE IF EXISTS MART_DadosAtividadesUsuarios;
    CREATE TABLE IF NOT EXISTS MART_DadosAtividadesUsuarios AS
    -- ####  Começa aqui a query
    
    SELECT ue.userid
	, vu.username
	, vu.firstname
	, vu.lastname
	, vu.cidade
	, vu.uf
	, c.id curso_id
	, c.fullname as curso
	, cm.module as module_id
	-- , module.name as table_name
	, cm.section -- MÓDULO
	, cs.name as Modulo 
	, cm.instance
	, gr.name as grupo
	
	, COALESCE(assi.name ,atte.name ,bigb.name ,boar.name ,book.name ,chat.name ,choi.name ,cour.name ,data.name ,feed.name ,fold.name ,foru.name ,glos.name ,h5pa.name ,hvp.name ,imsc.name ,labe.name ,less.name ,lti.name ,page.name ,ques.name ,quiz.name ,reen.name ,reso.name ,scor.name ,stic.name ,surv.name ,trac.name ,url.name ,vpl.name ,wiki.name ,word.name ,work.name ,zoom.name ) as Atividade
	, cmc.completionstate as statusAtividade
	
	
	
	, sum(case when cmc.completionstate in (1, 2) then 1 else 0 end) over (partition by ue.userid, cs.id, c.id, cm.instance) as realizadoAtividade
	, count(*) over (partition by ue.userid, cs.id, c.id) as atividadesModulo
	, count(*) over (partition by ue.userid, cs.id, c.id, cm.instance) as CountAtividades
	, ((sum(case when cmc.completionstate in (1, 2) then 1 else 0 end) over (partition by ue.userid, cs.id, c.id) / count(*) over (partition 		by ue.userid, cs.id, c.id)) * 100 ) as percentual
	from mdl_course as c
	JOIN mdl_enrol as e
		on e.courseid = c.id
	join mdl_user_enrolments as ue
		on ue.enrolid = e.id
	join mdl_course_modules as cm
		on cm.course = c.id
	join mdl_course_sections as cs
		on cs.course = c.id
			and cs.id = cm.section
	join mdl_modules  as module
		on module.id = cm.module 
	join (SELECT usr.id
		, usr.username
		, concat(UCASE(left(usr.firstname, 1)), SUBSTRING(usr.firstname, 2)) as firstname
		, concat(UCASE(left(usr.lastname, 1)), SUBSTRING(usr.lastname, 2)) as lastname
		, city.cidade
		, city.uf
		-- , FROM_UNIXTIME(usr.currentlogin, '%Y-%m-%d %H:%i:%s') as currentlogin
		, FROM_UNIXTIME(usr.lastaccess, '%Y-%m-%d %H:%i:%s') as ultimoacesso
		, usr.confirmed as contaconfirmada
		, usr.deleted
		, usr.suspended
		-- , role.*
	from moodle.mdl_user as usr
	left join view_cidade_user as city
		on city.userid = usr.id
	where 1 = 1
	) as vu
		on vu.id = ue.userid 
	left join mdl_course_modules_completion as cmc
		on cmc.coursemoduleid = cm.id
			and cmc.userid = ue.userid
	LEFT JOIN mdl_groups_members grm 
		ON grm.userid = ue.userid 
	LEFT JOIN mdl_groups gr 
		ON gr.courseid = c.id 
			AND grm.groupid = gr.id 
	left join mdl_assign as assi on assi.id = cm.instance and assi.course = c.id left join mdl_attendance as atte on atte.id = cm.instance and atte.course = c.id left join mdl_bigbluebuttonbn as bigb on bigb.id = cm.instance and bigb.course = c.id left join mdl_board as boar on boar.id = cm.instance and boar.course = c.id left join mdl_book as book on book.id = cm.instance and book.course = c.id left join mdl_chat as chat on chat.id = cm.instance and chat.course = c.id left join mdl_choice as choi on choi.id = cm.instance and choi.course = c.id left join mdl_coursecertificate as cour on cour.id = cm.instance and cour.course = c.id left join mdl_data as data on data.id = cm.instance and data.course = c.id left join mdl_feedback as feed on feed.id = cm.instance and feed.course = c.id left join mdl_folder as fold on fold.id = cm.instance and fold.course = c.id left join mdl_forum as foru on foru.id = cm.instance and foru.course = c.id left join mdl_glossary as glos on glos.id = cm.instance and glos.course = c.id left join mdl_h5pactivity as h5pa on h5pa.id = cm.instance and h5pa.course = c.id left join mdl_hvp as hvp on hvp.id = cm.instance and hvp.course = c.id left join mdl_imscp as imsc on imsc.id = cm.instance and imsc.course = c.id left join mdl_label as labe on labe.id = cm.instance and labe.course = c.id left join mdl_lesson as less on less.id = cm.instance and less.course = c.id left join mdl_lti as lti on lti.id = cm.instance and lti.course = c.id left join mdl_page as page on page.id = cm.instance and page.course = c.id left join mdl_questionnaire as ques on ques.id = cm.instance and ques.course = c.id left join mdl_quiz as quiz on quiz.id = cm.instance and quiz.course = c.id left join mdl_reengagement as reen on reen.id = cm.instance and reen.course = c.id left join mdl_resource as reso on reso.id = cm.instance and reso.course = c.id left join mdl_scorm as scor on scor.id = cm.instance and scor.course = c.id left join mdl_stickynotes as stic on stic.id = cm.instance and stic.course = c.id left join mdl_survey as surv on surv.id = cm.instance and surv.course = c.id left join mdl_tracker as trac on trac.id = cm.instance and trac.course = c.id left join mdl_url as url on url.id = cm.instance and url.course = c.id left join mdl_vpl as vpl on vpl.id = cm.instance and vpl.course = c.id left join mdl_wiki as wiki on wiki.id = cm.instance and wiki.course = c.id left join mdl_wordcloud as word on word.id = cm.instance and word.course = c.id left join mdl_workshop as work on work.id = cm.instance and work.course = c.id left join mdl_zoom as zoom on zoom.id = cm.instance and zoom.course = c.id
	WHERE 1 = 1
		-- and ue.userid = 6480
		-- and c.id = 820
		-- and cm.section = 11312
		-- and cm.visible = 1
		and cm.completion = 2
	order by cm.section;

-- #### Termina aqui a query
END$$
DELIMITER ;
