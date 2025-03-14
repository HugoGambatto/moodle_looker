Set @joins = NULL, @selects= NULL;

SELECT GROUP_CONCAT(distinct concat (
	'left join mdl_', name, ' as ', left(name, 4),
	' on ', left(name, 4), '.id = cm.instance and ',
	left(name, 4), '.course = c.id'
) SEPARATOR ' ') into @joins from mdl_modules;


Select group_concat(DISTINCT concat (
	 LEFT(name, 4), '.name '
)) into @selects from mdl_modules;

SET @sql = concat(
	'SELECT ue.userid
	, vu.username
	, vu.firstname
	, vu.lastname
	, c.id
	, c.fullname as curso
	, cm.module
	-- , module.name as table_name
	, cm.section -- MÓDULO
	, cs.name as Modulo 
	, cm.instance
	, COALESCE(', @selects, ') as Atividade ',
	', cmc.completionstate as statusAtividade
	
	
	
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
join view_dados_usuarios as vu
	on vu.id = ue.userid 
left join mdl_course_modules_completion as cmc
	on cmc.coursemoduleid = cm.id
		and cmc.userid = ue.userid ',
	@joins, 
	' WHERE 1 = 1
	-- and ue.userid = 6480
	-- and c.id = 820
	-- and cm.section = 11312
	-- and cm.visible = 1
	and cm.completion = 2
order by cm.section' 
);
PREPARE stmt FROM @sql;
EXECUTE stmt;