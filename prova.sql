create table aeronaves(
id serial primary key,
modelo VARCHAR(150) not null,
codigo_cauda varchar(10) unique not null,
capacidade int check(capacidade >0) not null
);



create table pilotos(
id serial primary key,
nome varchar(100) not null,
codigo_anac varchar(6) unique not null,
horas_voo int default '0'  check(horas_voo > 0)
);



create table voos(
id serial primary key,
aeronave_id int,
piloto_id int,
numero_voo int not null,
origem varchar(150) not null,
destino varchar(100) not null,
data_hora TIMESTAMP default current_timestamp,
status varchar(20) default 'Agendado' check (status in ('Agendado', 'Em Voo', 'Concluido', 'Cancelado')),

constraint fk_Aeronave
FOREIGN key (aeronave_id)
references aeronaves(id)
on delete cascade,

constraint fk_Piloto
FOREIGN key (piloto_id)
REFERENCES pilotos(id)
on delete cascade
);



CREATE TABLE passageiros(
id serial primary key,
nome varchar(100) not null,
cpf varchar(11) unique not null,
email varchar(100) unique not null
);

create table passagens(
id serial primary key,
voo_id int,
passageiro_id int,
assento varchar(4) not null,
classe varchar(20) default 'Economica' check(classe in('Economica', 'Executiva')),
valor numeric (10,2) check(valor > 0) not null,

constraint fk_Voo
FOREIGN key (voo_id)
REFERENCES voos(id)
on delete cascade,

constraint fk_Passageiros
FOREIGN key (passageiro_id)
references passageiros(id)
on delete cascade
)




insert into aeronaves(capacidade, codigo_cauda, modelo) VALUES
(300, 242, 'Ronaldo'),
(240, 442, 'space x'),
(350, 842, 'nasa'),
(400, 142, 'meloso'),
(300, 742, 'megamente')


insert into pilotos(codigo_anac, horas_voo, nome) VALUES
('abcd', 370, 'Enzo'),
('mogg', 304, 'Eduardo'),
('siuu', 302, 'Nicolas'),
('dcba', 100, 'Noah'),
(1234, 800, 'Victor')


insert into voos(aeronave_id, destino, numero_voo, origem, piloto_id, status) VALUES
(1, 'Chile', 842, 'Brasil', 1, 'Em Voo'),
(2, 'Jamaica', 654, 'Brasil', 2, 'Cancelado'),
(3, 'Brasil', 2354, 'EUA', 3, 'Em Voo'),
(4, 'Canada', 796, 'Brasil', 4, 'Em Voo'),
(5, 'Australia', 134, 'Brasil', 5, 'Em Voo')


insert into passageiros(nome, cpf, email) VALUES
('Aron', 11122233344, 'Aron@teste.com'),
('Willer', 22211133344, 'Willer@teste.com'),
('Matias', 12121233344, 'Matias@teste.com'),
('Daniel', 11122244433, 'Daniel@teste.com'),
('Navarro', 11122243434, 'Navarro@teste.com')


insert into passagens(assento, classe, passageiro_id, voo_id, valor) VALUES
('a1', 'Executiva', 1, 1, 1500.00),
('g6', 'Economica', 2, 2, 850.99),
('a3', 'Executiva', 3, 3, 1400.00),
('a2', 'Executiva', 4, 4, 1550.00),
('f1', 'Economica', 5, 5, 950.90)



SELECT
    voos.numero_voo,
    voos.origem,
    voos.destino,
    aeronaves.modelo,
    pilotos.nome AS piloto
FROM voos 
JOIN aeronaves 
    ON voos.aeronave_id = aeronaves.id
JOIN pilotos 
    ON voos.piloto_id = pilotos.id
WHERE voos.status IN ('Agendado', 'Em Voo');



SELECT
classe,
SUM(valor) AS Valor_total,
FROM passagens
GROUP BY classe;



SELECT
    passageiros.nome AS passageiro,
    voos.numero_voo,
    passagens.assento,
    passagens.valor
FROM passagens 
JOIN passageiros
    ON passagens.passageiro_id = passageiros.id
JOIN voos 
    ON passagens.voo_id = voos.id
WHERE passagens.classe = 'Executiva'
  AND passagens.valor > 800
ORDER BY passagens.valor DESC;



CREATE VIEW vw_painel_aeroporto AS
SELECT
voos.numero_voo,
voos.data_hora,
voos.origem,
voos.destino,
aeronaves.modelo,
aeronaves.codigo_cauda,
voos.status
FROM voos 
JOIN aeronaves 
ON voos.aeronave_id = aeronaves.id;



CREATE VIEW vw_faturamento_por_voo AS
SELECT
    voos.id AS voo_id,
    voos.numero_voo,
    voos.destino,
    SUM(passagens.valor) AS receita_total
FROM voos
JOIN passagens
    ON voos.id = passagens.voo_id
GROUP BY
    voos.id,
    voos.numero_voo,
    voos.destino;