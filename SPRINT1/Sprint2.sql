# NIVELL 1
/*Exercici 1*/
SELECT * FROM transaction;
SELECT * FROM company;

/* - Exercici 2
Utilitzant JOIN realitzaràs les següents consultes:*/
# Llistat dels països que estan fent compres.
SELECT DISTINCT cp.country FROM company cp INNER JOIN transaction tr ON cp.id = tr.company_id;

# Des de quants països es realitzen les compres.
SELECT count( DISTINCT cp.country) FROM company cp INNER JOIN transaction tr ON cp.id = tr.company_id;

# Identifica la companyia amb la mitjana més gran de vendes.*/
SELECT cp.company_name ,avg(tr.amount) FROM company cp INNER JOIN transaction tr ON cp.id = tr.company_id GROUP BY cp.id, cp.company_name ORDER BY avg(tr.amount) DESC LIMIT 1 ;

/* - Exercici 3
Utilitzant només subconsultes (sense utilitzar JOIN): */
# Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT tr.*, cp.country FROM company cp, transaction tr
WHERE cp.id = tr.company_id AND cp.country = "Germany";

# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT * FROM company cp WHERE cp.id IN (SELECT tr.company_id FROM transaction tr  WHERE tr.amount > (SELECT avg(tr.amount) FROM transaction tr));


# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT * FROM company cp
WHERE cp.id NOT IN (
    SELECT company_id
    FROM transaction
);


# NIVELL 2
/*Exercici 1
Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes . Mostra la data de cada transacció juntament amb el total de les vendes.*/
SELECT date(tr.timestamp) ,sum(tr.amount) suma FROM transaction tr WHERE tr.declined = 0 GROUP BY date(tr.timestamp) ORDER BY suma DESC limit 5; 

/*Exercici 2
Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.*/
SELECT cp.country, avg(tr.amount) FROM transaction tr INNER JOIN company cp ON cp.id = tr.company_id GROUP BY cp.country ORDER BY avg(tr.amount) DESC;


/*Exercici 3
En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/
#Mostra el llistat aplicant JOIN i subconsultes.
SELECT tr.*, cp.country 
FROM company cp 
INNER JOIN transaction tr ON cp.id = tr.company_id 
WHERE cp.country = (
	SELECT cp.country 
    FROM company cp 
    WHERE cp.company_name="Non Institute");
    
#Mostra el llistat aplicant solament subconsultes.
SELECT tr.*
FROM transaction tr 
WHERE tr.company_id IN (
    SELECT cp.id
    FROM company cp
    WHERE cp.country = (SELECT cp.country FROM company cp WHERE cp.company_name = 'Non Institute')
);

/*Nivell 3
Exercici 1
Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros 
i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. 
Ordena els resultats de major a menor quantitat.*/
SELECT cp.company_name, cp.phone, cp.country, date(tr.timestamp), tr.amount 
FROM company cp 
JOIN transaction tr ON cp.id = tr.company_id 
WHERE tr.amount BETWEEN 100 AND 200
AND date(tr.timestamp) IN ("2021-04-29", "2021-07-20", "2022-03-13")
ORDER BY tr.amount DESC;


/*Exercici 2
Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
*/
SELECT tr.company_id, count(*), CASE 
        WHEN count(*) >= 4 THEN "+ de 4"
        ELSE "- de 4" 
        END MoreThan4
        FROM transaction tr GROUP BY tr.company_id;





