namespace IMS.EverestPortal.API.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ParentId : DbMigration
    {
        public override void Up()
        {
            //DropColumn("dbo.Groups", "ParentGroupNumber");
            AddColumn("dbo.Groups", "ParentGroupNumber", c => c.String());
        }

        public override void Down()
        {
            AddColumn("dbo.Groups", "ParentGroupNumber", c => c.String());
        }
    }
}
