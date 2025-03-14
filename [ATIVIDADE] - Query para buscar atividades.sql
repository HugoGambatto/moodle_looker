SELECT ue.userid
	, c.id
	, c.fullname as curso
	, cm.module
	, cm.section -- MÓDULO
	, cs.name as Modulo 
	, cm.instance
	, COALESCE(url.name, resrc.name) as Atv
	-- , url.name as Atividades
	-- , resrc.name as Atividade2
	, cmc.completionstate as statusAtividade
	
	
	
	
	, count(*) over (partition by cs.id, c.id) as atividadesModulo
	, count(*) over (partition by cs.id, c.id, cm.instance) as CountAtividades
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
left join mdl_url as url
	on url.id = cm.instance
left join mdl_resource as resrc
	on resrc.id = cm.instance
left join mdl_course_modules_completion as cmc
	on cmc.coursemoduleid = cm.id
		and cmc.userid = ue.userid
WHERE ue.userid = 6473
	and c.id = 820
	and cm.section = 11065
	-- and cm.visible = 1
	and cm.completion = 2
order by cm.section 
