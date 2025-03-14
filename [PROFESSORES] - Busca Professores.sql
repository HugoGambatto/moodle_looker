CREATE OR REPLACE VIEW view_dados_professores as 
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
	, usr.confirmed as contaconfirmada
	, role.name as atribuicao
	, role.archetype tipoatribuicao
	, usr.deleted
	-- , role.*
from moodle.mdl_user as usr
join moodle.mdl_role_assignments as ass
	on ass.userid = usr.id
join moodle.mdl_role as role
	on role.id = ass.roleid
left join view_cidade_user as city
	on city.userid = usr.id
where 1 = 1
-- 	and usr.id = 4247
	and role.archetype = 'editingteacher') as vw 

order by vw.tipoatribuicao desc



-- Professores = editingteacher somente