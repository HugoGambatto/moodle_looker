-- VIEW PARA ACESSO AOS CAMPOS DE LOCALIZAÇÃO



CREATE or REPLACE VIEW view_cidade_user as
Select cf.userid
	, json_unquote(json_extract(cf.data, '$.cep')) as cep
	, json_unquote(json_extract(cf.data, '$.localidade')) as cidade
	, json_unquote(json_extract(cf.data, '$.uf')) as uf
	, json_unquote(json_extract(cf.data, '$.erro')) as erro
	
from mdl_user_info_data as cf
where cf.fieldid = 16
	and (cf.data <> 'null' and cf.data <> '')
HAVING erro is NULL
	