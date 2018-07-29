namespace IMS.EverestPortal.API.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ModelChangesAndNamingChanges : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.MonthlyNewProducts", "monthlyNewProductCreatedOn", c => c.DateTime());
            AlterColumn("dbo.MonthlyNewProducts", "monthlyNewProductModifiedOn", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.MonthlyNewProducts", "monthlyNewProductModifiedOn", c => c.DateTime(nullable: false));
            AlterColumn("dbo.MonthlyNewProducts", "monthlyNewProductCreatedOn", c => c.DateTime(nullable: false));
        }
    }
}
