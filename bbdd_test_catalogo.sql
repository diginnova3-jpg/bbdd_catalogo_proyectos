-- =====================================================
-- 1. EXTENSIONES (siempre primero)
-- =====================================================
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 2. TABLAS SIN DEPENDENCIAS (no tienen FOREIGN KEY)
-- =====================================================

-- Tabla de sectores
CREATE TABLE public.sector_empresarial (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla de áreas tecnológicas
CREATE TABLE area_tecnologica (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    responsable VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW(),	
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de auditoría (no depende de nadie)
CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INTEGER NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    usuario VARCHAR(100) NOT NULL DEFAULT current_user,
    resumen TEXT,
    datos_previos JSONB,
    fecha TIMESTAMP DEFAULT NOW()
);

-- Tabla de metadatos (no depende de nadie)
CREATE TABLE metadata_columnas (
    id SERIAL PRIMARY KEY,
    tabla_nombre VARCHAR(50) NOT NULL,
    columna_nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    valores_ejemplo TEXT,
    es_obligatoria BOOLEAN DEFAULT true,
    notas TEXT,
    creado_por VARCHAR(100) DEFAULT current_user,
    creado_en TIMESTAMP DEFAULT NOW(),
    actualizado_por VARCHAR(100),
    actualizado_en TIMESTAMP,
    UNIQUE(tabla_nombre, columna_nombre)
);

-- Tabla de linaje (no depende de nadie, solo guarda IDs)
CREATE TABLE linaje_datos (
    id SERIAL PRIMARY KEY,
    tabla_nombre VARCHAR(50) NOT NULL,
    registro_id INTEGER NOT NULL,
    origen_principal VARCHAR(30) NOT NULL,
    id_origen_principal VARCHAR(100),
    columnas_manuales TEXT[],
    ultimo_editado_por VARCHAR(100),
    ultima_edicion TIMESTAMP,
    UNIQUE(tabla_nombre, registro_id)
);

-- Tabla de clientes 
CREATE TABLE public.clientes (
	id serial4 NOT NULL,
	nombre varchar(200) NOT NULL,
	cif varchar(20) NULL,
	email_contacto varchar(200) NULL,
	telefono varchar(50) NULL,
	direccion text NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	CONSTRAINT clientes_cif_key UNIQUE (cif),
	CONSTRAINT clientes_nombre_key UNIQUE (nombre),
	CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

-- Tabla de areas implicadas
CREATE TABLE public.areas_implicadas (
	id serial4 NOT NULL,
	nombre varchar(50) NOT NULL,
	descripcion text NULL,
	orden int4 DEFAULT 0 NULL,
	activa bool DEFAULT true NULL,
	created_at timestamp DEFAULT now() NULL,
	CONSTRAINT areas_implicadas_nombre_key UNIQUE (nombre),
	CONSTRAINT areas_implicadas_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 3. TABLA PROYECTOS (depende de sector_empresarial y area_tecnologica)
-- =====================================================
CREATE TABLE public.proyectos (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	tecnologias _text DEFAULT '{}'::text[] NULL,
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
	entidad_convoca_subv varchar(100) NULL,
	area_tecnologica_id int4 NULL,
	sector_empresarial_id int4 NULL,
	cliente_id int4 NULL,
	CONSTRAINT check_entidad_convoca_subv CHECK (((entidad_convoca_subv IS NULL) OR ((entidad_convoca_subv)::text = ANY ((ARRAY['Ayuntamiento'::character varying, 'Cabildo'::character varying, 'Gobierno de Canarias'::character varying, 'Gobierno de España/Ministerio'::character varying, 'Unión Europea'::character varying, 'Otras'::character varying])::text[])))),
	CONSTRAINT check_estado CHECK (((estado_proyecto)::text = ANY ((ARRAY['cerrado'::character varying, 'reabierto'::character varying])::text[]))),
	CONSTRAINT check_visibilidad CHECK (((visibilidad)::text = ANY ((ARRAY['publico'::character varying, 'interno'::character varying, 'privado'::character varying])::text[]))),
	CONSTRAINT proyectos_asana_id_key UNIQUE (asana_id),
	CONSTRAINT proyectos_pkey PRIMARY KEY (id)
);

ALTER TABLE public.proyectos ADD CONSTRAINT proyectos_area_tecnologica_id_fkey FOREIGN KEY (area_tecnologica_id) REFERENCES public.area_tecnologica(id);
ALTER TABLE public.proyectos ADD CONSTRAINT proyectos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);
ALTER TABLE public.proyectos ADD CONSTRAINT proyectos_sector_empresarial_id_fkey FOREIGN KEY (sector_empresarial_id) REFERENCES public.sector_empresarial(id);




-- =====================================================
-- 4. TABLA TAREAS (depende de proyectos y area_implicadas)
-- =====================================================
CREATE TABLE public.tareas (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	proyecto_id int4 NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	prioridad varchar(10) NULL,
	asignado_a varchar(100) NULL,
	fecha_creacion timestamp NULL,
	fecha_completado timestamp NULL,
	embedding public.vector NULL,
	area_implicada_id int4 NULL,
	CONSTRAINT tareas_asana_id_key UNIQUE (asana_id),
	CONSTRAINT tareas_pkey PRIMARY KEY (id)
);

ALTER TABLE public.tareas ADD CONSTRAINT tareas_area_implicada_id_fkey FOREIGN KEY (area_implicada_id) REFERENCES public.areas_implicadas(id);
ALTER TABLE public.tareas ADD CONSTRAINT tareas_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE;



INSERT INTO areas_implicadas (nombre, descripcion, orden) VALUES
('Desarrollo', 'Desarrollo de software y programación', 1),
('Diseño', 'Diseño gráfico, UI/UX y experiencia de usuario', 2),
('Consultoría', 'Consultoría técnica y estratégica', 3),
('Sistemas', 'Administración de sistemas e infraestructura', 4),
('Marketing - SEO - SEM', 'Marketing digital, posicionamiento y publicidad', 5),
('Administración Empresa', 'Gestión administrativa y empresarial', 6),
('Maquetación', 'Maquetación HTML/CSS y diseño web', 7),
('Seguridad', 'Ciberseguridad y auditoría', 8),
('IA', 'Inteligencia Artificial y Machine Learning', 9),
('RRSS', 'Redes Sociales y community management', 10);

INSERT INTO sector_empresarial (nombre, descripcion) VALUES
('Sector Salud', 'Sanidad, hospitales, clínicas, salud digital y farmacéutica'),
('Sector Público', 'Administraciones públicas, organismos gubernamentales y ayuntamientos'),
('Retail y consumo masivo', 'E-commerce, marcas de consumo, comercio minorista y grandes superficies'),
('Industria y manufactura', 'Fábricas, plantas de producción, industria pesada y ligera'),
('Banca y Finanzas', 'Entidades bancarias, seguros, fintech y servicios financieros'),
('Energía y Servicios públicos', 'Eléctricas, gas, agua, energías renovables y utilities'),
('Educación', 'Centros educativos, universidades, formación online y edtech'),
('Telecomunicaciones y medios', 'Operadoras, agencias de publicidad, medios de comunicación y telcos'),
('Transporte y Logística', 'Logística, distribución, transporte de mercancías y personas'),
('Startups y Pequeñas empresas', 'Empresas emergentes, pymes y negocios en fase de crecimiento');


INSERT INTO area_tecnologica (nombre, descripcion, responsable) VALUES
('Desarrollo Web y E-commerce', 'Desarrollo de aplicaciones web, portales, tiendas online y plataformas de comercio electrónico', NULL),
('Desarrollo móvil', 'Desarrollo de aplicaciones para iOS, Android y multiplataforma', NULL),
('QA', 'Pruebas de software, control de calidad, automatización de pruebas y aseguramiento de calidad', NULL),
('Diseño UX/UI', 'Diseño de experiencia de usuario, interfaz de usuario, investigación y prototipado', NULL),
('IA y machine learning', 'Inteligencia artificial, modelos predictivos, procesamiento de lenguaje natural, RAG (Retrieval-Augmented Generation), LLM (Large Language Models), visión por computadora y sistemas de recomendación', NULL),
('Cloud & DevOps', 'Infraestructura cloud, CI/CD, contenedores, orquestación y automatización de despliegues', NULL),
('Datos & Analítica', 'Data warehouses, ETL, business intelligence, análisis de datos y visualización', NULL),
('Automatizaciones', 'Automatización de procesos, RPA, integraciones y flujos de trabajo automatizados', NULL),
('Realidad virtual (VR)', 'Desarrollo de experiencias inmersivas, entornos virtuales y simulaciones 3D', NULL),
('Realidad aumentada (AR)', 'Desarrollo de aplicaciones con superposición de elementos virtuales en el mundo real', NULL)












-- =====================================================
-- 5. ÍNDICES RECOMENDADOS (opcional pero mejora rendimiento)
-- =====================================================

-- Índice para búsquedas en auditoría
CREATE INDEX idx_auditoria_busqueda ON auditoria (tabla_afectada, registro_id, fecha);

-- Índice para búsquedas en linaje
CREATE INDEX idx_linaje_busqueda ON linaje_datos (tabla_nombre, registro_id);

-- Índice para búsquedas en proyectos
CREATE INDEX idx_proyectos_visibilidad ON proyectos (visibilidad, estado_proyecto);
CREATE INDEX idx_proyectos_fechas ON proyectos (fecha_inicio, fecha_fin);
CREATE INDEX idx_proyectos_asana ON proyectos (asana_id);

-- Índice para búsquedas en tareas
CREATE INDEX idx_tareas_proyecto ON tareas (proyecto_id);
CREATE INDEX idx_tareas_asana ON tareas (asana_id);

-- Índice vectorial para búsqueda semántica (opcional, mejora rendimiento de RAG)
-- CREATE INDEX idx_proyectos_embedding ON proyectos USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
-- CREATE INDEX idx_tareas_embedding ON tareas USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- =====================================================
-- 6. COMENTARIOS PARA DOCUMENTACIÓN (opcional)
-- =====================================================

COMMENT ON TABLE public.sector_empresarial IS 'Sectores empresariales: salud, retail, banca, sector público, etc.';
COMMENT ON TABLE area_tecnologica IS 'Áreas tecnológicas: IA, Blockchain, Web, E-commerce, Desarrollo móvil, etc.';
COMMENT ON TABLE public.proyectos IS 'Proyectos cerrados o reabiertos. Contiene embedding para búsqueda semántica.';
COMMENT ON TABLE tareas IS 'Tareas asociadas a proyectos, importadas desde Asana.';
COMMENT ON TABLE auditoria IS 'Registro de trazabilidad: quién, cuándo y qué cambió en cada tabla.';
COMMENT ON TABLE metadata_columnas IS 'Diccionario de datos: documentación de cada columna de la BD.';
COMMENT ON TABLE linaje_datos IS 'Origen de los datos: qué vino de Asana, Holded, qué se editó manualmente.';