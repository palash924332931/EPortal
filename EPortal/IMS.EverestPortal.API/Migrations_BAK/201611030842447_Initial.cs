namespace IMS.EverestPortal.API.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.CADPages",
                c => new
                    {
                        cadPageId = c.Int(nullable: false, identity: true),
                        cadPageTitle = c.String(),
                        cadPageDescription = c.String(),
                        cadPagePharmacyFileUrl = c.String(),
                        cadPageHospitalFileUrl = c.String(),
                        cadPageCreatedOn = c.DateTime(),
                        cadPageCreatedBy = c.String(),
                        cadPageModifiedOn = c.DateTime(),
                        cadPageModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.cadPageId);
            
            CreateTable(
                "dbo.Listings",
                c => new
                    {
                        listingId = c.Int(nullable: false, identity: true),
                        listingTitle = c.String(),
                        listingDescription = c.String(),
                        listingPharmacyFileUrl = c.String(),
                        listingHospitalFileUrl = c.String(),
                        listingCreatedOn = c.DateTime(),
                        listingCreatedBy = c.String(),
                        listingModifiedOn = c.DateTime(),
                        listingModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.listingId);
            
            CreateTable(
                "dbo.MonthlyNewproducts",
                c => new
                    {
                        monthlyNewProductId = c.Int(nullable: false, identity: true),
                        monthlyNewProductTitle = c.String(),
                        monthlyNewProductDescription = c.String(),
                        monthlyNewProductFileUrl = c.String(),
                        monthlyNewProductCreatedOn = c.DateTime(nullable: false),
                        monthlyNewProductCreatedBy = c.String(),
                        monthlyNewProductModifiedOn = c.DateTime(nullable: false),
                        monthlyNewProductModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.monthlyNewProductId);
            
            CreateTable(
                "dbo.MonthlyDataSummaries",
                c => new
                    {
                        monthlyDataSummaryId = c.Int(nullable: false, identity: true),
                        monthlyDataSummaryTitle = c.String(),
                        monthlyDataSummaryDescription = c.String(),
                        monthlyDataSummaryFileUrl = c.String(),
                        monthlyDataSummaryCreatedOn = c.DateTime(),
                        monthlyDataSummaryCreatedBy = c.String(),
                        monthlyDataSummaryModifiedOn = c.DateTime(),
                        monthlyDataSummaryModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.monthlyDataSummaryId);
            
            CreateTable(
                "dbo.NewsAlerts",
                c => new
                    {
                        newsAlertId = c.Int(nullable: false, identity: true),
                        newsAlertTitle = c.String(),
                        newsAlertDescription = c.String(),
                        newsAlertImageUrl = c.String(),
                        newsAlertAltImage = c.String(),
                        newsAlertCreatedOn = c.DateTime(),
                        newsAlertCreatedBy = c.String(),
                        newsAlertModifiedOn = c.DateTime(),
                        newsAlertModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.newsAlertId);
            
            CreateTable(
                "dbo.PopularLinks",
                c => new
                    {
                        popularLinkId = c.Int(nullable: false, identity: true),
                        popularLinkTitle = c.String(),
                        popularLinkDescription = c.String(),
                        popularLinkDisplayOrder = c.Short(nullable: false),
                        popularLinkCreatedOn = c.DateTime(),
                        popularLinkCreatedBy = c.String(),
                        popularLinkModifiedOn = c.DateTime(),
                        popularLinkModifiedBy = c.String(),
                    })
                .PrimaryKey(t => t.popularLinkId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.PopularLinks");
            DropTable("dbo.NewsAlerts");
            DropTable("dbo.MonthlyDataSummaries");
            DropTable("dbo.MonthlyNewproducts");
            DropTable("dbo.Listings");
            DropTable("dbo.CADPages");
        }
    }
}
