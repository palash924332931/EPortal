export class PopularLinks {
    constructor(
        public PopularLinkId: number,
        public PopularLinkTitle: string,
        public PopularLinkDescription: string,
        public PopularLinkFile: File
    ) {
    }
}

export class Summary {
    constructor(
        public MonthlyDataSummaryId: number,
        public MonthlyDataSummaryTitle: string,
        public MonthlyDataSummaryDescription: string
    ) {
    }
}

export class Test {
    constructor(
        public NewsAlertId: number,
        public NewsAlertTitle: string,
        public NewsAlertDescription: string
    ) {
    }
}

export class CADPages {
    constructor(
        public CADPageId: number,
        public CADPageTitle: string,
        public CADPageDescription: string
    ) {
    }
}

export class Listings {
    constructor(
        public ListingId: number,
        public ListingTitle: string,
        public ListingDescription: string
    ) {
    }
}

export class MonthlyNewProduct {
    constructor(
        public MonthlyNewProductId: number,
        public MonthlyNewProductTitle: string,
        public MonthlyNewProductDescription: string
    ) {
    }
}

export class Email {
    constructor(
        public Email: string 
    ) {
    }
}
export class Password {
    constructor(
        public Password: string
    ) {
    }
}
export class NewsAlert {
    constructor(
        public NewsAlertId: number,
        public NewsAlertTitle: string,
        public NewsAlertDescription: string
    ) {
    }
}
export class HomeContent {
    constructor(
        public Id: number,
        public Title: string,
        public Desc: string,
        public ContentType:string
    ) {
    }
}

export class HomeFile {
    constructor(
        public fileType: string,
        public fileName: string
    ) {}
}


export class PackDescSearch {
    Pack: string;
    MarketBase: string;
}

export class PackSearch {
    PFC: number;
    PackDescription: string;
    Manufacturer: string;
    ATC: string;
    NEC: string;
    Molecule: string;
    Flagging: string;
    Branding: string;
    APN: number;
    ProductName: string;
}

export class PackSearchFilter {
    ATC: SearchFilter[] = [];
    NEC: SearchFilter[] = [];
    PackDescription: SearchFilter[] = [];
    Manufacturer: SearchFilter[] = [];
    ProductDescription  : SearchFilter[] = [];
    Molecule: SearchFilter[] = [];
    Flagging: SearchFilter;
    Branding: SearchFilter;
    PFC: SearchFilter;
    APN: SearchFilter;
    Orderby: SearchFilter;
    Start: SearchFilter;
    Rows: SearchFilter;
}

export class PackDescResult {
    PFC: number;
    PackDescription: string;
    Manufacturer: string;
    ATC: string;
    NEC: string;
    Molecule: string;
    Flagging: string;
    Branding: string;
    APN: number;
    ProductName: string;
}
export class SearchFilter {
    Criteria: string;
    Value: string;
    }
export class UserPermission {
    Section: string;
    ModuleName: string;
    ActionName: string;
    Privilage: string;
    Role: string;
}
export class PackSearchResult {
    PackID: string
    Prod_cd: string
    Pack_cd: string
    PFC: string
    ProductName: string
    Product_Long_Name: string
    Pack_Description: string
    Pack_Long_Name: string
    FCC: string
    ATC1_Code: string
    ATC1_Desc: string
    ATC2_Code: string
    ATC2_Desc: string
    ATC3_Code: string
    ATC3_Desc: string
    ATC4_Code: string
    ATC4_Desc: string
    NEC1_Code: string
    NEC1_Desc: string
    NEC1_LongDesc: string
    NEC2_Code: string
    NEC2_desc: string
    NEC2_LongDesc: string
    NEC3_Code: string
    NEC3_Desc: string
    NEC3_LongDesc: string
    NEC4_Code: string
    NEC4_Desc: string
    NEC4_LongDesc: string
    CH_Segment_Code: string
    CH_Segment_Desc: string
    WHO1_Code: string
    WHO1_Desc: string
    WHO2_Code: string
    WHO2_Desc: string
    WHO3_Code: string
    WHO3_Desc: string
    WHO4_Code: string
    WHO4_Desc: string
    WHO5_Code: string
    WHO5_Desc: string
    FRM_Flgs1: string
    FRM_Flgs1_Desc: string
    FRM_Flgs2: string
    FRM_Flgs2_Desc: string
    FRM_Flgs3: string
    Frm_Flgs3_Desc: string
    FRM_Flgs4: string
    FRM_Flgs4_Desc: string
    FRM_Flgs5: string
    FRM_Flgs5_Desc: string
    FRM_Flgs6: string
    Compound_Indicator: string
    Compound_Ind_Desc: string
    PBS_Formulary: string
    PBS_Formulary_Date: string
    Poison_Schedule: string
    Poison_Schedule_Desc: string
    Stdy_Ind1_Code: string
    Study_Indicators1: string
    Stdy_Ind2_Code: string
    Study_Indicators2: string
    Stdy_Ind3_Code: string
    Study_Indicators3: string
    Stdy_Ind4_Code: string
    Study_Indicators4: string
    Stdy_Ind5_Code: string
    Study_Indicators5: string
    Stdy_Ind6_Code: string
    Study_Indicators6: string
    PackLaunch: string
    Prod_lch: string
    Org_Code: string
    Org_Abbr: string
    Org_Short_Name: string
    Org_Long_Name: string
    Out_td_dt: string
    Prtd_Price: string
    pk_size: string
    vol_wt_uns: string
    vol_wt_meas: string
    strgh_uns: string
    strgh_meas: string
    Conc_Unit: string
    Conc_Meas: string
    Additional_Strength: string
    Additional_Pack_Info: string
    Recommended_Retail_Price: string
    Ret_Price_Effective_Date: string
    Editable_Pack_Description: string
    APN: string
    Trade_Product_Pack_ID: string
    Form_Desc_Abbr: string
    Form_Desc_Short: string
    Form_Desc_Long: string
    NFC1_Code: string
    NFC1_Desc: string
    NFC2_Code: string
    NFC2_Desc: string
    NFC3_Code: string
    NFC3_Desc: string
    Price_Effective_Date: string
    Last_amd: string
    PBS_Start_Date: string
    PBS_End_Date: string
    Supplier_Code: string
    Supplier_Product_Code: string

}
export class PackResultResponse {
    recCount: number;
    packResult: PackSearchResult[];
}
export class User {
    constructor(
        public UserID: number,
        public RoleID: number,
        public RoleName: string,
        public EmailId: string,
        public username: string
    ) { }
}

export class User1 {
    constructor(
        public UserID: number,
        public RoleID: number,
        public UserTypeID: number,
        public username: string
    ) { }
}