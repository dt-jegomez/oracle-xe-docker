-- Script de configuración inicial (se ejecuta una sola vez al crear la BD)
-- Conectar al PDB por defecto de XE
ALTER SESSION SET CONTAINER = XEPDB1;

-- Crear un usuario de aplicación de ejemplo
CREATE USER app_user IDENTIFIED BY "AppUser123"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO app_user;
GRANT CREATE SESSION TO app_user;

COMMIT;
