﻿CREATE TABLE [dbo].[vw_Everest_TXR_FeedOUT] (
    [client_name]        VARCHAR (17)  COLLATE Latin1_General_CI_AS NOT NULL,
    [client_no_MIP]      VARCHAR (3)   COLLATE Latin1_General_CI_AS NOT NULL,
    [client_no_IMS]      VARCHAR (14)  COLLATE Latin1_General_CI_AS NOT NULL,
    [geog_level]         TINYINT       NULL,
    [geog_level_name]    VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [team_code]          VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [team_name]          VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [level1_code]        VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [level1_name]        VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [level2_code]        VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [level2_name]        VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [level3_code]        VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [level3_name]        VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [level4_code]        VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [level4_name]        VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [terr_code]          VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [terr_name]          VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [subterr1_code]      VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [subterr1_name]      VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [subterr2_code]      VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [subterr2_name]      VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [brick_code]         VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [brick_name]         VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [client_defined]     VARCHAR (1)   COLLATE Latin1_General_CI_AS NULL,
    [ims_defined]        VARCHAR (1)   COLLATE Latin1_General_CI_AS NULL,
    [Blank_Field]        VARCHAR (1)   COLLATE Latin1_General_CI_AS NOT NULL,
    [geog_code]          VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [geog_name]          VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [parent_geog_code]   VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [parent_geog_name]   VARCHAR (250) COLLATE Latin1_General_CI_AS NULL,
    [parent_geog_level]  TINYINT       NULL,
    [IMS_structure_code] VARCHAR (50)  COLLATE Latin1_General_CI_AS NULL,
    [txr_source]         VARCHAR (12)  COLLATE Latin1_General_CI_AS NOT NULL,
    [txr_exclude_flag]   VARCHAR (1)   COLLATE Latin1_General_CI_AS NOT NULL,
    [notes]              VARCHAR (30)  COLLATE Latin1_General_CI_AS NOT NULL
);

