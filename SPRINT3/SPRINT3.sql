#Nivell 1
/*- Exercici 1
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.
*/
		DROP TABLE IF EXISTS credit_card;
		CREATE TABLE IF NOT EXISTS credit_card (
			id VARCHAR(15) PRIMARY KEY,
			iban VARCHAR(32),
			pan VARCHAR(20),
			pin VARCHAR(4),
			cvv INT,
			expiring_date VARCHAR(8)
		);
		
	
        ALTER TABLE transaction 
		ADD CONSTRAINT fkCreditCardTransaction 
		FOREIGN KEY (credit_card_id)
		REFERENCES credit_card(id);
        

/*- Exercici 2
El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
*/
SELECT * FROM credit_card WHERE id= "CcU-2938";
UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = "CcU-2938";
SELECT * FROM credit_card WHERE id= "CcU-2938";

-/* Exercici 3
En la taula "transaction" ingressa un nou usuari amb la següent informació:
Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0
*/

INSERT INTO company (id, company_name, phone, email, country, website) 
VALUES ('b-9999', 'Corporate BCNACtiva', '06 85 84 52 33', 'bncactiva@yahoo.net', 'Spain', 'https://instagram.com/bcnactiva');

INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) 
VALUES ('CcU-9999', 'TM301950312213576817514691', '5424412569813633', '3257', '984', '10/30/22');

INSERT INTO transaction  
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999','b-9999','9999', '829.999','-117.999',NOW(),'111.11', '0');

SELECT * FROM transaction WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';


/*- Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.*/
SELECT * FROM credit_card;
ALTER TABLE credit_card
DROP COLUMN pan;
SELECT * FROM credit_card;




#Nivell 2
/*Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.*/
SELECT * FROM transaction WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";
DELETE FROM transaction WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

/*Exercici 2
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
 S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
 Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
 Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
 resenta la vista creada, ordenant les dades de major a menor mitjana de compra.
*/

CREATE VIEW VistaMarketing AS
SELECT cp.company_name, cp.phone, cp.country , avg(tr.amount) mitjaCompra 
FROM company cp 
JOIN transaction tr ON tr.company_id = cp.id 
GROUP BY cp.id ORDER BY mitjaCompra DESC; 

SELECT * FROM VistaMarketing;


/*Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
*/
SELECT * FROM VistaMarketing WHERE country = "Germany" ; 

/*Nivell 3
Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:*/

-- Canvis en la taula Company
ALTER TABLE company
DROP COLUMN website;
SELECT * FROM company;

-- Canvis en la taula user
RENAME TABLE user TO data_user;
SELECT * FROM data_user;

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;
SELECT * FROM data_user;


-- Canvi en la taula credit_card
ALTER TABLE credit_card
MODIFY id VARCHAR(20);

ALTER TABLE credit_card
MODIFY iban VARCHAR(50);

ALTER TABLE credit_card
MODIFY expiring_date VARCHAR(20);

ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE;

-- Canvi en la relacion data_user -> transaction

SHOW CREATE TABLE data_user;
SHOW CREATE TABLE transaction;

ALTER TABLE data_user
DROP FOREIGN KEY data_user_ibfk_1;

DELETE FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);

SET SQL_SAFE_UPDATES = 1;
UPDATE transaction
SET user_id = 1
WHERE user_id NOT IN (SELECT id FROM data_user);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE transaction
ADD CONSTRAINT data_user_ibfk_1 FOREIGN KEY (user_id) REFERENCES data_user(id);

/*Exercici 2
L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.*/

DROP VIEW InformeTecnico; 

CREATE VIEW InformeTecnico AS 
SELECT tr.id idtransaction, du.name, du.surname, cc.iban, cp.company_name
FROM transaction tr 
JOIN data_user du ON tr.user_id =  du.id 
JOIN credit_card cc ON tr.credit_card_id = cc.id
JOIN company cp ON tr.company_id = cp.id;

/*Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/
SELECT * FROM InformeTecnico ORDER BY idtransaction DESC;

