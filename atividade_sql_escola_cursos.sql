-- ============================================================================
-- ATIVIDADE: Laboratório de revisão SQL
-- Banco de dados: escola_cursos (MySQL 8.0)
-- Aluna: Crislania
-- Conteúdo: 50 consultas (Partes 1 a 10) + operações INSERT, UPDATE e DELETE
-- ============================================================================

USE escola_cursos;

-- ============================================================================
-- PARTE 1 — CONSULTAS SIMPLES COM WHERE
-- ============================================================================

-- 1. Listar alunos ativos
-- Explicação: WHERE filtra as linhas em que a coluna situacao é igual a 'Ativo'.
SELECT *
FROM aluno
WHERE situacao = 'Ativo';

-- 2. Buscar alunos por cidade (exemplo: Fortaleza)
-- Explicação: seleciona apenas as colunas pedidas e filtra pela cidade.
SELECT nome, telefone, cidade, estado
FROM aluno
WHERE cidade = 'Fortaleza';

-- 3. Buscar professores ativos
SELECT *
FROM professor
WHERE situacao = 'Ativo';

-- 4. Cursos com mensalidade maior que 200,00
SELECT *
FROM curso
WHERE valor_mensalidade > 200.00;

-- 5. Cursos com carga horária entre 40 e 120 horas
-- Explicação: BETWEEN é inclusivo, ou seja, inclui 40 e 120.
SELECT *
FROM curso
WHERE carga_horaria BETWEEN 40 AND 120;


-- ============================================================================
-- PARTE 2 — WHERE COM OPERADORES LÓGICOS
-- ============================================================================

-- 6. Alunos ativos que moram em Fortaleza
-- Explicação: AND exige que as duas condições sejam verdadeiras.
SELECT *
FROM aluno
WHERE situacao = 'Ativo'
  AND cidade = 'Fortaleza';

-- 7. Turmas planejadas ou em andamento
-- Explicação: OR aceita a linha se qualquer condição for verdadeira.
SELECT *
FROM turma
WHERE situacao = 'Planejada'
   OR situacao = 'Em andamento';

-- 8. Mensalidades em aberto ou vencidas
-- Explicação: IN é uma forma mais curta de escrever vários OR na mesma coluna.
SELECT *
FROM mensalidade
WHERE situacao IN ('Aberta', 'Vencida');

-- 9. Avaliações com valor máximo igual a 10,00
SELECT *
FROM avaliacao
WHERE valor_maximo = 10.00;

-- 10. Notas abaixo da média (menores que 7,0)
SELECT *
FROM nota
WHERE nota < 7.0;


-- ============================================================================
-- PARTE 3 — ORDER BY
-- ============================================================================

-- 11. Alunos em ordem alfabética
-- Explicação: ASC (crescente) é o padrão do ORDER BY.
SELECT *
FROM aluno
ORDER BY nome ASC;

-- 12. Cursos do maior para o menor valor de mensalidade
SELECT *
FROM curso
ORDER BY valor_mensalidade DESC;

-- 13. Professores por especialidade e depois por nome
-- Explicação: o segundo critério só desempata quando a especialidade é igual.
SELECT *
FROM professor
ORDER BY especialidade ASC, nome ASC;

-- 14. Turmas por ano (decrescente) e semestre (crescente)
SELECT *
FROM turma
ORDER BY ano DESC, semestre ASC;

-- 15. Mensalidades por vencimento (da mais antiga para a mais recente)
SELECT *
FROM mensalidade
ORDER BY data_vencimento ASC;


-- ============================================================================
-- PARTE 4 — FILTROS COM DATAS
-- ============================================================================

-- 16. Matrículas realizadas em uma data específica (exemplo: 10/01/2026)
SELECT *
FROM matricula
WHERE data_matricula = '2026-01-10';

-- 17. Matrículas realizadas em março de 2026
-- Explicação: MONTH() extrai o mês e YEAR() extrai o ano da data.
SELECT *
FROM matricula
WHERE MONTH(data_matricula) = 3
  AND YEAR(data_matricula) = 2026;

-- 18. Mensalidades com vencimento entre duas datas
SELECT *
FROM mensalidade
WHERE data_vencimento BETWEEN '2026-03-01' AND '2026-04-30';

-- 19. Aulas realizadas em um dia específico (exemplo: 06/03/2026)
SELECT *
FROM aula
WHERE data_aula = '2026-03-06';

-- 20. Avaliações aplicadas em abril de 2026
SELECT *
FROM avaliacao
WHERE MONTH(data_avaliacao) = 4
  AND YEAR(data_avaliacao) = 2026;


-- ============================================================================
-- PARTE 5 — FUNÇÕES DE AGREGAÇÃO
-- ============================================================================

-- 21. Quantidade de alunos cadastrados
-- Explicação: COUNT(*) conta todas as linhas da tabela.
SELECT COUNT(*) AS total_alunos
FROM aluno;

-- 22. Quantidade de cursos ativos
SELECT COUNT(*) AS cursos_ativos
FROM curso
WHERE situacao = 'Ativo';

-- 23. Média das mensalidades dos cursos
SELECT AVG(valor_mensalidade) AS media_mensalidade
FROM curso;

-- 24. Maior mensalidade
SELECT MAX(valor_mensalidade) AS maior_mensalidade
FROM curso;

-- 25. Menor mensalidade
SELECT MIN(valor_mensalidade) AS menor_mensalidade
FROM curso;

-- 26. Total de valores pagos nas mensalidades
-- Explicação: SUM ignora valores NULL (mensalidades ainda não pagas).
SELECT SUM(valor_pago) AS total_pago
FROM mensalidade;


-- ============================================================================
-- PARTE 6 — GROUP BY
-- ============================================================================

-- 27. Quantidade de alunos por situação
-- Explicação: GROUP BY cria um grupo para cada situação e COUNT conta cada grupo.
SELECT situacao, COUNT(*) AS quantidade
FROM aluno
GROUP BY situacao;

-- 28. Quantidade de turmas por curso
SELECT c.nome AS curso, COUNT(t.codigo_turma) AS quantidade_turmas
FROM curso c
INNER JOIN turma t ON t.codigo_curso = c.codigo_curso
GROUP BY c.codigo_curso, c.nome;

-- 29. Quantidade de alunos matriculados por turma
SELECT t.nome AS turma, COUNT(m.codigo_matricula) AS alunos_matriculados
FROM turma t
INNER JOIN matricula m ON m.codigo_turma = t.codigo_turma
GROUP BY t.codigo_turma, t.nome;

-- 30. Total arrecadado por situação da mensalidade
SELECT situacao, SUM(valor_pago) AS total_arrecadado
FROM mensalidade
GROUP BY situacao;

-- 31. Média das notas por avaliação
SELECT a.codigo_avaliacao, a.descricao, AVG(n.nota) AS media_notas
FROM avaliacao a
INNER JOIN nota n ON n.codigo_avaliacao = a.codigo_avaliacao
GROUP BY a.codigo_avaliacao, a.descricao;


-- ============================================================================
-- PARTE 7 — HAVING
-- ============================================================================
-- Explicação geral: WHERE filtra linhas ANTES do agrupamento;
-- HAVING filtra os grupos DEPOIS do agrupamento (usa funções de agregação).

-- 32. Turmas com mais de 20 alunos matriculados
SELECT t.nome AS turma, COUNT(m.codigo_matricula) AS total_matriculas
FROM turma t
INNER JOIN matricula m ON m.codigo_turma = t.codigo_turma
GROUP BY t.codigo_turma, t.nome
HAVING COUNT(m.codigo_matricula) > 20;

-- 33. Cursos com mais de uma turma
SELECT c.nome AS curso, COUNT(t.codigo_turma) AS total_turmas
FROM curso c
INNER JOIN turma t ON t.codigo_curso = c.codigo_curso
GROUP BY c.codigo_curso, c.nome
HAVING COUNT(t.codigo_turma) > 1;

-- 34. Avaliações com média das notas menor que 7,0
SELECT a.codigo_avaliacao, a.descricao, AVG(n.nota) AS media_notas
FROM avaliacao a
INNER JOIN nota n ON n.codigo_avaliacao = a.codigo_avaliacao
GROUP BY a.codigo_avaliacao, a.descricao
HAVING AVG(n.nota) < 7.0;

-- 35. Professores que ministram mais de uma disciplina
SELECT p.nome AS professor, COUNT(d.codigo_disciplina) AS total_disciplinas
FROM professor p
INNER JOIN disciplina d ON d.codigo_professor = p.codigo_professor
GROUP BY p.codigo_professor, p.nome
HAVING COUNT(d.codigo_disciplina) > 1;


-- ============================================================================
-- PARTE 8 — INNER JOIN
-- ============================================================================
-- Explicação geral: INNER JOIN retorna somente as linhas que têm
-- correspondência nas duas tabelas (ligadas pela chave estrangeira).

-- 36. Turmas com seus cursos
SELECT t.nome AS turma, t.ano, t.semestre, c.nome AS curso
FROM turma t
INNER JOIN curso c ON c.codigo_curso = t.codigo_curso;

-- 37. Disciplinas com seus professores
SELECT d.nome AS disciplina, d.carga_horaria, p.nome AS professor
FROM disciplina d
INNER JOIN professor p ON p.codigo_professor = d.codigo_professor;

-- 38. Matrículas com nome do aluno e nome da turma
SELECT a.nome AS aluno, t.nome AS turma, m.data_matricula, m.situacao AS situacao_matricula
FROM matricula m
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma t ON t.codigo_turma = m.codigo_turma;

-- 39. Mensalidades com dados do aluno
SELECT a.nome AS aluno, m.codigo_matricula, me.numero_parcela,
       me.data_vencimento, me.valor, me.situacao AS situacao_mensalidade
FROM mensalidade me
INNER JOIN matricula m ON m.codigo_matricula = me.codigo_matricula
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno;

-- 40. Avaliações com disciplina e professor
SELECT av.descricao, av.data_avaliacao, d.nome AS disciplina, p.nome AS professor
FROM avaliacao av
INNER JOIN disciplina d ON d.codigo_disciplina = av.codigo_disciplina
INNER JOIN professor p ON p.codigo_professor = d.codigo_professor;


-- ============================================================================
-- PARTE 9 — LEFT JOIN
-- ============================================================================
-- Explicação geral: LEFT JOIN mantém TODAS as linhas da tabela da esquerda,
-- mesmo sem correspondência na direita (nesse caso as colunas vêm como NULL).
-- Com "WHERE ... IS NULL" encontramos justamente quem NÃO tem correspondência.

-- 41. Todos os alunos e suas matrículas (inclusive quem não tem matrícula)
SELECT a.codigo_aluno, a.nome AS aluno, m.codigo_matricula, m.codigo_turma, m.situacao
FROM aluno a
LEFT JOIN matricula m ON m.codigo_aluno = a.codigo_aluno;

-- 42. Todos os cursos e suas turmas (inclusive cursos sem turma)
SELECT c.codigo_curso, c.nome AS curso, t.codigo_turma, t.nome AS turma
FROM curso c
LEFT JOIN turma t ON t.codigo_curso = c.codigo_curso;

-- 43. Professores sem disciplina
-- Obs.: no banco atual todos os professores têm disciplina, então o resultado
-- pode vir vazio. A consulta continua correta.
SELECT p.codigo_professor, p.nome AS professor
FROM professor p
LEFT JOIN disciplina d ON d.codigo_professor = p.codigo_professor
WHERE d.codigo_disciplina IS NULL;

-- 44. Alunos sem responsável cadastrado
SELECT a.codigo_aluno, a.nome AS aluno
FROM aluno a
LEFT JOIN aluno_responsavel ar ON ar.codigo_aluno = a.codigo_aluno
WHERE ar.codigo_aluno IS NULL;

-- 45. Turmas sem matrículas
-- Obs.: no banco atual todas as turmas têm matrícula, então pode vir vazio.
SELECT t.codigo_turma, t.nome AS turma
FROM turma t
LEFT JOIN matricula m ON m.codigo_turma = t.codigo_turma
WHERE m.codigo_matricula IS NULL;


-- ============================================================================
-- PARTE 10 — CONSULTAS INTEGRADAS
-- ============================================================================

-- 46. Relatório geral de matrículas
SELECT a.nome AS aluno, c.nome AS curso, t.nome AS turma, t.ano, t.semestre,
       m.data_matricula, m.situacao AS situacao_matricula
FROM matricula m
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma t ON t.codigo_turma = m.codigo_turma
INNER JOIN curso c ON c.codigo_curso = t.codigo_curso;

-- 47. Relatório financeiro por aluno
SELECT a.nome AS aluno, t.nome AS turma, me.numero_parcela, me.data_vencimento,
       me.data_pagamento, me.valor, me.valor_pago, me.situacao AS situacao_mensalidade
FROM mensalidade me
INNER JOIN matricula m ON m.codigo_matricula = me.codigo_matricula
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma t ON t.codigo_turma = m.codigo_turma
ORDER BY a.nome, me.numero_parcela;

-- 48. Boletim de notas do aluno
-- Explicação: a condição d.codigo_turma = m.codigo_turma garante que só
-- apareçam as disciplinas da turma em que o aluno está matriculado.
SELECT a.nome AS aluno, t.nome AS turma, d.nome AS disciplina,
       av.descricao AS avaliacao, n.nota
FROM nota n
INNER JOIN matricula m ON m.codigo_matricula = n.codigo_matricula
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma t ON t.codigo_turma = m.codigo_turma
INNER JOIN avaliacao av ON av.codigo_avaliacao = n.codigo_avaliacao
INNER JOIN disciplina d ON d.codigo_disciplina = av.codigo_disciplina
                       AND d.codigo_turma = m.codigo_turma
ORDER BY a.nome, d.nome, av.descricao;

-- 49. Relatório de frequência do aluno
SELECT a.nome AS aluno, d.nome AS disciplina, au.data_aula, au.conteudo,
       f.presenca, f.justificativa
FROM frequencia f
INNER JOIN matricula m ON m.codigo_matricula = f.codigo_matricula
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN aula au ON au.codigo_aula = f.codigo_aula
INNER JOIN disciplina d ON d.codigo_disciplina = au.codigo_disciplina
ORDER BY a.nome, au.data_aula;

-- 50. Relatório de certificados emitidos
SELECT a.nome AS aluno, c.nome AS curso, t.nome AS turma,
       ce.data_emissao, ce.codigo_verificacao, ce.situacao AS situacao_certificado
FROM certificado ce
INNER JOIN matricula m ON m.codigo_matricula = ce.codigo_matricula
INNER JOIN aluno a ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma t ON t.codigo_turma = m.codigo_turma
INNER JOIN curso c ON c.codigo_curso = t.codigo_curso;


-- ============================================================================
-- LABORATÓRIO DE REVISÃO — INSERT, UPDATE E DELETE
-- ============================================================================
-- Os comandos abaixo usam um registro de teste (aluno 51) para não afetar
-- os dados originais. A sequência é: inserir -> conferir -> atualizar ->
-- conferir -> excluir -> conferir.

-- ---- INSERT: cadastrar um novo aluno ----
INSERT INTO aluno (nome, cpf, rg, data_nascimento, sexo, email, telefone, cep,
                   logradouro, numero, bairro, cidade, estado, data_cadastro, situacao)
VALUES ('Aluno Teste Laboratorio', '10000000051', 'RG051', '2000-05-15', 'F',
        'aluno51@email.com', '85999991051', '60000051', 'Rua Y', '61',
        'Centro', 'Fortaleza', 'CE', CURDATE(), 'Ativo');

-- Conferir a inclusão
SELECT * FROM aluno WHERE cpf = '10000000051';

-- ---- UPDATE: alterar a situação e o telefone do aluno de teste ----
-- Explicação: o WHERE é obrigatório, senão TODOS os alunos seriam alterados.
UPDATE aluno
SET situacao = 'Trancado',
    telefone = '85988887777'
WHERE cpf = '10000000051';

-- Conferir a alteração
SELECT codigo_aluno, nome, telefone, situacao FROM aluno WHERE cpf = '10000000051';

-- ---- UPDATE: reajustar em 5% a mensalidade do curso de Excel Profissional ----
UPDATE curso
SET valor_mensalidade = valor_mensalidade * 1.05
WHERE nome = 'Excel Profissional';

-- Conferir o reajuste
SELECT nome, valor_mensalidade FROM curso WHERE nome = 'Excel Profissional';

-- Desfazer o reajuste para manter os dados originais
UPDATE curso
SET valor_mensalidade = 220.00
WHERE nome = 'Excel Profissional';

-- ---- DELETE: excluir o aluno de teste ----
-- Explicação: o aluno 51 não tem matrícula nem responsável vinculado,
-- por isso a exclusão não viola nenhuma chave estrangeira.
DELETE FROM aluno
WHERE cpf = '10000000051';

-- Conferir a exclusão (deve retornar 0 linhas)
SELECT * FROM aluno WHERE cpf = '10000000051';

-- ============================================================================
-- FIM DO ARQUIVO
-- ============================================================================
