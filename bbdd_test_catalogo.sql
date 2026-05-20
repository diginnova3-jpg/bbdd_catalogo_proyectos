-- =====================================================
-- 1. EXTENSIONES (siempre primero)
-- =====================================================
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- DROP TABLE public.area_tecnologica_comercial;

CREATE TABLE public.area_tecnologica_comercial (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	descripcion text NULL,
	responsable varchar(100) NULL,
	CONSTRAINT area_tecnologica_nombre_key UNIQUE (nombre),
	CONSTRAINT area_tecnologica_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.areas_implicadas;

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


-- DROP TABLE public.auditoria;

CREATE TABLE public.auditoria (
	id serial4 NOT NULL,
	tabla_afectada varchar(50) NOT NULL,
	registro_id int4 NOT NULL,
	operacion varchar(10) NOT NULL,
	usuario varchar(100) DEFAULT CURRENT_USER NOT NULL,
	resumen text NULL,
	datos_previos jsonb NULL,
	fecha timestamp DEFAULT now() NULL,
	CONSTRAINT auditoria_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.clientes;

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


-- DROP TABLE public.cpv;

CREATE TABLE public.cpv (
	id_codigo varchar(8) NOT NULL,
	descripcion text NOT NULL,
	CONSTRAINT cpv_pkey PRIMARY KEY (id_codigo)
);


-- DROP TABLE public.empleados;

CREATE TABLE public.empleados (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	nombre varchar(200) NOT NULL,
	email varchar(200) NULL,
	cargo varchar(100) NULL,
	activo bool DEFAULT true NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	rol varchar(50) NULL,
	CONSTRAINT empleados_asana_id_key UNIQUE (asana_id),
	CONSTRAINT empleados_email_key UNIQUE (email),
	CONSTRAINT empleados_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.entidad_colaboradora;

CREATE TABLE public.entidad_colaboradora (
	id serial4 NOT NULL,
	nombre varchar(200) NOT NULL,
	CONSTRAINT entidad_colaboradora_nombre_key UNIQUE (nombre),
	CONSTRAINT entidad_colaboradora_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.linaje_datos;

CREATE TABLE public.linaje_datos (
	id serial4 NOT NULL,
	tabla_nombre varchar(50) NOT NULL,
	tabla_id int4 NOT NULL,
	id_origen_principal varchar(100) NULL,
	origenes jsonb NULL,
	date_insert timestamp NULL,
	CONSTRAINT linaje_datos_pkey PRIMARY KEY (id),
	CONSTRAINT linaje_datos_tabla_nombre_registro_id_key UNIQUE (tabla_nombre, tabla_id)
);


-- DROP TABLE public.metadata_columnas;

CREATE TABLE public.metadata_columnas (
	id serial4 NOT NULL,
	tabla_nombre varchar(50) NOT NULL,
	columna_nombre varchar(50) NOT NULL,
	descripcion text NOT NULL,
	valores_ejemplo text NULL,
	es_obligatoria bool DEFAULT true NULL,
	notas text NULL,
	creado_por varchar(100) DEFAULT CURRENT_USER NULL,
	creado_en timestamp DEFAULT now() NULL,
	actualizado_por varchar(100) NULL,
	actualizado_en timestamp NULL,
	CONSTRAINT metadata_columnas_pkey PRIMARY KEY (id),
	CONSTRAINT metadata_columnas_tabla_nombre_columna_nombre_key UNIQUE (tabla_nombre, columna_nombre)
);


-- DROP TABLE public.productos;

CREATE TABLE public.productos (
	id serial4 NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	vinculado_a_subv bool DEFAULT false NULL,
	colab_entidad bool DEFAULT false NULL,
	entidad_convoca_subv varchar(50) NULL,
	url varchar(500) NULL,
	fecha_inicio date NULL,
	fecha_finalizacion date NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	visibilidad bool DEFAULT true NULL,
	CONSTRAINT check_productos_subv_entidad CHECK (((entidad_convoca_subv IS NULL) OR ((entidad_convoca_subv)::text = ANY (ARRAY[('Ayuntamiento'::character varying)::text, ('Cabildo'::character varying)::text, ('Gobierno de Canarias'::character varying)::text, ('Gobierno de España/Ministerio'::character varying)::text, ('Unión Europea'::character varying)::text, ('Otras'::character varying)::text])))),
	CONSTRAINT producto_nombre_key UNIQUE (nombre),
	CONSTRAINT producto_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.sector_empresarial_comercial;

CREATE TABLE public.sector_empresarial_comercial (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	descripcion text NULL,
	CONSTRAINT sector_empresarial_nombre_key UNIQUE (nombre),
	CONSTRAINT sector_empresarial_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.sector_empresarial_interno;

CREATE TABLE public.sector_empresarial_interno (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	CONSTRAINT sector_empresarial_interno_nombre_key UNIQUE (nombre),
	CONSTRAINT sector_empresarial_interno_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.sedes;

CREATE TABLE public.sedes (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	es_principal bool DEFAULT false NOT NULL,
	isla varchar(50) NOT NULL,
	provincia varchar(100) NOT NULL,
	municipio varchar(100) NOT NULL,
	direccion text NOT NULL,
	codigo_postal varchar(10) NULL,
	telefono varchar(20) NULL,
	email varchar(100) NULL,
	horario text NULL,
	CONSTRAINT sedes_nombre_key UNIQUE (nombre),
	CONSTRAINT sedes_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.servicios;

CREATE TABLE public.servicios (
	id serial4 NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	vinculado_subv bool DEFAULT false NULL,
	colab_entidad bool DEFAULT false NULL,
	entidad_convoca_subv varchar(50) NULL,
	url varchar(500) NULL,
	fecha_inicio timestamp NULL,
	fecha_finalizacion timestamp NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	visibilidad bool DEFAULT true NULL,
	CONSTRAINT check_servicios_subv_entidad CHECK (((entidad_convoca_subv IS NULL) OR ((entidad_convoca_subv)::text = ANY (ARRAY[('Ayuntamiento'::character varying)::text, ('Cabildo'::character varying)::text, ('Gobierno de Canarias'::character varying)::text, ('Gobierno de España/Ministerio'::character varying)::text, ('Unión Europea'::character varying)::text, ('Otras'::character varying)::text])))),
	CONSTRAINT servicios_nombre_key UNIQUE (nombre),
	CONSTRAINT servicios_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.tecnologia_basada;

CREATE TABLE public.tecnologia_basada (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	CONSTRAINT tecnologia_basada_nombre_key UNIQUE (nombre),
	CONSTRAINT tecnologia_basada_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.trl_nivel_madurez;

CREATE TABLE public.trl_nivel_madurez (
	id serial4 NOT NULL,
	nombre varchar(100) NOT NULL,
	CONSTRAINT tlr_nombre_key UNIQUE (nombre),
	CONSTRAINT tlr_pkey PRIMARY KEY (id)
);


-- DROP TABLE public.proyectos;

CREATE TABLE public.proyectos (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	ano_ejecucion int4 NULL,
	url_demo varchar(200) NULL,
	fecha_inicio timestamp NULL,
	fecha_finalizacion timestamp NULL,
	estado_proyecto varchar(20) DEFAULT 'cerrado'::character varying NULL,
	visibilidad bool DEFAULT true NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL,
	vinculado_a_subvencion bool DEFAULT false NULL,
	entidad_convoca_subv varchar(100) NULL,
	sector_empresarial_id int4 NULL,
	cliente_id int4 NULL,
	descrip_comercial text NULL,
	trl_nivel_madurez_id int4 NULL,
	colab_entidad bool DEFAULT false NOT NULL,
	CONSTRAINT check_entidad_convoca_subv CHECK (((entidad_convoca_subv IS NULL) OR ((entidad_convoca_subv)::text = ANY (ARRAY[('Ayuntamiento'::character varying)::text, ('Cabildo'::character varying)::text, ('Gobierno de Canarias'::character varying)::text, ('Gobierno de España/Ministerio'::character varying)::text, ('Unión Europea'::character varying)::text, ('Otras'::character varying)::text])))),
	CONSTRAINT check_estado CHECK (((estado_proyecto)::text = ANY (ARRAY[('cerrado'::character varying)::text, ('reabierto'::character varying)::text]))),
	CONSTRAINT proyectos_asana_id_key UNIQUE (asana_id),
	CONSTRAINT proyectos_pkey PRIMARY KEY (id),
	CONSTRAINT proyectos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id),
	CONSTRAINT proyectos_sector_empresarial_id_fkey FOREIGN KEY (sector_empresarial_id) REFERENCES public.sector_empresarial_comercial(id),
	CONSTRAINT proyectos_trl_nivel_madurez_id_fkey FOREIGN KEY (trl_nivel_madurez_id) REFERENCES public.trl_nivel_madurez(id)
);


-- DROP TABLE public.proyectos_cpv;

CREATE TABLE public.proyectos_cpv (
	id serial4 NOT NULL,
	proyecto_id int4 NOT NULL,
	cpv_codigo varchar(8) NOT NULL,
	CONSTRAINT proyectos_cpv_pkey PRIMARY KEY (id),
	CONSTRAINT unique_proyecto_cpv UNIQUE (proyecto_id, cpv_codigo),
	CONSTRAINT fk_proyectos_cpv_cpv FOREIGN KEY (cpv_codigo) REFERENCES public.cpv(id_codigo) ON DELETE RESTRICT,
	CONSTRAINT fk_proyectos_cpv_proyecto FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE
);


-- DROP TABLE public.proyectos_empleados;

CREATE TABLE public.proyectos_empleados (
	id serial4 NOT NULL,
	proyecto_id int4 NOT NULL,
	empleado_id int4 NOT NULL,
	CONSTRAINT proyectos_empleados_pkey PRIMARY KEY (id),
	CONSTRAINT proyectos_empleados_proyecto_id_empleado_id_key UNIQUE (proyecto_id, empleado_id),
	CONSTRAINT proyectos_empleados_empleado_id_fkey FOREIGN KEY (empleado_id) REFERENCES public.empleados(id) ON DELETE CASCADE,
	CONSTRAINT proyectos_empleados_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE
);


-- DROP TABLE public.psp_entidad_colaboradora;

CREATE TABLE public.psp_entidad_colaboradora (
	proyecto_id int4 NULL,
	entidad_colaboradora_id int4 NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	producto_id int4 NULL,
	servicio_id int4 NULL,
	id serial4 NOT NULL,
	CONSTRAINT check_psp_entidad_solo_una CHECK ((((proyecto_id IS NOT NULL) AND (producto_id IS NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NOT NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NULL) AND (servicio_id IS NOT NULL)))),
	CONSTRAINT psp_entidad_colaboradora_pkey PRIMARY KEY (id),
	CONSTRAINT proyectos_entidad_colaboradora_entidad_id_fkey FOREIGN KEY (entidad_colaboradora_id) REFERENCES public.entidad_colaboradora(id) ON DELETE CASCADE,
	CONSTRAINT psp_entidad_colaboradora_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE,
	CONSTRAINT psp_entidad_colaboradora_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE,
	CONSTRAINT psp_entidad_colaboradora_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE CASCADE
);


-- DROP TABLE public.psp_sector_empresarial_interno;

CREATE TABLE public.psp_sector_empresarial_interno (
	proyecto_id int4 NULL,
	sector_empresarial_interno_id int4 NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	producto_id int4 NULL,
	servicio_id int4 NULL,
	id serial4 NOT NULL,
	CONSTRAINT check_psp_sector_solo_una CHECK ((((proyecto_id IS NOT NULL) AND (producto_id IS NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NOT NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NULL) AND (servicio_id IS NOT NULL)))),
	CONSTRAINT psp_sector_empresarial_interno_pkey PRIMARY KEY (id),
	CONSTRAINT proyectos_sector_empresarial_interno_sector_id_fkey FOREIGN KEY (sector_empresarial_interno_id) REFERENCES public.sector_empresarial_interno(id) ON DELETE CASCADE,
	CONSTRAINT psp_sector_empresarial_interno_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE,
	CONSTRAINT psp_sector_empresarial_interno_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE,
	CONSTRAINT psp_sector_empresarial_interno_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE CASCADE
);


-- DROP TABLE public.psp_tecnologia_basada;

CREATE TABLE public.psp_tecnologia_basada (
	tecnologia_basada_id int4 NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	proyecto_id int4 NULL,
	producto_id int4 NULL,
	servicio_id int4 NULL,
	id serial4 NOT NULL,
	CONSTRAINT check_solo_una_entidad CHECK ((((proyecto_id IS NOT NULL) AND (producto_id IS NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NOT NULL) AND (servicio_id IS NULL)) OR ((proyecto_id IS NULL) AND (producto_id IS NULL) AND (servicio_id IS NOT NULL)))),
	CONSTRAINT psp_tecnologia_basada_pkey PRIMARY KEY (id),
	CONSTRAINT proyectos_tecnologia_basada_tecnologia_id_fkey FOREIGN KEY (tecnologia_basada_id) REFERENCES public.tecnologia_basada(id) ON DELETE CASCADE,
	CONSTRAINT psp_tecnologia_basada_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE,
	CONSTRAINT psp_tecnologia_basada_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE,
	CONSTRAINT psp_tecnologia_basada_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicios(id) ON DELETE CASCADE
);


-- DROP TABLE public.tareas;

CREATE TABLE public.tareas (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	proyecto_id int4 NULL,
	nombre text NOT NULL,
	descripcion text NULL,
	prioridad varchar(10) NULL,
	fecha_inicio timestamp NULL,
	fecha_finalizacion timestamp NULL,
	area_implicada_id int4 NULL,
	empleado_id int4 NULL,
	created_at timestamp DEFAULT now() NULL,
	CONSTRAINT tareas_asana_id_key UNIQUE (asana_id),
	CONSTRAINT tareas_pkey PRIMARY KEY (id),
	CONSTRAINT fk_tareas_empleados FOREIGN KEY (empleado_id) REFERENCES public.empleados(id) ON DELETE SET NULL,
	CONSTRAINT tareas_area_implicada_id_fkey FOREIGN KEY (area_implicada_id) REFERENCES public.areas_implicadas(id),
	CONSTRAINT tareas_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE
);


-- DROP TABLE public.funcionalidades;

CREATE TABLE public.funcionalidades (
	id serial4 NOT NULL,
	proyecto_id int4 NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	orden int4 DEFAULT 0 NULL,
	CONSTRAINT funcionalidades_pkey PRIMARY KEY (id),
	CONSTRAINT funcionalidades_proyecto_id_nombre_key UNIQUE (proyecto_id, nombre),
	CONSTRAINT funcionalidades_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE
);

-- DROP TABLE public.proyecto_area_tecnologica;

CREATE TABLE public.proyecto_area_tecnologica (
	id serial4 NOT NULL,
	proyecto_id int4 NOT NULL,
	area_tecnologica_id int4 NOT NULL,
	CONSTRAINT proyecto_area_tecnologica_pkey PRIMARY KEY (id),
	CONSTRAINT unique_proyecto_area UNIQUE (proyecto_id, area_tecnologica_id),
	CONSTRAINT proyecto_area_tecnologica_area_tecnologica_id_fkey FOREIGN KEY (area_tecnologica_id) REFERENCES public.area_tecnologica_comercial(id) ON DELETE CASCADE,
	CONSTRAINT proyecto_area_tecnologica_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE
);


-- DROP TABLE public.subtareas;

CREATE TABLE public.subtareas (
	id serial4 NOT NULL,
	asana_id varchar(50) NOT NULL,
	tarea_id int4 NOT NULL,
	nombre varchar(200) NOT NULL,
	descripcion text NULL,
	estado varchar(25) NULL,
	fecha_inicio timestamp DEFAULT now() NULL,
	fecha_finalizacion timestamp NULL,
	horas_estimadas numeric(5, 2) NULL,
	horas_reales numeric(5, 2) NULL,
	orden int4 DEFAULT 0 NULL,
	CONSTRAINT subtareas_asana_id_key UNIQUE (asana_id),
	CONSTRAINT subtareas_pkey PRIMARY KEY (id),
	CONSTRAINT subtareas_tarea_id_fkey FOREIGN KEY (tarea_id) REFERENCES public.tareas(id) ON DELETE CASCADE
);


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

INSERT INTO sector_empresarial_comercial  (nombre, descripcion) VALUES
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


INSERT INTO area_tecnologica_comercial (nombre, descripcion, responsable) VALUES
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


INSERT INTO public.trl_nivel_madurez (nombre) VALUES
('TRL 1 - Principios básicos observados y reportados'),
('TRL 2 - Concepto y/o aplicación tecnológica formulada'),
('TRL 3 - Función crítica analítica y experimental y/o prueba de concepto característica'),
('TRL 4 - Validación de componente y/o disposición de los mismos en un entorno de laboratorio'),
('TRL 5 - Validación de componente y/o disposición de los mismos en un entorno relevante'),
('TRL 6 - Modelo de sistema o subsistema o demostración de prototipo en un entorno relevante'),
('TRL 7 - Demostración de sistema o prototipo en un entorno real'),
('TRL 8 - Sistema completo y certificado a través de pruebas y demostraciones'),
('TRL 9 - Sistema aprobado con éxito en entorno real');



INSERT INTO public.sector_empresarial_interno (nombre) VALUES
('Accesibilidad y Asistencia'),
('Aeronáutica y Espacio'),
('Agricultura y Alimentación'),
('Arquitectura, Construcción y Diseño Urbano'),
('Arte y Cultura'),
('Arte y Tecnología Digital'),
('Artes Escénicas y Eventos en Vivo'),
('Artesanía y Oficios Tradicionales'),
('Astrofísica y Observación Astronómica'),
('Automoción y Transporte Vehicular'),
('Biotecnología y Ciencias de la Vida'),
('Ciencias Ambientales y Ecología'),
('Comercio y Retail'),
('Deporte y Fitness'),
('Editorial y Publicación Digital'),
('Educación y Formación'),
('Energía y Recursos Naturales'),
('Entretenimiento y Medios de Comunicación'),
('Finanzas y Banca'),
('Gastronomía y Hostelería'),
('Geografía y Cartografía Digital'),
('Gestión de Emergencias y Respuesta a Desastres'),
('Gestión de Eventos y Espectáculos'),
('Gestión de la Información y Bibliotecología'),
('Gestión de Propiedades e Inmobiliaria'),
('Gestión de Recursos Humanos y Empleo'),
('Gestión de Residuos y Reciclaje'),
('Gobierno y Administración Pública'),
('Industria Química y Farmacéutica'),
('Industria y Manufactura'),
('Investigación y Desarrollo en Materiales'),
('Mascotas y Cuidado Animal'),
('Medio Ambiente y Sostenibilidad'),
('Moda y Diseño Textil'),
('Producción Musical'),
('Restauración y Conservación Cultural'),
('Salud y Bienestar'),
('Sector de Seguros y Gestión de Riesgos'),
('Sector Legal y Consultoría'),
('Sector Marítimo y Naval'),
('Sector Social y ONG'),
('Seguridad y Defensa'),
('Telecomunicaciones'),
('Transporte y Logística'),
('Turismo y Ocio'),
('Videojuegos y Entretenimiento Interactivo');



INSERT INTO public.tecnologia_basada (nombre) VALUES
('Automatización y Robótica'),
('Big Data'),
('Blockchain'),
('Business Intelligence'),
('Ciberseguridad'),
('Comercio Electrónico (e-commerce)'),
('Computación en la Nube Híbrida'),
('Conectividad'),
('Consultoría ERP'),
('Consultoría TI'),
('Desarrollo app'),
('Desarrollo software'),
('Desarrollo web'),
('Digital signage'),
('Diseño y fabricación digital'),
('Drones'),
('Eventos 2.0'),
('Gemelos digitales'),
('Gestión de Datos y Almacenamiento'),
('Implantación ERP'),
('Impresión 3D'),
('Industria (Industria 4.0)'),
('Ingeniería de software'),
('Inteligencia Artificial (IA)'),
('Localización de software'),
('Logística y Cadena de Suministro'),
('Marketing digital'),
('Outsourcing informático'),
('Peritajes informáticos'),
('Proyectos I+D+i'),
('Publicidad online'),
('Realidad Aumentada'),
('Realidad Virtual'),
('Seguridad Alimentaria'),
('Sensorización e Internet de las Cosas (IoT)'),
('Servicio datacenter'),
('Servicios cloud'),
('Smart Cities'),
('Tecnología Educativa (EdTech)'),
('Tecnología Financiera (FinTech)'),
('Tecnología Legal (LegalTech)'),
('Tecnología Verde, Energías Renovables y Sostenibilidad'),
('Tecnologías Médicas (E-Health)'),
('Telecomunicaciones'),
('Transformación digital');


INSERT INTO public.entidad_colaboradora (nombre) VALUES
('Clúster Excelencia Tecnológica (CET) - AEI'),
('Fundación Canaria Parque Científico Tecnológico de la Universidad de Las Palmas de Gran Canaria (FCPCT)'),
('Fundación General de la Universidad de La Laguna (FGULL)'),
('Fundación Universitaria de Las Palmas (FULP)'),
('Gobierno de Canarias'),
('Gobierno de España/Ministerios'),
('Instituto de Astrofísica de Canarias (IAC)'),
('Instituto Tecnológico de Canarias (ITC)'),
('Instituto Tecnológico y de Energías Renovables (ITER)'),
('Instituciones de la Unión Europea'),
('Parque Científico y Tecnológico de Tenerife (PCTT)'),
('Plataforma Oceánica de Canarias (PLOCAN)'),
('Sociedad Canaria de Fomento Económico (PROEXCA)'),
('Sociedad de Promoción Económica de Gran Canaria (SPEGC)'),
('Universidad de La Laguna (ULL)'),
('Universidad de Las Palmas de Gran Canaria (ULPGC)'),
('Otras');


INSERT INTO cpv (id_codigo, descripcion) VALUES
('72000000', 'Servicios TI: consultoría, desarrollo de software, Internet y apoyo'),
('72230000', 'Servicios de desarrollo de software personalizado'),
('72262000', 'Servicios de desarrollo de software'),
('72243000', 'Servicios de programación'),
('72220000', 'Servicios de consultoría en sistemas y consultoría técnica'),
('72221000', 'Servicios de consultoría en análisis de sistemas'),
('72222000', 'Servicios de planificación estratégica de sistemas de información'),
('72212000', 'Servicios de programación de software de aplicación'),
('72267000', 'Servicios de mantenimiento y reparación de software'),
('72250000', 'Servicios de sistemas y apoyo'),
('72400000', 'Servicios de Internet'),
('72413000', 'Servicios de diseño de sitios web'),
('72415000', 'Servicios de hospedaje de sitios web'),
('72416000', 'Proveedores de servicios de aplicaciones'),
('72420000', 'Servicios de desarrollo de Internet'),
('72212700', 'Utilidades de servicio de desarrollo de software');

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