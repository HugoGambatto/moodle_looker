-- VIEW PARA VISUALIZAÇÃO DOS CAMPOS PERSONALIZADOS

CREATE OR REPLACE VIEW view_campos_personalizados as 
SELECT dt.userid
	, dt.data
	, fld.`name`
from moodle.mdl_user_info_data as dt
join moodle.mdl_user_info_field as fld
	on fld.id = dt.fieldid;