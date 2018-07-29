CREATE TABLE [dbo].[Brick_XYCords] (
    [ID]            INT            NOT NULL,
    [Retail_Sbrick] CHAR (5)       NULL,
    [postcode]      SMALLINT       NULL,
    [suburb]        VARCHAR (30)   NULL,
    [NumberOutlets] INT            NULL,
    [max_XCord]     DECIMAL (9, 6) NULL,
    [max_YCord]     DECIMAL (9, 6) NULL
);

