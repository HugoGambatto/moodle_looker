SELECT
    c.fullname AS 'Course',
    CONCAT(u.firstname, ' ', u.lastname) AS 'Name',
    cs.id as section_id,
    cs.name AS 'Topic',
    CASE
        WHEN gi.itemtype = 'Course' THEN CONCAT(c.fullname, ' Course Total')
        ELSE gi.itemname
    END AS 'Activity Name',
    -- CONCAT('https://home.entertechedu.com//mod/', m.name, '/view.php?id=', cm.id) AS 'Item Link',
    IF(ROUND(gg.finalgrade / gg.rawgrademax * 100, 2) > 42, 'Yes', 'No') AS Pass
    
FROM mdl_course AS c
JOIN mdl_context AS ctx 
	ON c.id = ctx.instanceid
JOIN mdl_role_assignments AS ra 
	ON ra.contextid = ctx.id
JOIN mdl_user AS u 
	ON u.id = ra.userid
JOIN mdl_grade_grades AS gg 
	ON gg.userid = u.id
JOIN mdl_grade_items AS gi 
	ON gi.id = gg.itemid
JOIN mdl_course_categories AS cc 
	ON cc.id = c.category
JOIN mdl_course_modules AS cm 
	ON cm.course = c.id
JOIN mdl_course_modules_completion AS cmc 
	ON cmc.coursemoduleid = cm.id 
		AND cmc.userid = u.id
JOIN mdl_course_sections AS cs 
	ON cs.id = cm.section
JOIN mdl_modules AS m 
	ON m.id = cm.module
WHERE gi.courseid = c.id
    AND gi.itemname != 'Attendance'
    -- AND c.shortname = 'jatshift'
    AND cs.course = c.id
    AND gi.iteminstance = cm.instance
    and u.id = 6302
ORDER BY
    Name ASC