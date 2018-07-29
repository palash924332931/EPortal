﻿CREATE TABLE [dbo].[HISTORY_TDW-ECP_DIM_OUTLET] (
    [OutletID]           INT            NOT NULL,
    [PostCode]           INT            NULL,
    [Outlet]             SMALLINT       NULL,
    [Outl_Brk]           VARCHAR (8)    NULL,
    [EID]                INT            NULL,
    [AID]                TINYINT        NULL,
    [Name]               VARCHAR (80)   NULL,
    [FullAddr]           VARCHAR (400)  NULL,
    [Addr1]              VARCHAR (200)  NULL,
    [Addr2]              VARCHAR (100)  NULL,
    [Suburb]             VARCHAR (100)  NULL,
    [Phone]              VARCHAR (15)   NULL,
    [XCord]              DECIMAL (9, 6) NULL,
    [YCord]              DECIMAL (9, 6) NULL,
    [Entity_Type]        CHAR (30)      NULL,
    [Display]            VARCHAR (30)   NULL,
    [BannerGroup_Desc]   VARCHAR (500)  NULL,
    [Retail_Sbrick]      CHAR (30)      NULL,
    [Retail_Sbrick_Desc] VARCHAR (80)   NULL,
    [Sbrick]             CHAR (30)      NULL,
    [Sbrick_Desc]        VARCHAR (80)   NULL,
    [State_Code]         VARCHAR (40)   NULL,
    [Out_Type]           VARCHAR (20)   NULL,
    [Outlet_Type_Desc]   VARCHAR (80)   NULL,
    [Inactive_Date]      DATETIME2 (7)  NULL,
    [Active_Date]        DATETIME2 (7)  NULL,
    [CHANGE_FLAG]        VARCHAR (1)    NULL,
    [TIME_STAMP]         DATETIME       NULL,
    [BRICK_CHANGE_FLAG]  VARCHAR (1)    NULL,
    [BRICK_TIME_STAMP]   DATETIME       NULL
);

