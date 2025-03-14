-- Evento que agenda a criação do banco todos os dia para consumo no dashboard

CREATE EVENT IF NOT EXISTS agendar_tab_mart_questoes
ON SCHEDULE EVERY 8 HOUR
STARTS CURRENT_TIMESTAMP
DO
    CALL criar_tabela_agendada();