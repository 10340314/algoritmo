DROP DATABASE IF EXISTS CottonAnalytics;

create database CottonAnalytics;

use CottonAnalytics;

Create table Empresa (
idEmpresa int primary key auto_increment,
nomeEmpresa varchar(45) not null,
CNPJ char(14) not null unique,
telefoneUm  varchar(11) not null,
telefoneDois varchar(11),
emailEmpresa varchar(45) unique not null, constraint chkEmailEmpresa check (emailEmpresa like '%@%'),
quantidadeHectares int not null,
Token char(7) unique not null,
dataContrato datetime default current_timestamp
);


Create table Endereco (
idEndereco int primary key auto_increment,
CEP char(8) not null,
Estado char(2) not null,
Cidade varchar(45) not null,
Bairro varchar(45) not null,
Rua varchar(60) not null,
Numero int not null,
Complemento varchar(45),
fkEmpresa int, constraint ctFkEmpr_End foreign key Endereco(fkEmpresa) references Empresa(idEmpresa)
);

Create table Usuario (
idUsuario int auto_increment,
fkEmpresa int,  constraint ctFkEmpr_Usu foreign key Usuario(fkEmpresa) references Empresa(idEmpresa),
primary key(idUsuario, fkEmpresa),
nomeUsuario varchar(45) not null,
sobrenomeUsuario varchar(45) not null,
CPF char(11) unique not null,
emailUsuario varchar(45) unique not null, constraint chkEmailUsuario check(emailUsuario like '%@%'),
senha varchar(20) not null
);

create table Hectares (
idHectares int primary key auto_increment,
localizacaoHectare varchar(3) not null,
fkEndereco int, constraint ctFkEnde_Hect foreign key Hectares(fkEndereco) references Endereco(idEndereco)
);

create table Sensor (
idSensor int primary key auto_increment,
fkHectares int, constraint ctFkHect_Sensor foreign key Sensor(fkHectares) references Hectares(idHectares),
statusSensor varchar(20) not null, constraint chkStatus check(statusSensor in ('Ativo', 'Manutenção', 'Inativo')),
setorSensor int not null, constraint chkSensor check(setorSensor between 1 and 3)
);

create table DadosSensor (
idDadosSensor int auto_increment,
fkSensor int, constraint ctFkSensor_Dados foreign key DadosSensor(fkSensor) references Sensor(idSensor),
primary key(idDadosSensor, fkSensor), 
umidade double default('S/D'),
temperatura double default('S/D'),
dataDado datetime default('S/D')
);

select * from Empresa;
select * from Usuario;
select * from Endereco;
select * from Hectares;
select * from Sensor;
select * from DadosSensor;

insert into Empresa(nomeEmpresa, CNPJ, telefoneUm, telefoneDois, emailEmpresa, quantidadeHectares, token, dataContrato) values
('CottonAnalytics','95050118000130','11966425489','1120405659','cottonanalytics@gmail.com', 5, 'MMQ2565','2022-10-16'),
('Tecelax Fios e Linhas', '20159881000103', '1627427190', '16989174378', 'producao@tecelaxfios.com', 3, 'HPR0304','2020-04-26'),
('Algodão10 Ltda', '26923227000100', '7728678767', '77991201926', 'administracao@algodao10ltda.com', 4, 'MWC4904','2020-06-13'),
('CottonTech','57432961000192','7127540692','71991794506','estoque@cottontech.com', 4, 'IAN9060','2021-09-09'),
('Angela Tecido', '20805268000108', '9635703421', '96998837070', 'administracao@angelatecidoltda.com', 6 , 'MVZ0586','2022-01-07');

insert into Endereco (CEP, Estado, Cidade, Bairro, Rua, Numero, Complemento, fkEmpresa) values 
	('44036398','BA','Feira de Santana','Novo Horizonte','Rua Júlio Martins', 114, 'Bloco A, 2° Andar', 1);
    

insert into Endereco (CEP, Estado, Cidade, Bairro, Rua, Numero, Complemento, fkEmpresa) values 
('78144508','MT','Várzea Grande','Petrópolis','Rua Amarilis', 2002, null, 1);

insert into Hectares (fkEndereco, localizacaoHectare) values 
	(1,'A'),
	(1,'B'),
	(1,'C'),
	(1,'D');
    
INSERT INTO Hectares (fkEndereco, localizacaoHectare) VALUES
	(2,'A'),
    (2,'B'),
    (2,'C');
    
insert into Sensor(fkHectares, statusSensor, setorSensor) values
	(1, 'Ativo', 1),
    (1, 'Ativo', 2), 
    (1, 'Ativo', 3),
    (2, 'Ativo', 1),
    (2, 'Ativo', 2), 
    (2, 'Ativo', 3),
    (5, 'Ativo', 1),
    (5, 'Ativo', 2), 
    (5, 'Ativo', 3),
    (6, 'Ativo', 1),
    (6, 'Ativo', 2),
    (6, 'Ativo', 3);

INSERT INTO dadosSensor (fkSensor, umidade, temperatura, dataDado) VALUES
    (1, 9, 23, now()),
    (2, 10, 25, now()),
    (3, 9.3, 25, now()),
    (4, 9.8, 27, now()),
    (5, 11, 28, now()),
    (6, 7, 29, now()),
    (7, 10, 27, now()),
    (8, 10, 24, now()),
    (9, 10, 24, now()),
    (10, 30, 25, now()),
    (11, 20, 24, now()),
	(12, 15, 23, now()),
    (1, 10, 26, now()),
    (2, 9, 20, now()),
    (3, 34, 29, now()),
    (4, 25, 24, now()),
    (5, 10, 32, now()),
    (6, 9, 27, now()),
    (7, 7, 29, now()),
    (8, 10, 27, now()),
    (9, 10, 24, now()),
    (10, 10, 24, now()),
    (11, 9, 27, now()),
    (12, 9, 27, now());
    
SELECT *
FROM dadosSensor
JOIN sensor
	ON sensor.idSensor = dadosSensor.fkSensor
JOIN hectares
	ON hectares.idHectares = sensor.fkHectares;
    
SELECT dadosSensor.*,
	sensor.fkHectares fk_hectar_sensor,
    hectares.*
FROM dadosSensor
JOIN sensor
	ON sensor.idSensor = dadosSensor.fkSensor
JOIN hectares
	ON sensor.fkHectares = hectares.idHectares
WHERE (dadosSensor.temperatura < 23 or dadosSensor.temperatura > 27 or dadosSensor.umidade < 9 or dadosSensor.umidade > 10)
AND hectares.fkEndereco = 1
ORDER BY dadosSensor.umidade DESC, dadosSensor.temperatura DESC;

-- PEGAR TEMP MAX MIN DE TODOS OS HECTARES (A, B, C) DE TODOS OS ENDERECOS DE UMA DETERMINADA EMPRESA
-- usar esse select ao carregar a página da dash 1
-- for para ir de registro em registro, verificando se temperatura está >=30 ou <= 20, se n estiver verificar se umidade está >= 12 ou <=7
-- se existir algum, pegar a localizacao desse hectare (A, B, C)
-- armazenar as 3 divs em um vetor
-- dentro do mesmo for, apos achar um registro crítico, modificar a div na primeira posição disponível [0, 1, 2] para o alerta correspondente
-- 
SELECT hectares.idHectares,
	hectares.localizacaoHectare,
    hectares.fkEndereco,
	MAX(dadosSensor.temperatura) max_temperatura,
	MAX(dadosSensor.umidade) max_umidade,
    MIN(dadosSensor.temperatura) min_temperatura,
    MIN(dadosSensor.umidade) min_umidade
FROM dadosSensor
JOIN sensor
	ON sensor.idSensor = dadosSensor.fkSensor
JOIN hectares
	ON hectares.idHectares = sensor.fkHectares
JOIN endereco
	ON endereco.idEndereco = hectares.fkEndereco
JOIN empresa
	ON endereco.fkEmpresa = empresa.idEmpresa
WHERE empresa.idEmpresa = 1
GROUP BY hectares.localizacaoHectare, hectares.fkEndereco;

-- MAX E MIN TEMPERATURA AGRUPADO POR SETOR E LOCALIZACAO HECTARE (A, B, C)
SELECT hectares.localizacaoHectare,
	sensor.setorSensor,
    MAX(dadosSensor.temperatura) max_temp_setor,
    MIN(dadosSensor.temperatura) min_temp_setor,
    MAX(dadosSensor.umidade) max_umid_setor,
    MIN(dadosSensor.umidade) min_umid_setor
FROM hectares
JOIN sensor
	ON hectares.idHectares = sensor.fkHectares
JOIN dadosSensor
	ON dadosSensor.fkSensor = sensor.idSensor
JOIN endereco
	ON endereco.idEndereco = hectares.fkEndereco
WHERE endereco.idEndereco = 1
GROUP BY hectares.localizacaoHectare, sensor.setorSensor
HAVING hectares.localizacaoHectare = 'A';