using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using IMS.EverestPortal.API.Models;
using System.Data.Entity.ModelConfiguration.Conventions;
using IMS.EverestPortal.API.Models.Territory;
using IMS.EverestPortal.API.Models.Security;
using IMS.EverestPortal.API.Models.Subscription;
using System.ComponentModel.DataAnnotations.Schema;
using IMS.EverestPortal.API.Models.Deliverable;
using IMS.EverestPortal.API.Models.Report;
using IMS.EverestPortal.API.Models.Audit;
using IMS.EverestPortal.API.Models.Grouping;
using IMS.EverestPortal.API.Common;
//testing

namespace IMS.EverestPortal.API.DAL
{
    public class EverestPortalContext : DbContext
    {
        public EverestPortalContext()
            : base("EverestPortalConnection")
        {

        }

        public DbSet<CADPage> CADPages { get; set; }
        public DbSet<Listing> Listings { get; set; }
        public DbSet<MonthlyDataSummary> MonthlyDataSummaries { get; set; }
        public DbSet<MonthlyNewProduct> MonthlyNewProducts { get; set; }
        public DbSet<NewsAlert> NewsAlerts { get; set; }
        public DbSet<PopularLink> PopularLinks { get; set; }



        public DbSet<User> Users { get; set; }

        public System.Data.Entity.DbSet<BaseFilter> BaseFilters { get; set; }
        public System.Data.Entity.DbSet<AdditionalFilter> AdditionalFilters { get; set; }
        public System.Data.Entity.DbSet<MarketBase> MarketBases { get; set; }
        public System.Data.Entity.DbSet<MarketDefinitionBaseMap> MarketDefinitionBaseMaps { get; set; }
        public System.Data.Entity.DbSet<MarketDefinition> MarketDefinitions { get; set; }
        public System.Data.Entity.DbSet<MarketDefinitionPack> MarketDefinitionPacks { get; set; }
        public System.Data.Entity.DbSet<Client> Clients { get; set; }
        public System.Data.Entity.DbSet<Pack> Packs { get; set; }
		public System.Data.Entity.DbSet<LockHistory> LockHistories { get; set; }

        //Market Base
        public System.Data.Entity.DbSet<ClientMarketBases> ClientMarketBases { get; set; }


        public DbSet<AccessPrivilege> AccessPrivileges { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Module> Modules { get; set; }
        public DbSet<Models.Security.Action> Actions { get; set; }
        public DbSet<RoleAction> RoleActions { get; set; }
        public DbSet<Section> Sections { get; set; }

        public DbSet<UserType> userType { get; set; }
        public DbSet<UserRole> userRole { get; set; }
        public DbSet<UserClient> userClient { get; set; }
        public DbSet<PasswordHistory> PasswordHistories { get; set; }
        public DbSet<ResetToken> ResetTokens { get; set; }
        public DbSet<Subscription> subscription { get; set; }

        public DbSet<ClientMFR> ClientMFR { get; set; }

        public DbSet<ClientRelease> ClientRelease { get; set; }

        public DbSet<ClientPackException> ClientPackException { get; set; }
        public DbSet<SubscriptionMarket> subscriptionMarket { get; set; }
        public DbSet<ServiceTerritory> serviceTerritory { get; set; }

        //Territory
        public System.Data.Entity.DbSet<Territory> Territories { get; set; }
        public System.Data.Entity.DbSet<Level> Levels { get; set; }
        public System.Data.Entity.DbSet<Group> Groups { get; set; }
        public System.Data.Entity.DbSet<Outlet> vwOutlet { get; set; }
        public System.Data.Entity.DbSet<Brick> vwBrick { get; set; }
        public System.Data.Entity.DbSet<OutletBrickAllocation> OutletBrickAllocations { get; set; }

        //Import
        public System.Data.Entity.DbSet<IRPClient> IRPClients { get; set; }
        public System.Data.Entity.DbSet<ClientMap> ClientMaps { get; set; }
        public System.Data.Entity.DbSet<Tdw_export_history> Tdw_export_history { get; set; }



        //Deliverables
        //Grouping       
        public System.Data.Entity.DbSet<MarketAttribute> MarketAttributes { get; set; }
        public System.Data.Entity.DbSet<MarketGroup> MarketGroups { get; set; }
        public System.Data.Entity.DbSet<MarketGroupPacks> MarketGroupPacks { get; set; }
        public System.Data.Entity.DbSet<MarketGroupMapping> MarketGroupMapping { get; set; }
        public System.Data.Entity.DbSet<MarketGroupFilter> MarketGroupFilters { get; set; }
        //Deliverables
        public DbSet<Country> Countries { get; set; }
        public DbSet<DataType> DataTypes { get; set; }
        public DbSet<Deliverables> deliverables { get; set; }
        public DbSet<DeliveryClient> DeliveryClients { get; set; }
        public DbSet<DeliveryMarket> DeliveryMarkets { get; set; }
        public DbSet<DeliveryTerritory> DeliveryTerritories { get; set; }
        public DbSet<File> Files { get; set; }
        public DbSet<FileType> FileTypes { get; set; }
        public DbSet<FrequencyType> FrequencyTypes { get; set; }
        public DbSet<Frequency> Frequencies { get; set; }
        public DbSet<DeliveryType> DeliveryTypes { get; set; }
        public DbSet<ReportWriter> ReportWriters { get; set; }
        //public DbSet<Restriction> Restrictions { get; set; }
        public DbSet<Service> Services { get; set; }
        public DbSet<Source> Sources { get; set; }
        public DbSet<Period> Periods { get; set; }
        public DbSet<PeriodForFrequency> PeriodForFrequencies { get; set; }
        public DbSet<ThirdParty> ThirdParties { get; set; }
        public DbSet<DeliveryThirdParty> DeliveryThirdParties { get; set; }
        public DbSet<ServiceConfiguration> ServiceConfigurations { get; set; }
        public DbSet<EntityType> EntityTypes { get; set; }
        public DbSet<SubChannels> SubChannels { get; set; }

        public DbSet<ReportParamList> ReportParameters { get; set; }
        public DbSet<ReportSection> ReportSections { get; set; }

        public DbSet<ReportFilter> ReportFilters { get; set; }

        public DbSet<ReportFieldList> ReportFilterFields { get; set; }

        public DbSet<ReportFieldsByModule> ReportFieldsByModule { get; set; }

        public DbSet<MoleculeDetail> Molecules { get; set; }

        public DbSet<MarketDefinitions_History> MarketDefinitions_History { get; set; }
        public DbSet<MarketDefPack_History> MarketDefPack_History { get; set; }

        public DbSet<AdditionalFilter_History> AdditionalFilter_History { get; set; }

        public DbSet<MarketDefBaseMap_History> MarketDefBaseMap_History { get; set; }

        public DbSet<MarketBase_History> MarketBase_History { get; set; }

        public DbSet<BaseFilter_History> BaseFilter_History { get; set; }

        public DbSet<Subscription_History> Subscription_History { get; set; }

        public DbSet<SubscriptionMarket_History> SubscriptionMarket_History { get; set; }

        public DbSet<User_History> User_History { get; set; }
        public DbSet<UserClient_History> UserClient_History { get; set; }

        public DbSet<UserRole_History> UserRole_History { get; set; }

        public DbSet<Territories_History> Territories_History { get; set; }

        public DbSet<Levels_History> Levels_History { get; set; }

        public DbSet<Groups_History> Groups_History { get; set; }

        public DbSet<ReportFilter_History> ReportFilter_History { get; set; }

        public DbSet<OutletBrickAllocations_History> OutletBrickAllocations_History { get; set; }

        public DbSet<Deliverables_History> Deliverables_History { get; set; }

        public DbSet<DeliveryClient_History> DeliveryClient_History { get; set; }

        public DbSet<DeliveryMarket_History> DeliveryMarket_History { get; set; }

        public DbSet<DeliveryTerritory_History> DeliveryTerritory_History { get; set; }

        public DbSet<DeliveryThirdParty_History> DeliveryThirdParty_History { get; set; }
       
        public DbSet<DimOutlet> Outlets { get; set; }

        public DbSet<DeliveryReport> DeliveryReports { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingEntitySetNameConvention>();
            Database.SetInitializer<EverestPortalContext>(null);
            //market base
            modelBuilder.Entity<BaseFilter>().HasKey(x => x.Id);
            //one-to-many relationship 
            modelBuilder.Entity<BaseFilter>().HasRequired<MarketBase>(c => c.MarketBase)
                    .WithMany(s => s.Filters)
                    .HasForeignKey(c => c.MarketBaseId);


            modelBuilder.Entity<Territory>().HasKey(t => t.Id);
            modelBuilder.Entity<Territory>().Property(b => b.Id).HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            modelBuilder.Entity<MarketBase_History>().HasMany(p => p.Filters).WithRequired(c => c.MarketBase_History)
                   .HasForeignKey(c => new { c.MarketBaseMBId, c.MarketBaseVersion });

            modelBuilder.Entity<Level>().HasKey(x => x.Id);
            //one-to-many relationship 
            modelBuilder.Entity<Level>().HasRequired<Territory>(c => c.Territory)
                    .WithMany(s => s.Levels)
                    .HasForeignKey(c => c.TerritoryId);

            modelBuilder.Entity<OutletBrickAllocation>().HasKey(x => x.Id);
            modelBuilder.Entity<OutletBrickAllocation>().HasRequired<Territory>(c => c.Territory)
                    .WithMany(s => s.OutletBrickAllocation)
                    .HasForeignKey(c => c.TerritoryId);
            

            modelBuilder.Entity<Group>()
               .HasOptional(x => x.Parent)
               .WithMany(x => x.Children)
               .HasForeignKey(x => x.ParentId)
               .WillCascadeOnDelete(false);


            modelBuilder.Entity<Pack>()
                .HasMany<MarketBase>(s => s.marketBase)
                .WithMany(c => c.pack)
                .Map(cs =>
                {
                    cs.MapLeftKey("PackId");
                    cs.MapRightKey("MarketBaseId");
                    cs.ToTable("PackMarketBases");
                });
        }


    }
}