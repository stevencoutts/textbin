PGDMP                         }            textbin     15.13 (Debian 15.13-1.pgdg120+1)     15.13 (Debian 15.13-1.pgdg120+1) 
               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16384    textbin    DATABASE     r   CREATE DATABASE textbin WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE textbin;
                textbin    false            �            1259    16404    Paste    TABLE     �   CREATE TABLE public."Paste" (
    id text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public."Paste";
       public         heap    textbin    false            �            1259    16395    _prisma_migrations    TABLE     �  CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);
 &   DROP TABLE public._prisma_migrations;
       public         heap    textbin    false                      0    16404    Paste 
   TABLE DATA           B   COPY public."Paste" (id, title, content, "createdAt") FROM stdin;
    public          textbin    false    215                      0    16395    _prisma_migrations 
   TABLE DATA           �   COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
    public          textbin    false    214            �           2606    16411    Paste Paste_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public."Paste"
    ADD CONSTRAINT "Paste_pkey" PRIMARY KEY (id);
 >   ALTER TABLE ONLY public."Paste" DROP CONSTRAINT "Paste_pkey";
       public            textbin    false    215            �           2606    16403 *   _prisma_migrations _prisma_migrations_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public._prisma_migrations DROP CONSTRAINT _prisma_migrations_pkey;
       public            textbin    false    214               ^   x�Ʊ� ��`�3'_�p k�A��J#����IF�KO�4Hʈ��Gd��ϧ�[r�b������iij<�@ɳ�41��ص�־A��         �   x�m�=
�0@�9>E�� ɒe�=A��G�,�z�d.���B�5��<gd/5��=R6��"�dI�j�4�c˦��s'A�1���%p�d�LČ+�s&lI�	P6�p����	p_�PRAz��쯫���r�5���A.�     