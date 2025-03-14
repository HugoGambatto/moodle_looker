Select q.*
	, qcat.*
from moodle.mdl_question as q
join moodle.mdl_question_versions as qv
	on qv.questionid = q.id
join moodle.mdl_question_bank_entries as qbe
	on qbe.id = qv.questionbankentryid
join moodle.mdl_question_categories as qcat
	on qcat.id = qbe.questioncategoryid
where qcat.idnumber in (999, 998)