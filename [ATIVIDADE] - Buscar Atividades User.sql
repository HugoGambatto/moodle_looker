SELECT ue.userid
	, vu.username
	, vu.firstname
	, vu.lastname
	, c.id
	, c.fullname as curso
	, cm.module
	, module.name as table_name
	, cm.section -- MÓDULO
	, cs.name as Modulo 
	, cm.instance
	, COALESCE(url.name, resrc.name, hvp.name, ass.name, page.name) as Atividade
	, cmc.completionstate as statusAtividade
	
	
	
	, sum(case when cmc.completionstate = 1 then 1 else 0 end) over (partition by ue.userid, cs.id, c.id, cm.instance) as realizadoAtividade
	, count(*) over (partition by ue.userid, cs.id, c.id) as atividadesModulo
	, count(*) over (partition by ue.userid, cs.id, c.id, cm.instance) as CountAtividades
	, ((sum(case when cmc.completionstate = 1 then 1 else 0 end) over (partition by ue.userid, cs.id, c.id) / count(*) over (partition by ue.userid, cs.id, c.id)) * 100 ) as percentual
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
left join mdl_course_modules_completion as cmc
	on cmc.coursemoduleid = cm.id
		and cmc.userid = ue.userid
join view_dados_usuarios as vu
	on vu.id = ue.userid
left join mdl_url as url
	on url.id = cm.instance
		and url.course = c.id
left join mdl_resource as resrc
	on resrc.id = cm.instance
		and resrc.course = c.id
left join mdl_hvp as hvp
	on hvp.id = cm.instance
		and hvp.course = c.id
left join mdl_assign as ass
	on ass.id = cm.instance
		and ass.course = c.id
left join mdl_page as page
	on page.id = cm.instance
		and page.course = c.id
WHERE 1 = 1
	and ue.userid = 6480
	and c.id = 820
	and cm.section = 11312
	-- and cm.visible = 1
	and cm.completion = 2
order by cm.section 
