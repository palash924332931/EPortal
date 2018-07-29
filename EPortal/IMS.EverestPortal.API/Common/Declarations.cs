using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IMS.EverestPortal.API.Common
{
    public class Declarations
    {
        public class ResponseModel
        {
            public string Value { get; set; }
            public string Text { get; set; }
        }
        public enum FieldNames
        {
            IRPClientNo = 0,
            ClientName = 1,
            ActionID = 2,
            ActionName = 3,
            Molecule = 4,
            UserID = 5,
            UserType = 6,
            MarketDefinitionID = 7,
            MarketDefinitionName = 8,
            GroupNumber = 9,
            GroupName = 10,
            Factor = 11,
            PFC = 12,
            MarketBase = 13,
            MarketBaseName = 14,
            ProductName = 15,
            Pack_Description = 16,
            ATC1_Code = 17,
            ATC1_Desc = 18, ATC2_Code = 19, ATC2_Desc = 20, ATC3_Code = 21, ATC3_Desc = 22, ATC4_Code = 23,
            ATC4_Desc = 24, NEC4_Code = 25, NEC4_Desc = 26, FRM_Flgs1 = 27, FRM_Flgs1_Desc = 28, FRM_Flgs2 = 29,
            FRM_Flgs2_Desc = 30, FRM_Flgs3 = 31, FRM_Flgs3_Desc = 32, FRM_Flgs5 = 33, FRM_Flgs5_Desc = 34,
            Form_Desc_Short = 35, Form_Desc_Long = 36, PackLaunch = 37, MFRCode = 38, MFRCodeDesc = 39, Out_td_dt = 40,
            DataRefreshType = 41, Org_Code = 42, MarketBaseType = 44, BaseFilterName = 45, prtd_price = 46,
            Description = 47,

            Org_Abbr,
            NEC1_Code,
            NEC1_LongDesc,
            NEC2_Code,
            NEC2_LongDesc,
            NEC3_Code,
            NEC3_LongDesc,
            CH_Segment_Code,
            CH_Segment_Desc,
            Poison_Schedule,
            Poison_Schedule_Desc,
            NFC1_Code,
            NFC1_Desc,
            NFC2_Code,
            NFC2_Desc,
            NFC3_Code,
            NFC3_Desc,
            APN,
            Values,

            //Allocation fields
            Name,
            FirstName,
            LastName,

            //User management fields
            Username,
            RoleName,
            IsActive,
            MaintenancePeriodEmail,
            NewsAlertEmail,
            LoginDate,

            //Releases
            Onekey,
            Id,
            PackException,
            Probe,
            Org_Long_Name,
            //Pack_Description
            CapitalChemist,
            Role,
            Active,
            EmailRemainder,
            EmailNewsAlert,

            // subsciption & Deliverables
            Country,
            Service,
            DataType,
            Source,
            TerritoryBase,
            reportWriterCode,
            reportWriterName,
            reportLevelRestrict,
            Period,
            Frequency,
            DeliveryType,
            DeliverTo,
            TerritoryDimensionID,
            TerritoryDimensionName,
            SRA_Client,
            SRA_Suffix,
            LD,
            AD,

            // Territories

            LevelNumber,
            LevelName,

            Brick,
            OutletID,
            Outl_Brk,
            OutletName,
            Addr1,
            Addr2,
            Suburb,
            State_Code,
            Postcode,
            Phone,
            XCord,
            YCord,
            BannerGroup_Desc,
            Retail_Sbrick,
            Retail_Sbrick_Desc,
            Sbrick,
            Sbrick_Desc,

            MktBaseCriteria


        }

        /// <summary>
        /// This class stores report details to generate Report
        /// </summary>
        public class RequestReport
        {
            public string[] Columns { get; set; }

            public List<ReportField> columnsToDisplay { get; set; }


            public List<ReportField> fields { get; set; }

            public string fieldsStringValues { get; set; }

            // To Find if the export is in Excel/csv format
            public string ExportType { get; set; }

            public int CurrentPage { get; set; }

            public int NumberOfRecords { get; set; }

            // Sort Column
            public string orderColumn { get; set; }
            //  Ascending /Descending
            public string orderBy { get; set; }

            public int SectionId { get; set; }
        }

        /// <summary>
        /// This class stores report Filter criteria as name- value pairs
        /// </summary>
        public class ReportField
        {
            //  uses ReportFieldList table in the database
            public int FieldID { get; set; }
            public string FieldName { get; set; }
            public string FieldDescription { get; set; }
            public string TableName { get; set; }

            // User selected values
            public List<FieldValue> fieldValues { get; set; }
            public Boolean Include { get; set; }
            public string FieldType { get; set; }

        }

        public class FieldValue
        {
            public int Id { get; set; }
            public string Text { get; set; }

            public string Value { get; set; }
        }

        public class OutletBricks
        {

            public string Name { get; set; }
            public int levelNumber { get; set; }
            public int TerritoryId { get; set; }
            public string Outlet { get; set; }

            // User selected values
            public string OutletName { get; set; }

            

        }
        public class OutletBrickAllocations
        {
            public string Name { get; set; }
            public int levelNumber { get; set; }
            public int TerritoryId { get; set; }
            public string GroupNumber { get; set; }

            public string GroupName { get; set; }

           
        }

        public class clientMarket
        {
            public string ClientNo { get; set; }
            public string ClientId { get; set; }
            public string ClientName { get; set; }
            public string MarketBaseId { get; set; }
            public string MarketbaseName { get; set; }
            public string MarketbaseType { get; set; }
            public string BaseFilterName { get; set; }
            public string BaseFilterSettings { get; set; }
            public string DataRefreshType { get; set; }
            public int MarketDefinitionId { get; set; }
            public int MarketBaseMapId { get; set; }
            public string MarketDefinitionName { get; set; }
            public int  GroupID { get; set; }
            public string GroupName { get; set; }


        }

    }
}