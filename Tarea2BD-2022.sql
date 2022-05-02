-- Tarea 2. Juan Pablo García Vega - 000197628--

--Crear una tabla--
--Construir un query que regrese mails inválidos--

create table hero_mail (
nombre varchar (30),
mail varchar (100)
);

insert into hero_mail (nombre, mail) values
('Wanda Maximoff',	'wanda.maximoff@avengers.org'), 
('Pietro Maximoff', 'pietro@mail.sokovia.ru'),
('Erik Lensherr', 'fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier', 'i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward Stark', 'iamironman@avengers.gov'),
('Steve Rogers', 'americas_ass@anti_avengers'),
('The Vision', 'vis@westview.sword.gov'),
('Clint Barton', 'bul@lse.ye'),
('Natasha Romanov','blackwidow@kgb.ru'),
('Thor', 'god_of_thunder-^_^@royalty.asgard.gov'),
('Logan','wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe', 'ororo@weather.co'), 
('Scott Summers','o@x'),
('Nathan Summers', 'cable@xfact.or'), 
('Groot', 'iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula', 'idonthaveelektras@complex.thanos'),
('Gamora', 'thefiercestwomaninthegalaxy@thanos.'),
('Rocket', 'shhhhhhhh@darknet.ru');


--Construcción de query de mail inválido--
--Para ver que mails eran válidos, nos fijamos en si el mail se tornaba azul.
--Aceptamos mails tipo '%@%.%.%' porque pueden haber varios dominios. 
select nombre, mail from hero_mail hm
where hm.mail not like '%@%.__%' or hm.mail like '%@%.' or hm.mail like '%-^%@%';

