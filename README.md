# Oracle Database XE 21c — Docker Compose

Configuración para levantar Oracle Database Express Edition 21c en Docker, lista para desarrollo local en Windows con WSL2.

## Requisitos previos

- Docker Desktop con WSL2 habilitado
- Cuenta en [Oracle Container Registry](https://container-registry.oracle.com)

## Pasos para levantar Oracle XE

### 1. Iniciar sesión en Oracle Container Registry

```bash
docker login container-registry.oracle.com
```

Ingresa tu email y **auth token** de Oracle (no la contraseña de la cuenta).
El auth token se genera en tu perfil de Oracle Container Registry.

> Si intentas usar la contraseña normal recibirás `Auth failed`. Debes usar el auth token.

### 2. Configurar variables de entorno

```bash
cp .env.example .env
```

Edita `.env` y establece tu contraseña para Oracle.

### 3. Levantar el contenedor

```bash
docker compose up -d
```

La primera vez descarga la imagen (~3 GB). Monitorea el progreso:

```bash
docker compose logs -f oracle-xe
```

Espera hasta ver:

```
DATABASE IS READY TO USE!
```

## Conexión

### Desde SQL Developer o DBeaver (Windows)

| Parámetro    | Valor      |
|--------------|------------|
| Host         | `localhost` |
| Puerto       | `1521`     |
| Tipo         | Service Name |
| Service Name | `xepdb1`   |
| Usuario      | `system`   |
| Contraseña   | valor de `ORACLE_PWD` en `.env` |

> **Importante:** El service name es `xepdb1` en **minúsculas**. Usar `XEPDB1` causa el error `ORA-12514`.

> Los puertos de WSL2 se reenvían automáticamente a Windows, por lo que `localhost` funciona desde SQL Developer o DBeaver instalados en Windows.

### Desde SQL*Plus (dentro del contenedor)

```bash
docker exec -it oracle-xe sqlplus system/<password>@//localhost:1521/xepdb1
```

### Enterprise Manager Express

```
https://localhost:5500/em
```

## Gestión del contenedor

```bash
# Ver estado
docker compose ps

# Detener (los datos persisten)
docker compose stop

# Volver a iniciar
docker compose start

# Eliminar contenedor (los datos persisten en el volumen)
docker compose down

# Eliminar contenedor y datos
docker compose down -v
```

## Estructura

```
.
├── docker-compose.yml
├── .env                        # Variables de entorno (no subir a git)
├── .env.example                # Plantilla de variables de entorno
├── README.md
└── scripts/
    ├── setup/                  # Se ejecutan una vez al inicializar la BD
    │   └── 01_create_user.sql
    └── startup/                # Se ejecutan en cada arranque del contenedor
```

## Notas

- La imagen es `container-registry.oracle.com/database/express:21.3.0-xe`
- El PDB por defecto se llama `xepdb1`
- Los datos persisten en el volumen Docker `oracle-data`
- La contraseña aplica para los usuarios `SYS`, `SYSTEM` y `PDBADMIN`
