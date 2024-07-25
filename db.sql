create database oniisan_AlvarezLopezNarvaez_A;

drop database oniisan_AlvarezLopezNarvaez_A;

use oniisan_AlvarezLopezNarvaez_A;

create table cliente (
ID_cliente int AUTO_INCREMENT primary key,
nombre varchar (50) not null,
apellido varchar (50) not null,
telefono varchar (50) unique not null,
correo varchar (50) unique not null,
direccion varchar (50) unique not null
);

create table empleado (
ID_empleado INT AUTO_INCREMENT PRIMARY KEY,
nombre varchar (50) not null,
apellido varchar (50) not null,
telefono varchar (50) unique not null,
correo varchar (50) unique not null,
direccion varchar (50) unique not null,
ciudad varchar (50) not null,
codigo_postal varchar (5) not null,
fecha_contrato date not null,
numero_seguro varchar (50) unique not null,
puesto varchar (50) not null,
turno varchar (50) not null,
numero_cuenta varchar (50) unique not null,
sueldo_base decimal (10,2) not null,
descuentos decimal (10,2) not null,
comision numeric (10,2) not null,
prestaciones varchar (100) not null,
capacitacion varchar (100) not null,
prestamos numeric (10,2) not null,
foto_empleado varchar (100) not null
);


create table seguro (
ID_seguro int AUTO_INCREMENT PRIMARY KEY,
proveedor varchar (50) not null,
tipo_seguro varchar (50) not null,
descripcion varchar (500),
porcentaje numeric (10,2) not null
);

-- Datos default que tendra la DB
insert into seguro(proveedor, tipo_seguro, descripcion, porcentaje) VALUES
('Chubb', 'Amplio', 'Te cubrimos los daños ocasionados a terceros si tienes un accidente manejando el auto de alguien más, siempre y cuando tenga características similares al auto asegurado.', 3),
('Chubb', 'Básico', 'Cubrimos los daños materiales y robo total. Servicios de asistencia en viaje (grúas, paso de corriente y más).', 5),
('Chubb', 'Plus', 'Deducibles más bajos: Autos 3% en Daños materiales y 5% en Robo total; y para Pick Up´s 5% en Daños materiales y 10% en Robo Total', 7);

create table auto (
Numero_serie varchar (17) unique primary key,
estado varchar (50) not null,
marca varchar (50) not null,
modelo varchar (50) not null,
año varchar (40) not null,
cilindros varchar (10) not null,
disponibilidad varchar (50) not null,
precio_base numeric (10,2) not null,
costo numeric (10,2) not null,
cantidad_puertas int not null,
color varchar (50) not null,
imagen_auto varchar (100) not null
);

CREATE TABLE ventas (
ID_venta INT AUTO_INCREMENT PRIMARY KEY,
ID_cliente INT,
Numero_serie VARCHAR(17),
ID_empleado INT,
ID_seguro INT,
metodo_pago VARCHAR(50) NOT NULL,
contado_plazo VARCHAR(50) NOT NULL,
fecha_venta DATE NOT NULL,
precio_total NUMERIC(10,2),
CONSTRAINT fk_cliente FOREIGN KEY (ID_cliente) REFERENCES cliente(ID_cliente),
CONSTRAINT fk_auto FOREIGN KEY (Numero_serie) REFERENCES auto(Numero_serie),
CONSTRAINT fk_seguro FOREIGN KEY (ID_seguro) REFERENCES seguro(ID_seguro),
CONSTRAINT fk_empleado FOREIGN KEY (ID_empleado) REFERENCES empleado(ID_empleado)
);

CREATE TABLE servicio (
ID_servicio INT AUTO_INCREMENT PRIMARY KEY,
ID_cliente INT not null,
ID_empleado INT not null,  
Numero_serie VARCHAR(17) not null,
tipo_servicio VARCHAR(500) NOT NULL,
costo_servicio NUMERIC(10,2) NOT NULL,
fecha_entrada DATE NOT NULL,
fecha_salida DATE NOT NULL,
CONSTRAINT fk_cliente_servicio FOREIGN KEY (ID_cliente) REFERENCES cliente(ID_cliente),
CONSTRAINT fk_auto_servicio  FOREIGN KEY (Numero_serie) REFERENCES auto(Numero_serie),
constraint fk_empleado_servicio FOREIGN KEY (ID_empleado) REFERENCES empleado(ID_empleado)
);

create table accounts (
id int (11) auto_increment primary key not null,
username text (50) not null,
password text (255) not null,
email text (100)  not null
);

ALTER TABLE servicio MODIFY ID_cliente INT NULL;

-- Vistas

CREATE VIEW vista_empleados AS
SELECT
    ID_empleado,
    nombre,
    apellido,
    puesto,
    turno,
    foto_empleado
FROM empleado;

CREATE VIEW vista_ventas AS
SELECT
    v.ID_venta,
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    v.ID_empleado,
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    v.Numero_serie,
    a.marca,
    a.modelo,
    a.año,
    a.color,
    s.tipo_seguro,
    v.fecha_venta
FROM
    ventas v
JOIN
    cliente c ON v.ID_cliente = c.ID_cliente
JOIN
    empleado e ON v.ID_empleado = e.ID_empleado
JOIN
    auto a ON v.Numero_serie = a.Numero_serie
JOIN
    seguro s ON v.ID_seguro = s.ID_seguro;

CREATE VIEW vista_servicios AS
SELECT
    s.ID_servicio,
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    s.ID_empleado,
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    s.Numero_serie,
    a.marca,
    a.modelo,
    a.año,
    s.tipo_servicio,
    s.fecha_entrada,
    s.fecha_salida
FROM
    servicio s
JOIN
    cliente c ON s.ID_cliente = c.ID_cliente
JOIN
    empleado e ON s.ID_empleado = e.ID_empleado
JOIN
    auto a ON s.Numero_serie = a.Numero_serie;
    
-- Roles

-- Permisos de gerente

CREATE ROLE 'Gerente';

REVOKE ALL PRIVILEGES ON *.* FROM 'Gerente';

GRANT Insert, select, update ON oniisan_alvarezlopeznarvaez_a.empleado TO 'Gerente';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.ventas TO 'Gerente';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.servicio TO 'Gerente';

GRANT insert, select, update ON oniisan_alvarezlopeznarvaez_a.auto TO 'Gerente';

-- Permisos de vendedor

CREATE ROLE 'Vendedor';

REVOKE ALL PRIVILEGES ON *.* FROM 'Vendedor';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.empleado TO 'Vendedor';

GRANT insert, select, update ON oniisan_alvarezlopeznarvaez_a.ventas TO 'Vendedor';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.auto TO 'Vendedor';

-- Permisos de maestro de carros

CREATE ROLE 'Asesor';

REVOKE ALL PRIVILEGES ON *.* FROM 'Asesor';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.empleado TO 'Asesor';

GRANT select, update ON oniisan_alvarezlopeznarvaez_a.auto TO 'Asesor';

GRANT insert, select, update ON oniisan_alvarezlopeznarvaez_a.servicio TO 'Asesor';

-- Permisos de mecánico

CREATE ROLE 'Mecanico';    

REVOKE ALL PRIVILEGES ON *.* FROM 'Mecanico';

GRANT select ON oniisan_alvarezlopeznarvaez_a.servicio TO 'Mecanico';

-- Triggers

CREATE TABLE empleado_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT,
    fecha DATETIME,
    usuario VARCHAR(100),
    puesto VARCHAR(100)
);

DELIMITER //

CREATE TRIGGER empleados_insertados
AFTER INSERT ON empleado
FOR EACH ROW
BEGIN
    INSERT INTO empleado_audit (empleado_id, fecha, usuario, puesto)
    VALUES (NEW.ID_empleado, NOW(), USER(), NEW.puesto);
END //

DELIMITER ;

CREATE TABLE disponibilidad_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Numero_serie VARCHAR(17),
    usuario VARCHAR(100),
    disponibilidad VARCHAR(50),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER auto_disponibilidad_insert
AFTER INSERT ON auto
FOR EACH ROW
BEGIN
    DECLARE disponibilidad_actual VARCHAR(50);
    SET disponibilidad_actual = NEW.disponibilidad;
    INSERT INTO disponibilidad_audit (Numero_serie, usuario, disponibilidad)
    VALUES (NEW.Numero_serie, USER(), disponibilidad_actual);
END //

CREATE TRIGGER auto_disponibilidad_update
AFTER UPDATE ON auto
FOR EACH ROW
BEGIN
    DECLARE disponibilidad_actual VARCHAR(50);
    SET disponibilidad_actual = NEW.disponibilidad;
    INSERT INTO disponibilidad_audit (Numero_serie, usuario, disponibilidad)
    VALUES (NEW.Numero_serie, USER(), disponibilidad_actual);
END //

DELIMITER ;

CREATE TABLE IF NOT EXISTS ventas_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ID_venta INT,
    nombre_vendedor VARCHAR(100),
    fecha_registro DATETIME,
    estado_venta VARCHAR(50),
    nombre_gerente VARCHAR(100)
);

DELIMITER //

CREATE TRIGGER ventas_insert_audit
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    DECLARE v_nombre_vendedor VARCHAR(100);

    -- Obtener el nombre del vendedor encargado
    SELECT CONCAT(nombre, ' ', apellido)
    INTO v_nombre_vendedor
    FROM empleado
    WHERE ID_empleado = NEW.ID_empleado;

    -- Insertar en la tabla de auditoría
    INSERT INTO ventas_audit (ID_venta, nombre_vendedor, fecha_registro, estado_venta, nombre_gerente)
    VALUES (NEW.ID_venta, v_nombre_vendedor, NOW(), 'Pendiente', NULL);
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER ventas_update_audit
AFTER UPDATE ON ventas
FOR EACH ROW
BEGIN
    DECLARE v_nombre_vendedor VARCHAR(100);
    DECLARE v_nombre_gerente VARCHAR(100);

    -- Obtener el nombre del vendedor encargado
    SELECT CONCAT(nombre, ' ', apellido)
    INTO v_nombre_vendedor
    FROM empleado
    WHERE ID_empleado = NEW.ID_empleado;

    -- Obtener el nombre del gerente que autoriza o cancela la venta
    SELECT CONCAT(nombre, ' ', apellido)
    INTO v_nombre_gerente
    FROM empleado
    WHERE ID_empleado = CURRENT_USER();

    -- Insertar en la tabla de auditoría
    INSERT INTO ventas_audit (ID_venta, nombre_vendedor, fecha_registro, estado_venta, nombre_gerente)
    VALUES (NEW.ID_venta, v_nombre_vendedor, NOW(), NEW.Estado_Venta, v_nombre_gerente);
END //

DELIMITER ;

-- Encriptación de datos

SET @key_str = 'llave_simetrica_OniiSan';

-- Procedimientos almacenados donde se encriptarán los datos necesarios

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_empleado`(IN `p_nombre` VARCHAR(100), IN `p_apellido` VARCHAR(100), IN `p_telefono` VARCHAR(20), IN `p_correo` VARCHAR(100), IN `p_direccion` VARCHAR(200), IN `p_ciudad` VARCHAR(100), IN `p_codigo_postal` VARCHAR(10), IN `p_fecha_contrato` DATE, IN `p_numero_seguro` VARCHAR(20), IN `p_puesto` VARCHAR(100), IN `p_turno` VARCHAR(50), IN `p_numero_cuenta` VARCHAR(20), IN `p_sueldo_base` DECIMAL(10,2), IN `p_descuentos` DECIMAL(10,2), IN `p_comision` DECIMAL(10,2), IN `p_prestaciones` VARCHAR(200), IN `p_capacitacion` VARCHAR(200), IN `p_prestamos` DECIMAL(10,2), IN `p_foto_empleado` VARCHAR(200))
BEGIN
    DECLARE v_username VARCHAR(200);
    DECLARE v_password VARCHAR(100);
    DECLARE v_role VARCHAR(100);

    SET @key_str = 'llave_simetrica_OniiSan';

    INSERT INTO empleado (
        nombre, apellido, telefono, correo, direccion, ciudad, codigo_postal,
        fecha_contrato, numero_seguro, puesto, turno, numero_cuenta,
        sueldo_base, descuentos, comision, prestaciones, capacitacion,
        prestamos, foto_empleado
    )
    VALUES (
        p_nombre, p_apellido, 
        AES_ENCRYPT(p_telefono, @key_str), 
        AES_ENCRYPT(p_correo, @key_str), 
        AES_ENCRYPT(p_direccion, @key_str), 
        p_ciudad, 
        AES_ENCRYPT(p_codigo_postal, @key_str), 
        p_fecha_contrato, 
        AES_ENCRYPT(p_numero_seguro, @key_str), 
        p_puesto, p_turno, 
        AES_ENCRYPT(p_numero_cuenta, @key_str), 
        AES_ENCRYPT(p_sueldo_base, @key_str), 
        AES_ENCRYPT(p_descuentos, @key_str), 
        AES_ENCRYPT(p_comision, @key_str), 
        AES_ENCRYPT(p_prestaciones, @key_str), 
        p_capacitacion, 
        AES_ENCRYPT(p_prestamos, @key_str), 
        p_foto_empleado
    );

    SET v_username = CONCAT(p_nombre, '_', p_apellido, '_', p_puesto);
    SET v_password = v_username; 

    CASE p_puesto
        WHEN 'Gerente' THEN
            SET v_role = 'Gerente';
        WHEN 'Vendedor' THEN
            SET v_role = 'Vendedor';
        WHEN 'Asesor' THEN
            SET v_role = 'Asesor';
        WHEN 'Mecánico' THEN
            SET v_role = 'Mecanico';
        ELSE
            SET v_role = NULL;
    END CASE;

    INSERT INTO accounts (username, password, email)
    VALUES (v_username, AES_ENCRYPT(v_password, @key_str), AES_ENCRYPT(p_correo, @key_str));

    IF v_role IS NOT NULL THEN
        SET @create_user_query = CONCAT('CREATE USER \'', v_username, '\'@\'localhost\' IDENTIFIED BY \'', v_password, '\';');
        SET @grant_role_query = CONCAT('GRANT ', v_role, ' TO \'', v_username, '\'@\'localhost\';');
        
        PREPARE stmt1 FROM @create_user_query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;
        
        PREPARE stmt2 FROM @grant_role_query;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;
        
        FLUSH PRIVILEGES;
    END IF;
END$$
DELIMITER ;

-- Transacción de ventas

DELIMITER $$
CREATE PROCEDURE iniciar_venta (
    IN p_ID_cliente INT,
    IN p_Numero_serie VARCHAR(17),
    IN p_ID_empleado INT,
    IN p_ID_seguro INT,
    IN p_metodo_pago VARCHAR(50),
    IN p_contado_plazo VARCHAR(50),
    IN p_fecha_venta DATE,
    IN p_precio_total NUMERIC(10,2),
    IN p_mensualidad NUMERIC(10,2),
    IN p_enganche NUMERIC(10,2),
    IN p_plazo INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    START TRANSACTION;

    INSERT INTO ventas (
        ID_cliente, Numero_serie, ID_empleado, ID_seguro, metodo_pago,
        contado_plazo, fecha_venta, precio_total, mensualidad, enganche,
        Plazo, Estado_Venta
    )
    VALUES (
        p_ID_cliente, p_Numero_serie, p_ID_empleado, p_ID_seguro, p_metodo_pago,
        p_contado_plazo, p_fecha_venta, p_precio_total, p_mensualidad, p_enganche,
        p_plazo, 'Pendiente'
    );

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE aprobar_venta (IN p_ID_venta INT)
BEGIN
    DECLARE v_Numero_serie VARCHAR(17);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT Numero_serie INTO v_Numero_serie
    FROM ventas
    WHERE ID_venta = p_ID_venta;

    UPDATE ventas
    SET Estado_Venta = 'Aprobado'
    WHERE ID_venta = p_ID_venta;
    
    UPDATE auto
    SET disponibilidad = 'Vendido'
    WHERE Numero_serie = v_Numero_serie;

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cancelar_venta (IN p_ID_venta INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE ventas
    SET Estado_Venta = 'Cancelada'
    WHERE ID_venta = p_ID_venta;

    COMMIT;
END$$
DELIMITER ;

-- Modificaciones en la tabla ventas

ALTER TABLE ventas add COLUMN mensualidad NUMERIC NULL;

ALTER TABLE ventas add COLUMN enganche NUMERIC NULL;

ALTER Table ventas add COLUMN Plazo Int NULL;

ALTER Table ventas add COLUMN Estado_Venta varchar (10) not null;

ALTER TABLE ventas add COLUMN Tipo_Venta varchar (10) not null;

