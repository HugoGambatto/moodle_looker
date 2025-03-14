-- DADOS USUÁRIOS


-- CRIAR UMA NOVA VIEW PARA TER OS DADOS ÚNICOS DOS USUÁRIOS SEM AS ATRIBUIÇÕES
-- SOMENTE OS DADOS PESSOAIS




-- CREATE OR REPLACE VIEW view_dados_usuarios as 
SELECT distinct vw.id
	, vw.username
	, vw.firstname
	, vw.lastname
	, vw.city
	, vw.cep
	, vw.cidade
	, vw.uf
	, vw.atribuicao
	, vw.tipoatribuicao
	, vw.deleted as ativo
	, vw.suspended
	, vw.ultimoacesso
	, vw.ultimoacesso_dias

from (SELECT usr.id
	, usr.username
	, concat(UCASE(left(usr.firstname, 1)), SUBSTRING(usr.firstname, 2)) as firstname
	, concat(UCASE(left(usr.lastname, 1)), SUBSTRING(usr.lastname, 2)) as lastname
	, usr.city
	, city.cep
	, city.cidade
	, city.uf
	-- , FROM_UNIXTIME(usr.currentlogin, '%Y-%m-%d %H:%i:%s') as currentlogin
	, FROM_UNIXTIME(usr.lastaccess, '%Y-%m-%d %H:%i:%s') as ultimoacesso
	, DATEDIFF(NOW(), from_unixtime(usr.lastaccess)) as ultimoacesso_dias
	, usr.confirmed as contaconfirmada
	, role.name as atribuicao
	, role.archetype tipoatribuicao
	, usr.deleted
	, usr.suspended
	-- , role.*
from moodle.mdl_user as usr
join moodle.mdl_role_assignments as ass
	on ass.userid = usr.id
join moodle.mdl_role as role
	on role.id = ass.roleid
left join view_cidade_user as city
	on city.userid = usr.id
where 1 = 1
 	and usr.id = 134
-- 	and role.archetype not in ('editingteacher', 'teacher', 'manager', 'guest')
) as vw 

order by vw.tipoatribuicao desc


-- Professores = editingteacher somente
