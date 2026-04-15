
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE public.proyectos (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	tecnologias _text DEFAULT '{}'::text[] NULL,
	cliente varchar(100) NULL,
	ano_ejecucion int4 NULL,
	url_demo varchar(200) NULL,
	fecha_inicio date NULL,
	fecha_fin date NULL,
	estado_proyecto varchar(20) DEFAULT 'cerrado'::character varying NULL,
	visibilidad varchar(20) DEFAULT 'interno'::character varying NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	embedding public.vector NULL,
	vinculado_a_subvencion bool DEFAULT false NULL,
	entidad_convoca_subv varchar(50) NULL,
	sector_empresarial varchar(150) NULL,
	categoria_tecnologica varchar(200) NULL,
	CONSTRAINT check_entidad_convoca_subv CHECK (((entidad_convoca_subv IS NULL) OR ((entidad_convoca_subv)::text = ANY ((ARRAY['Ayuntamiento'::character varying, 'Cabildo'::character varying, 'Gobierno de Canarias'::character varying, 'Gobierno de España/Ministerio'::character varying, 'Unión Europea'::character varying, 'Otras'::character varying])::text[])))),
	CONSTRAINT check_estado CHECK (((estado_proyecto)::text = ANY ((ARRAY['cerrado'::character varying, 'reabierto'::character varying])::text[]))),
	CONSTRAINT check_visibilidad CHECK (((visibilidad)::text = ANY ((ARRAY['publico'::character varying, 'interno'::character varying, 'privado'::character varying])::text[]))),
	CONSTRAINT proyectos_asana_id_key UNIQUE (asana_id),
	CONSTRAINT proyectos_pkey PRIMARY KEY (id)
);



-- Tabla de áreas (normalización)
CREATE TABLE area_tecnologica (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    responsable VARCHAR(100)
);


CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    asana_id VARCHAR(50) UNIQUE NOT NULL,
    proyecto_id INTEGER REFERENCES proyectos(id) ON DELETE CASCADE,
    area_id INTEGER REFERENCES area_tecnologica(id),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'pendiente',
    prioridad VARCHAR(10),  -- alta, media, baja
    asignado_a VARCHAR(100),  -- Nombre o email del responsable
    fecha_creacion TIMESTAMP,
    fecha_completado TIMESTAMP,
    horas_estimadas DECIMAL(5,2),
    horas_reales DECIMAL(5,2),
    areas_implicadas varchar(100),  
    embedding vector(1536),  -- Embedding de la tarea (opcional)
    
    CONSTRAINT check_estado_tarea CHECK (estado IN ('pendiente', 'en_progreso', 'completada', 'bloqueada', 'cancelada'))
);

