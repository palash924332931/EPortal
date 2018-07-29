export class Atc {
    constructor(
        public ATC_Code: string,
        public ATC_Desc: string        
    ) { }
    public static GetCodeName(): string { return "ATC_Code" };
    public static GetDescName(): string { return "ATC_Desc" };
    public static GetURLPath(): string { return "Atc" };
}

export class Atc1 {
    constructor(
        public ATC1_Code: string,
        public ATC1_Desc: string        
    ) {         
    }
    public static GetCodeName(): string { return "ATC1_Code" };
    public static GetDescName(): string { return "ATC1_Desc" };
    public static GetURLPath(): string { return "Atc1" };
}

export class Atc2 {
    constructor(
        public ATC2_Code: string,
        public ATC2_Desc: string
    ) { }
    public static GetCodeName(): string { return "ATC2_Code" };
    public static GetDescName(): string { return "ATC2_Desc" };
    public static GetURLPath(): string { return "Atc2" };
}

export class Atc3 {
    constructor(
        public ATC3_Code: string,
        public ATC3_Desc: string
    ) { }
    public static GetCodeName(): string { return "ATC3_Code" };
    public static GetDescName(): string { return "ATC3_Desc" };
    public static GetURLPath(): string { return "Atc3" };
}

export class Atc4 {
    constructor(
        public ATC4_Code: string,
        public ATC4_Desc: string
    ) { }
    public static GetCodeName(): string { return "ATC4_Code" };
    public static GetDescName(): string { return "ATC4_Desc" };
    public static GetURLPath(): string { return "Atc4" };
    public Code(): string { return this.ATC4_Code };
}

export class Nec {
    constructor(
        public NEC_Code: string,
        public NEC_Desc: string
    ) { }
    public static GetCodeName(): string { return "NEC_Code" };
    public static GetDescName(): string { return "NEC_Desc" };
    public static GetURLPath(): string { return "Nec" };
}

export class Nec1 {
    constructor(
        public NEC1_Code: string,
        public NEC1_Desc: string
    ) { }
    public static GetCodeName(): string { return "NEC1_Code" };
    public static GetDescName(): string { return "NEC1_Desc" };
    public static GetURLPath(): string { return "Nec1" };
}

export class Nec2 {
    constructor(
        public NEC2_Code: string,
        public NEC2_Desc: string
    ) { }
    public static GetCodeName(): string { return "NEC2_Code" };
    public static GetDescName(): string { return "NEC2_Desc" };
    public static GetURLPath(): string { return "Nec2" };
}

export class Nec3 {
    constructor(
        public NEC3_Code: string,
        public NEC3_Desc: string
    ) { }
    public static GetCodeName(): string { return "NEC3_Code" };
    public static GetDescName(): string { return "NEC3_Desc" };
    public static GetURLPath(): string { return "Nec3" };
}

export class Nec4 {
    constructor(
        public NEC4_Code: string,
        public NEC4_Desc: string
    ) { }
    public static GetCodeName(): string { return "NEC4_Code" };
    public static GetDescName(): string { return "NEC4_Desc" };
    public static GetURLPath(): string { return "Nec4" };
}

export class Manufacturer {
    constructor(
        public Org_Code: string,
        public Org_Abbr: string,
        public Org_Short_Name: string,
        public Org_Long_Name: string
    ) { }
    public static GetCodeName(): string { return "Org_Abbr" };
    public static GetDescName(): string { return "Org_Long_Name" };
    public static GetURLPath(): string { return "manufacturer" };
}

export class Molecule {
    constructor(
        public Molecule: number,
        public Synonym: number,
        public Parent: number,
        public Description: string
    ) { }
    public static GetCodeName(): string { return "Molecule" };
    public static GetDescName(): string { return "Description" };
    public static GetURLPath(): string { return "molecule" };
}

export class Product {
    constructor(
        public PFC: number,
        public ProductName: string
    ) { }
    public static GetCodeName(): string { return "Id" };
    public static GetDescName(): string { return "Product_Long_Name" };
    public static GetURLPath(): string { return "product" };
}

export class PackDescription {
    constructor(
        public PackDescription: string,
    ) { }
    public static GetCodeName(): string { return "PackDescription" };
    public static GetDescName(): string { return "PackDescription" };
    public static GetURLPath(): string { return "PackDescription" };
}

export class Dimension {
    constructor(
        public DimensionId: number,
        public DimensionName: string
    ) { }
    public static GetCodeName(): string { return "Id" };
    public static GetDescName(): string { return "Product_Long_Name" };
    public static GetURLPath(): string { return "product" };
}

export class PxR {
    constructor(
        public DimensionId: number,
        public DimensionName: string
    ) { }
    public static GetCodeName(): string { return "MarketCode" };
    public static GetDescName(): string { return "MarketName" };
    public static GetURLPath(): string { return "pxrcode" };
}

export class Filter {
    constructor(
        public Criteria: string,
        public Value: string,
        public Condition:string) { }    
}