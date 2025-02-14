-- Nivell 1
/*- Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.
*/
SELECT * FROM users WHERE id IN (
SELECT user_id FROM transactions GROUP BY user_id HAVING count(*) > 30); 

/*- Exercici 2
Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
*/
SELECT coalesce(round(avg(amount),2)) 
FROM transactions tt 
JOIN credit_cards cc ON tt.card_id = cc.id 
WHERE tt.business_id = (
		SELECT company_id 
        FROM companies 
        WHERE company_name = "Donec Ltd"
        AND declined = 0) 
GROUP BY iban;  


/*Nivell 2
Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:*/
CREATE TABLE ActiveCard (
  id VARCHAR(20) PRIMARY KEY,
  status VARCHAR(50),
  CONSTRAINT FK_CreditCardStatus FOREIGN KEY (id) REFERENCES credit_cards(id)
);


INSERT INTO activecard (id, status)
SELECT card_id, CASE WHEN sum(tr.declined) = 3 THEN  lower("Desactiva") 
                ELSE  lower("Activa") END ESTADO FROM (
SELECT * ,
        ROW_NUMBER() OVER (PARTITION BY transactions.card_id ORDER BY transactions.timestamp DESC) ordenTr
        FROM transactions) as tr WHERE tr.ordenTr BETWEEN 1 AND 3 GROUP BY card_id;

SELECT * FROM activecard;

-- ---------------------
/*Exercici 1
Quantes targetes estan actives?*/
SELECT count(*) tarjetasActives FROM activecard WHERE status= lower("Activa" ) GROUP BY status;

/*Nivell 3
Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
tenint en compte que des de transaction tens product_ids. Genera la següent consulta:*/
DROP table products;
CREATE TABLE products(
	id VARCHAR(100) PRIMARY KEY,
    product_name VARCHAR(200),
    price VARCHAR(10)	,
    colour CHAR(7),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv' 
INTO TABLE products 
FIELDS TERMINATED BY ',' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE tr_products (
    tr_id VARCHAR(255),
    product_id VARCHAR(100),
    FOREIGN KEY (tr_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);



INSERT INTO tr_products (tr_id, product_id)
SELECT transactions.id AS tr_id, products.id AS product_id
FROM transactions
JOIN products
    ON FIND_IN_SET(CAST(products.id AS CHAR), REPLACE(transactions.product_ids,' ', '')) > 0;

SELECT * FROM tr_products;



/*Exercici 1
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/
SELECT product_name, COUNT(trp.tr_id) ventasproducto
FROM tr_products trp
    JOIN products pr
    ON trp.product_id = pr.id
GROUP BY pr.id;















