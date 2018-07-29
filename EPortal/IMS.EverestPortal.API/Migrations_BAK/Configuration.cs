namespace IMS.EverestPortal.API.Migrations
{
    using Models;
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<IMS.EverestPortal.API.DAL.EverestPortalContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(IMS.EverestPortal.API.DAL.EverestPortalContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //

            var newsAlerts = new List<NewsAlert> {
            new NewsAlert{ newsAlertTitle="2016 Eagle Award",newsAlertDescription="QuintilesIMS wins society for clinical research sites 2016 Eagle award.",newsAlertImageUrl="",newsAlertAltImage="AltText 2016 Eagle Award", newsAlertCreatedBy="admin"},
            new NewsAlert{newsAlertTitle="Perfect partnership",newsAlertDescription="GDC and Canada Consulting teams deliver Market landscape reports for Astellas.",newsAlertImageUrl="",newsAlertAltImage="AltText Perfect partnership", newsAlertCreatedBy="admin"},
            new  NewsAlert{newsAlertTitle="IMS Institute Study",newsAlertDescription="Low Levels of Adherence and Persistence Remain Barriers to Reducing Costs of Diabetes Complications ",newsAlertImageUrl="",newsAlertAltImage="AltText IMS Institute Study",newsAlertCreatedBy="admin"}
            };
            newsAlerts.ForEach(s => context.NewsAlerts.Add(s));

            var cadPages = new List<CADPage> {
            new CADPage{ cadPageTitle="CAD Page 1", cadPageDescription="",cadPagePharmacyFileUrl="", cadPageHospitalFileUrl="", cadPageCreatedBy="admin"},
            new CADPage{ cadPageTitle="CAD Page 2", cadPageDescription="",cadPagePharmacyFileUrl="", cadPageHospitalFileUrl="", cadPageCreatedBy="admin"},
            new CADPage{ cadPageTitle="CAD Page 3", cadPageDescription="",cadPagePharmacyFileUrl="", cadPageHospitalFileUrl="", cadPageCreatedBy="admin"}
            };
            cadPages.ForEach(c => context.CADPages.Add(c));

            var listings = new List<Listing> {
            new Listing{ listingTitle="Listing Page1", listingDescription="",listingPharmacyFileUrl="", listingHospitalFileUrl="",  listingCreatedBy="admin"},
            new Listing{ listingTitle="Listing Page2", listingDescription="",listingPharmacyFileUrl="", listingHospitalFileUrl="",  listingCreatedBy="admin"},
            new Listing{ listingTitle="Listing Page3", listingDescription="",listingPharmacyFileUrl="", listingHospitalFileUrl="",  listingCreatedBy="admin"}
            };
            listings.ForEach(l => context.Listings.Add(l));

            var monthlydataSummary = new List<MonthlyDataSummary> {
            new MonthlyDataSummary{monthlyDataSummaryTitle="Monthly Data Summary1", monthlyDataSummaryDescription="", monthlyDataSummaryFileUrl="",monthlyDataSummaryCreatedBy="admin"},
            new MonthlyDataSummary{monthlyDataSummaryTitle="Monthly Data Summary2", monthlyDataSummaryDescription="", monthlyDataSummaryFileUrl="",monthlyDataSummaryCreatedBy="admin"},
            new MonthlyDataSummary{monthlyDataSummaryTitle="Monthly Data Summary3", monthlyDataSummaryDescription="", monthlyDataSummaryFileUrl="",monthlyDataSummaryCreatedBy="admin"}
            };
            monthlydataSummary.ForEach(mds => context.MonthlyDataSummaries.Add(mds));

            var popularLinks = new List<PopularLink> {
            new PopularLink{popularLinkTitle="Contact IMS Health", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=1, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="Delivery Schedule", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=2, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="FAQ on Client Portal", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=3, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="How to Use Document", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=4, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="CBG/SFE/Marketing Dashboard", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=5, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="MiPortalLogin", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=6, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="IMS Analysis Manger Login", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=7, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="Cegedim", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=8, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="Channel Dynamics", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=9, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="Nostra Data", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=10, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="Direct Marketing", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=11, popularLinkCreatedBy="admin"},
            new PopularLink{popularLinkTitle="IMS HEalth Website", popularLinkDescription="Link to contact IMS health", popularLinkDisplayOrder=12, popularLinkCreatedBy="admin"}
            };
            popularLinks.ForEach(pl => context.PopularLinks.Add(pl));


            context.SaveChanges();
        }
    }
}
