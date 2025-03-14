-- QUERY INCOMPLETA

CREATE OR REPLACE VIEW view_perguntas_professores as 
SELECT vp.*
	, qu.curso
	, qu.turma
	, qu.pergunta
	, qu.date
from view_dados_professores as vp
left JOIN view_questoes_user as qu
	on qu.id = vp.id