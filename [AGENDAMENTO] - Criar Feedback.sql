CREATE EVENT IF NOT EXISTS agendar_tab_mart_feedback
ON SCHEDULE
    EVERY 1 DAY
    STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 23 HOUR + INTERVAL 23 MINUTE
ON COMPLETION PRESERVE
DO
	CALL criar_tabela_feedback();