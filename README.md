# Revisão SQL - Escola e Cursos

## Descrição da atividade

**Evidência de execução: Laboratório de revisão SQL**

Rodei o arquivo `atividade_sql_escola_cursos.sql` no MySQL Workbench, no banco `escola_cursos` que importei do AVA. Executei as 50 consultas uma por uma e todas rodaram sem erro. Os prints estão anexados na ordem das partes, de 1 a 10.

Nas primeiras partes, treinei os filtros com WHERE, os operadores lógicos, a ordenação e as consultas com datas. Depois vieram as funções de agregação, o GROUP BY e o HAVING, que foi o que mais me ajudou a entender a diferença entre filtrar linhas e filtrar grupos. Por fim, usei INNER JOIN e LEFT JOIN para juntar as tabelas e montar os relatórios completos de matrículas, financeiro, boletim, frequência e certificados.

Três consultas merecem uma observação. A 43 (professores sem disciplina) e a 45 (turmas sem matrículas) voltaram vazias, e isso está certo: no banco, todo professor já tem disciplina e toda turma já tem matrícula. A 44 (alunos sem responsável) trouxe os alunos de 16 a 50, porque só os 15 primeiros têm responsável cadastrado. Nos relatórios de boletim e frequência, precisei incluir uma condição extra para só aparecerem as disciplinas da turma em que o aluno realmente está.

No laboratório de INSERT, UPDATE e DELETE, usei um aluno de teste para não mexer nos dados reais: inseri, alterei a situação e o telefone, e depois excluí, conferindo cada passo com um SELECT. Também fiz um reajuste de 5% na mensalidade do curso de Excel e desfiz em seguida. Em todos os comandos usei WHERE, para atingir só o registro certo.

No fim, deu para praticar bem as cláusulas e os relacionamentos que a atividade pedia, e todos os resultados estão nos prints anexados.

**Crislania**

## Arquivo SQL

[atividade_sql_escola_cursos.sql](atividade_sql_escola_cursos.sql)
