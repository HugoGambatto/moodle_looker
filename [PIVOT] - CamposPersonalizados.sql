-- Buscar os campos personalizados do Banco

SET @sql = NULL;

SELECT
  GROUP_CONCAT(DISTINCT
               CONCAT('MAX(IF(s.name = ''', `name`,''', s.`data`,0)) AS ', '`', name, '`')
              ) into @sql
FROM view_campos_personalizados;

SET @sql = CONCAT('SELECT s.userid,  ', @sql, ' 
                  FROM view_campos_personalizados s
                 GROUP BY s.userid
                 ORDER BY s.userid');
 -- SELECT @sql;
PREPARE stmt FROM @sql;
EXECUTE stmt;

-- {"cep":"99070-070","logradouro":"Rua Jos\u00e9 Bonif\u00e1cio","complemento":"","bairro":"Vila Rodrigues","localidade":"Passo Fundo","uf":"RS","ibge":"4314100","gia":"","ddd":"54","siafi":"8785","numero":"1428"}